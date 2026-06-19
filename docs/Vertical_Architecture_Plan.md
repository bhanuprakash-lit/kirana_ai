# Vertical Expansion — Architecture & Development Plan

> The companion to `Gap_Fill_Playbook.md`. The playbook says *what features* to build and how ~80% collapse onto 4 foundations. **This doc fixes the architecture those foundations sit on** — how verticals are isolated, how login/routing works, how data is modelled so cross-vertical analytics stays easy, and the safe build order for the isolation spine.

---

## 1. Locked decisions

| # | Decision | Consequence |
|---|---|---|
| D1 | **Single DB, one schema per vertical.** `kirana_oltp` = grocery (today, untouched); `apparel_oltp`, `electronics_oltp`, … added later. | A store lives in exactly **one** schema. A vertical can be lifted out later via `pg_dump -n <schema>`. |
| D2 | **No _business_ data shared between verticals.** | No cross-schema joins. Grocery orders never touch apparel orders. Even the same owner's two stores are fully independent (separate customers, products, udhaar). |
| D3 | **One thin SHARED control plane** (`platform` schema): identity + store directory only — **zero business data.** | Required by D4: you can't show a grocery store and an apparel store in one list after one login without a shared "who owns what" layer. |
| D4 | **Single app, single login, multi-store.** Owner logs in once → sees their registered stores → picks one → that store loads. Same app for every vertical (config-driven, no per-vertical app builds). | Routing is decided **by the store you pick**, not by anything asked at login. |
| D5 | **Stores independent now; merge/analytics later is opt-in.** If they ever want cross-store reporting, they copy/union into a reporting layer — never by coupling the live schemas. | Drives the data-modelling rule in §3. |

### The shared / isolated boundary

```
SHARED  (platform schema — control plane, NO business data)
  app_user        (login: phone OTP)
  store_registry  (store_id, owner_user_id, vertical_code, store_name, status)
        │
        ▼  owner logs in → list their stores → pick store 47
  resolve store 47 → vertical_code='apparel' → SET search_path = apparel_oltp
        │
        ▼
PER-VERTICAL BUSINESS DATA  (fully isolated, identical SHAPE)
  kirana_oltp        apparel_oltp        electronics_oltp     …
  (grocery: all      (apparel: all       …
   products, orders,  products, orders,
   customers, udhaar) customers, udhaar)
```

> **"Nothing shared between verticals" = no business data crosses.** Identity + the store directory are shared but hold only "user X owns stores [12 (grocery), 47 (apparel)]."

---

## 2. Login & request routing

1. Owner authenticates (phone OTP) against `platform.app_user`.
2. Backend returns the owner's stores from `platform.store_registry` (each with `store_id`, `vertical_code`, `store_name`).
3. App shows the store picker; owner selects a store.
4. Every request for that session carries the selected `store_id`; the backend resolves `store_id → vertical_code → SET search_path = <vertical>_oltp`.
5. All business queries run unqualified and therefore hit the resolved schema. Identity/registry queries explicitly target `platform`.
6. **Switching store = re-resolve vertical + reload the app's data providers.**

No "which vertical?" prompt at login, and no vertical baked into the token — the picked store is the source of truth.

---

## 3. Data-modelling rule (keeps merge/analytics easy)

**Problem:** if vertical differences become different *columns* (apparel `size`/`colour`, electronics `serial`, grocery `expiry`), schemas drift apart in shape and a future cross-vertical `UNION ALL` falls apart.

**Rule: never let a vertical difference become a different column.** Split every transactional table into a stable core + a JSONB bag.

| Kind of data | Where it lives | Unionable for analytics? |
|---|---|---|
| **Common core** — date, total, qty, price, customer, payment, stock, credit | real columns, **identical in every schema** | ✅ yes — this is what you UNION |
| **Vertical attributes** — size, colour, expiry, serial, shade | one `attributes JSONB` column — **same column everywhere**, content differs | ✅ column unions fine; unpack JSON only for vertical-specific cuts |
| **Vertical-only entities** — salon appointments, electronics serials | extra *tables* in that schema only | not unioned — analytics ignores them |
| **Config** — units, KPI set, feature flags, copy | that vertical's `vertical_config` row (metadata) | never part of analytics — it's settings |

```
product / variant   (identical shape in EVERY schema)
  product_id, store_id, name, price, mrp, cost, is_active, attributes JSONB
                                                            ▲
  grocery:     {"expiry":"2026-08-01","loose":true}        │
  apparel:     {"size":"M","colour":"blue"}        ─────────┘  content differs,
  electronics: {"serial":"X123","warranty_months":12}          column does NOT
```

This is exactly the `product_variant.attributes JSONB` + `product_attribute_def` model from Foundation 2 — the foundation exists *to avoid per-vertical columns*.

