# Phase 0 — Per-Vertical Schema Isolation: Complete Migration Plan

Implements decisions **D1–D5** from `Vertical_Architecture_Plan.md`: move from today's
**single `kirana_oltp` schema (all verticals, discriminated by `store_id`/`vertical_code`)**
to **one schema per vertical** (`kirana_oltp`=grocery, `apparel_oltp`, `electronics_oltp`,
`optical_oltp`, `footwear_oltp`, `services_oltp`, `general_oltp`) + a shared **`platform`**
control plane (identity + store directory only). No loose points — every chokepoint,
background job, and data move is covered below.

---

## 0. Current reality (the starting line)

- **One Postgres DB**, schemas: `kirana_oltp` (all business data, all verticals), `kirana_olap` (analytics rollups), `platform` (currently holds only a stray `vertical_config` — unused by the app), `public`, `enterprise_*` (unrelated).
- **One shared SQLAlchemy `engine`** (created in `main.py`) feeds **everything**: `KiranaRepository`, the pos `SessionFactory` (`app.state.db_session`), the `oltp` generic layer, `ml_adapter`, `intelligence`, `kpis`, `vision`. ← *This single engine is what makes routing tractable.*
- **`kirana_oltp.` is hardcoded 1374× across 76 `.py` files** (top: `repositories/base.py` 262, `db_generation/ensure_full_schema.py` 221, `kpis/calculators/*` ~170, `repositories/*` ~250).
- **Identity lives in `kirana_oltp`**: `users`, `user_sessions`, `user_fcm_tokens`, `store`, plus the multi-store bits we just added (`store_user`, `users.store_id` active pointer) and `subscription`.
- **`oltp/repository.py`** reflects metadata with a hardcoded `MetaData(schema="kirana_oltp")`.
- **Cross-store background work** (`intelligence/engine.py`) iterates `SELECT DISTINCT store_id FROM kirana_oltp.inventory`.
- Auth resolves a token via `kirana_oltp.user_sessions ⨝ users` (happens *before* any vertical is known).

---

## 1. Target topology

```
platform                         (SHARED control plane — NO business data)
  app_user            (user_id PK [GLOBAL], phone, password_*, full_name, status, fcm…)
  user_session        (access_token, user_id, …)        ← auth resolves here
  user_fcm_token      (user_id, fcm_token)               ← FCM resolves here
  store_registry      (store_id PK [GLOBAL], owner_user_id, vertical_code, name, status, city)
  store_user          (user_id, store_id, role)          ← multi-store membership
  subscription        (store_id, tier, trial…)           ← identity-adjacent (D-§6)
  kpi_visibility_config (kpi_id, vertical_code, is_visible)  ← admin, cross-vertical
  app_settings / vouchers / issue_report / telemetry … (anything truly cross-vertical/admin)

<vertical>_oltp   (IDENTICAL SHAPE, created from one DDL template, fully isolated)
  store (store_id PK = the global id, NOT a serial), product, product_variant,
  product_attribute_def, category, inventory, inventory_batch, pricing, orders,
  order_item, payment, customer, khata, loyalty_*, coupon, service, appointment,
  membership, staff*, estimate*, sales_return, inventory_location, product_serial,
  warranty_claim, wishlist, job_card, vertical_config (1 row), baskets, referral, …

kirana_olap        (analytics; per-vertical rollups or a unioned reporting view)
```

**Hard rules**
- A store's business data lives in **exactly one** vertical schema. No cross-schema joins, no cross-schema FKs — vertical→platform references are **plain id columns** (`user_id`, `store_id`), validated in app code, not by FK.
- `store_id` and `user_id` are **globally unique**, allocated by `platform` sequences. `product_id`/`order_id`/`customer_id` are **local** to each schema (never referenced cross-schema).
- Every vertical schema is built from the **same parameterized DDL** so shapes never drift.

---

## 2. Routing mechanism (the spine) — Stage 0a

Because there's **one engine**, route with a `ContextVar` + a pool **checkout** listener. No raw query changes needed for this stage (default stays grocery).