**Provisioning rule:** every vertical schema is created from the **same parameterized DDL template** (`_ensure_schema(schema_name)`), run once per vertical. No hand-edited per-vertical tables → shapes never drift.

**Future merge** is a reporting view over the common columns only:

```sql
CREATE VIEW analytics.all_orders AS
  SELECT 'grocery' AS vertical, order_id, store_id, order_date, total_amount, payment_method
    FROM kirana_oltp.orders
  UNION ALL
  SELECT 'apparel', order_id, store_id, order_date, total_amount, payment_method
    FROM apparel_oltp.orders;
-- revenue / credit / footfall by vertical = trivial GROUP BY vertical
```

Because the view touches only the stable core, apparel's `size` or electronics' `serial` never break it. Within-vertical analytics (e.g. apparel size-curve) unpacks `attributes` and never needs another vertical's shape.

---

## 4. Phase 0 — the isolation spine (build in 4 safe stages)

The risky part: ~1,106 hardcoded `kirana_oltp.` refs across 44 files + splitting identity out. Build it so **nothing user-visible changes and grocery keeps working until the very end.**

**Stage 0a — Routing seam (zero behaviour change)**
- `resolve_vertical(store_id) → vertical_code` (returns `'grocery'` for everyone today) + a per-request hook doing `SET search_path = <vertical>_oltp`. Default stays `kirana_oltp`.
- Proves the plumbing while every query still lands where it does today. Risk: ~zero.

**Stage 0b — De-qualify the 1,106 refs (behaviour-preserving)**
- Strip the literal `kirana_oltp.` prefix from business queries so they follow `search_path`.
- Scripted across the 44 files; gate with the full backend test suite + `import main`. With `search_path=kirana_oltp` default, grocery is identical. Risk: medium, contained (mechanical + tests).

**Stage 0c — Split identity out (the one shared layer)**
- Create `platform` schema with `app_user` (login) + `store_registry`; backfill from today's `kirana_oltp.users`/`store`.
- Vertical→platform references become **plain id columns, no cross-schema FK**. Auth resolves the user against `platform`; the store picker reads `store_registry`.
- Risk: medium — touches auth + FKs; do with backfill + a migration guard.

**Stage 0d — Provision a second vertical & prove isolation**
- Run the DDL template into `apparel_oltp`, register one apparel store, log in → see both stores → pick apparel → confirm it loads apparel data and **cannot see grocery data**.
- Proves the whole isolation contract end-to-end before any feature work.

---

## 5. Phases 1–5 (ride the spine) and gaps covered

Order: **0 → 1 → 2 → 3 → 4 → 5.** Don't build variant-dependent features before Phase 2 lands.

| Phase | What we build | Gaps covered |
|---|---|---|
| **1. Vertical config** (per-schema, ~3–4 d) | 1-row `vertical_config` table in each schema (features/units/kpi_set/ml_profile/tax/copy); `GET /vertical-config`; FE `verticalConfigProvider` + `vf.has('expiry')`; onboarding vertical picker | G-03, G-09, G-16, G-24, G-29, G-31, G-32, G-19/20/21/25 (gating), Guru onboarding picker (~10) |
| **2. Variants + attributes** (keystone, ~1.5 wk) | `product_variant` + `product_attribute_def`; inventory/order_item → `variant_id`; **grocery = one implicit variant** (old queries keep working); size×colour grid; POS variant picker | G-04 (Guru Critical), G-05, G-11, G-22, G-23(+F3), G-34; serial/IMEI (G-06) + warranty (G-07) as child tables |
| **3. Tax / GST** (~3–4 d) | `tax_rule` + `product.hsn_code/gst_rate`; apply at checkout; tax lines on cart/order/receipt | G-10, G-23, Guru "GST-compliant invoicing", margin accuracy |
| **4. KPI / ML / AI packs** (~1 wk/vertical) | config → named KPI/ML/prompt set; dashboard reads `vf.kpiSet`; per-profile ML thresholds; AI grounded on the store's own catalog | G-13–G-21, Guru demand-forecast / price-optimisation / anomaly (tuning, not new engines) |
| **5. New modules** (standalone) | loyalty engine; services/appointments; staff ops; multi-store rollup; light add-ons (coupons, proforma, split-pay, returns reason-codes) | the genuinely-new ~20% (Guru's Loyalty/Saloon/Commission/Zone gaps) |

See `Combined_Gap_Backlog.xlsx` for every gap → foundation → owner/effort/priority.

---

## 6. Open items to confirm before/while building

- **Staff/employee logins per store** — out of scope for now (owner login only). Revisit with Phase 5 staff-ops.
- **Subscription/billing** — lives in `platform` (it's identity-adjacent, not business data). Confirm when billing work starts.
- **Store business detail vs registry split** — registry holds only what the picker + routing need (`store_id`, owner, `vertical_code`, name, status); full store settings (budget, footfall, address) stay in the vertical schema so a vertical lifts out complete.