```python
# db/routing.py
import contextvars
from sqlalchemy import event, text
_current_schema: contextvars.ContextVar[str] = contextvars.ContextVar("schema", default="kirana_oltp")

def set_current_schema(schema: str): _current_schema.set(schema)

def install_search_path_routing(engine):
    @event.listens_for(engine, "checkout")
    def _set_search_path(dbapi_conn, conn_record, conn_proxy):
        schema = _current_schema.get()
        cur = dbapi_conn.cursor()
        cur.execute(f'SET search_path TO "{schema}", platform, public')
        cur.close()
```

- **Request middleware** (after auth resolves the active store): `set_current_schema(resolve_schema(store_id))`. `resolve_schema` reads `platform.store_registry.vertical_code → "<vertical>_oltp"`.
- **Auth/identity queries explicitly qualify `platform.`** (they run before a vertical is chosen, and must never be routed).
- ContextVars propagate into Starlette's sync-route threadpool (`anyio.to_thread` copies context) and async routes. **Background tasks + cron + the intelligence loop do NOT inherit it** → they must call `set_current_schema()` explicitly per store (see §7).
- `search_path` includes `platform` second so identity tables are reachable unqualified if ever needed, and `public` for extensions (`pg_trgm`).
- Pool safety: because we `SET` on **every checkout**, a recycled connection can never carry a stale schema.

**Stage 0a deliverable:** `resolve_schema()` returns `'kirana_oltp'` for everyone (registry seeded all-grocery), listener installed. **Zero behaviour change.** Gate: full suite + `import main` + manual smoke.

---

## 3. De-qualification — Stage 0b

Strip the `kirana_oltp.` prefix from **business** queries so they follow `search_path`; **repoint identity** queries to `platform.`; **leave** OLAP qualified.

| Ref class | Action | How identified |
|---|---|---|
| Business tables (product, orders, inventory, customer, khata, loyalty, service, …) | **de-qualify** → bare table name | everything not in the identity/olap lists |
| Identity (`users`, `user_sessions`, `user_fcm_tokens`, `store`*, `store_user`, `subscription`, `kpi_visibility_config`) | **repoint** → `platform.` | explicit allowlist |
| OLAP (`kirana_olap.*`) | **leave as-is** | schema literal `kirana_olap` |
| DDL template (`base.py`) | parameterize (§6), not de-qualify | the `_ensure_schema` body |

\* `store` is special: a thin row exists in **both** `platform.store_registry` (routing) and `<vertical>_oltp.store` (full settings). Business code reading store *settings* (budget/footfall/address) → vertical (de-qualified); routing/ownership/listing → `platform.store_registry`.

**Execution:** scripted, file-by-file, in dependency order. After each batch: run the 159 backend tests + `import main`. With `search_path` defaulting to `kirana_oltp`, **grocery stays byte-identical**. Risk: medium, fully test-gated. ~1374 refs; the allowlist (identity/olap) is ~120 refs, the rest de-qualify.

**Guard-rail added same stage:** a lint test that fails if a new `kirana_oltp.`/`<vertical>_oltp.` literal appears in business code (forces de-qualified queries going forward).

---

## 4. Identity / control plane split — Stage 0c

1. Create `platform` schema + tables (above). `user_id`/`store_id` use **global sequences** in `platform`.
2. **Backfill** from today's `kirana_oltp`:
   - `platform.app_user` ← `kirana_oltp.users` (same user_id).
   - `platform.user_session`/`user_fcm_token` ← copy.
   - `platform.store_registry` ← `kirana_oltp.store` (store_id, owner = users.store_id reverse map / store_user, vertical_code from `store.vertical_code`, name, city, status).
   - `platform.store_user` ← move the table we just built.
   - `platform.subscription` ← `kirana_oltp.subscription`.
   - `platform.kpi_visibility_config` ← copy.
3. **Auth rewrite:** `get_user_by_token`, `register_*`, `set_active_store`, `list_user_stores`, `send_fcm_to_user`, `update_fcm_token`, subscription read/write → query `platform.` explicitly.
4. **Routing dependency:** resolve `store_id → platform.store_registry.vertical_code → schema`, `set_current_schema()`.
5. **No cross-schema FK:** vertical tables keep `user_id`/`store_id` as plain BIGINT (drop FK to users; store FK stays within schema to the local `store` row).
- Risk: medium-high (touches auth). Backfill + a migration-version guard + a "dual-read" window (read platform, fall back to kirana_oltp) during cutover. Gate: auth tests + login smoke on every login method (phone, password, token-from-kirana, POS token).

---

## 5. store_id / user_id allocation & FK rule

- **Registration** (`register_store_owner`): `INSERT platform.app_user` → user_id; `INSERT platform.store_registry(vertical_code)` → store_id; `set search_path` to that vertical; `INSERT <vertical>_oltp.store(store_id=…)` + the store's `vertical_config` row; `INSERT platform.store_user`.
- **Add store** (`add_store_for_user`): `INSERT platform.store_registry` → store_id; provision target schema if missing; `INSERT <vertical>_oltp.store`; `platform.store_user`. (Subscription stays per-store in platform — matches the manager's "each store its own subscription".)
- **Switch store** (`set_active_store`): membership check in `platform.store_user`; update active pointer (`platform.app_user.active_store_id`); the next request's middleware resolves the new schema. FE already re-mints the POS token + invalidates providers.
- Vertical `store.store_id` is **assigned, not serial** (sequence owned by platform). All other PKs stay local serials.

---

## 6. DDL template (one shape, many schemas) — supports 0a/0d

- Refactor `repositories/base.py::_ensure_schema` → `_ensure_schema(schema_name)`: every `CREATE/ALTER/INDEX/seed` targets `{schema}` (f-string the schema, keep table names). Same body builds `kirana_oltp` and any `<vertical>_oltp`.
- `vertical_config` becomes a **per-schema 1-row** table (the schema *is* the vertical). The cross-vertical `kpi_visibility_config` moves to `platform`.
- Provisioning a vertical = `CREATE SCHEMA IF NOT EXISTS <v>_oltp; _ensure_schema('<v>_oltp')`. Run once per vertical at boot (idempotent) for verticals that have ≥1 store, plus on-demand when a store of a new vertical is first added.
- `ensure_full_schema.py` (the greenfield DDL) gets the same parameterization.

---

## 7. Cross-schema / background work (explicit loose-point closure)

| Concern | Today | After |
|---|---|---|
| **OLTP generic layer** (`oltp/repository.py`) hardcodes `MetaData(schema="kirana_oltp")` | single reflect | per-schema metadata cache keyed by current vertical; reflect each `<v>_oltp` lazily; pick by `_current_schema` |
| **Intelligence loop** iterates `DISTINCT store_id FROM kirana_oltp.inventory` | one schema | iterate `platform.store_registry`; for each store `set_current_schema()` then run its (de-qualified) analysis |
| **ML adapter / OLAP** read `kirana_oltp`, write `kirana_olap` | one schema | run per vertical schema (loop), tag rollups with vertical; or a unioned reporting view (§3 of arch plan) |
| **BackgroundTasks** (vision analysis, FCM) | inherit nothing | pass the resolved `schema` into the task and `set_current_schema()` at its start; FCM/identity always `platform.` |
| **Admin panel** (Stores, KPI visibility, loyalty overview, deep-dive) cross-vertical | one schema | list from `platform.store_registry`; per-store detail fans out to that store's schema |
| **KPI calculators** | `kirana_oltp.` literals | de-qualified; run with search_path = the store's schema (one store = one schema, already the case) |
| **Cron / scheduled jobs** | one schema | same explicit `set_current_schema()` per store as the intelligence loop |
| **Connection pool** | n/a | `SET search_path` on every checkout (no stale state) |
| **Transactions** | within schema | never span schemas; platform writes + vertical writes are separate txns (app-level consistency, no 2PC) |

---

## 8. Data migration of EXISTING stores — Stage 0e

Today all 43 stores are in `kirana_oltp`. Grocery + legacy stay; **non-grocery stores must move** to their vertical schema.

1. **Provision** target schemas (`_ensure_schema('<v>_oltp')`).
2. **Backfill platform** from `kirana_oltp` (§4.2).
3. For each non-grocery store S (vertical V): **copy** its rows (FK-ordered: store→category→product→variant→inventory→pricing→customer→orders→order_item→payment→khata→loyalty→…) from `kirana_oltp` into `<V>_oltp`, **preserving store_id** and local ids (or remapping local ids per schema). Then **delete** S's rows from `kirana_oltp` once verified.
   - Per-store copy script, parameterized by the table list (the same list the DDL template builds). Wrap each store in a transaction; verify row counts; keep a dry-run mode.
4. **Verify isolation:** after move, `SELECT … WHERE store_id=S` returns 0 in `kirana_oltp` and full in `<V>_oltp`; app login → store S loads from `<V>_oltp` and cannot see grocery.
5. The **test stores we seeded** (37 electronics, 38 optical, 40 apparel, 41 footwear, 42 services, 43 general) are the first migration candidates — perfect rehearsal data.

Reversible: the copy keeps `kirana_oltp` rows until the verify step passes; rollback = don't delete + repoint registry back to grocery routing.

---

## 9. Staged rollout (safe order, gates, rollback)

| Stage | Scope | Gate (must pass) | Rollback |
|---|---|---|---|
| **0a** Routing seam | contextvar + checkout listener + middleware; `resolve_schema`→grocery for all | 159+70 tests, `import main`, login smoke | remove listener (no-op) |
| **0b** De-qualify 1374 refs + lint guard | scripted, batched | tests after each batch; grocery byte-identical | revert batch |
| **0c** Identity split → `platform` | tables + backfill + auth rewrite + dual-read | auth tests + all login methods + FCM smoke | dual-read falls back to `kirana_oltp` |
| **0d** Parameterize DDL + provision 2nd schema | `_ensure_schema(schema)`; provision `electronics_oltp`; register a test store there | new store loads its schema; cannot see grocery | drop the new schema |
| **0e** Migrate existing non-grocery stores | per-store copy+verify+delete | per-store row-count + isolation checks | keep source rows |
| **0f** Cutover + cleanup | flip registration to allocate per vertical; remove dual-read; remove single-schema fallbacks | full regression + tester pass | re-enable dual-read |

Don't start 0b until 0a is green; don't start 0e until 0d proves isolation end-to-end.

---

## 10. Testing strategy
- Existing **159 backend + 70 FE** suites must stay green through every stage (they pin grocery behaviour).
- **New isolation tests:** (a) a store in `apparel_oltp` cannot read `kirana_oltp` rows; (b) same `store_id` never appears in two schemas; (c) auth/identity always resolves from `platform` regardless of `search_path`; (d) pool-recycle can't leak schema; (e) background task sets its own schema.
- **Cross-vertical leak test** in CI: assert no business query runs without an active `_current_schema` (catch un-routed reads).
- DB-backed tests finally run against a throwaway schema set (`TEST_DATABASE_URL`).

## 11. Impact on what we just built
- **Multi-store** (`store_user`, active pointer, my-stores/add/switch) → moves into `platform` (small repoint; the FE is unaffected — same endpoints).
- **Per-store subscriptions** → already correct; the table moves to `platform`.
- **Vertical-scoped categories/catalog/products/copyPack** → become *native* (each schema only has its own categories/products; the `vertical_code` discriminator columns can be dropped later since the schema *is* the vertical — optional cleanup).
- **vertical_config** → per-schema 1-row (drop the discriminator); `kpi_visibility_config` → platform.
- Seeded test stores → the Stage 0e rehearsal set.

## 12. Effort & sequencing (estimate)
- 0a ~0.5 d · 0b ~2–3 d (scripted + test cycles) · 0c ~2–3 d (auth is the risk) · 0d ~1 d · 0e ~1–2 d (copy script + verify) · 0f ~1 d + tester regression. **~1.5–2 weeks** of focused work, single-developer, fully test-gated. Feature work pauses during 0b/0c (they touch everything).

## 13. Loose-points register (all resolved above)
1. Single engine → contextvar+checkout routing (§2). 2. 1374 refs → scripted de-qualify + allowlist + lint guard (§3). 3. Identity before vertical known → platform-qualified auth (§4). 4. store_id/user_id collisions → global platform sequences (§5). 5. oltp generic reflect → per-schema metadata cache (§7). 6. intelligence/ML/cron cross-store → explicit per-store `set_current_schema` (§7). 7. BackgroundTasks contextvar → pass schema in (§7). 8. Admin cross-vertical → registry + fan-out (§7). 9. Pool stale schema → set-on-checkout (§2). 10. Existing data → per-store copy/verify/delete migration (§8). 11. No cross-schema FK → plain id columns (§4/§5). 12. Rollback → dual-read + keep-source-until-verified (§9).

---

*Nothing here is implemented yet — this is the plan for review. On approval, start at Stage 0a (zero-behaviour-change routing seam).*
