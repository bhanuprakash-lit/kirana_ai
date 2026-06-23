# Kirana AI — Performance & Cleanup Analysis

Evidence-based review of backend + frontend for redundant work, perf hotspots,
duplication, and illogical/unnecessary actions. Each item has the file, the
impact, and a concrete fix. Prioritised **P0** (do soon) → **P3** (nice-to-have).

## ✅ Fixes applied (this pass)
- **B1 (done):** `/kirana/stores` now summarises only the caller's store (`list_stores(only_store_ids=...)`) instead of looping every store and discarding the rest.
- **B4 (done):** guarded `pg_trgm` GIN index on `product.name` for catalog search (CREATE EXTENSION wrapped in a DO/EXCEPTION so it can't crash boot on managed PG).
- **A1/A2 root cause (done):** dashboard was an eager `IndexedStack` (all tabs built on load → every tab's providers fetched at once). Now a **lazy IndexedStack** — a tab builds only when first opened, then stays alive. Finance/POS/Vision no longer fetch on the initial home load; this removes the bulk of the duplicate `recommendations`/`products`/`pricing` calls.
- **C3 (partial):** added route tests for the new endpoints (`tests/routes/test_stores_multi.py`: my-stores/add/switch + gst-summary auth & validation). Backend now **159 passed**.

**Still open (documented below, not yet done):** A3 (activeStoreIdProvider), A4 (auth/me ×2), A5 (product pagination), B2 (shared router deps), B3 (request-scoped repo), B5 (POS membership check), B6 (migration-version table), C1/C2/C4. These are lower-risk-to-defer cleanups.

---

## Test status (baseline)
- **Backend:** `pytest` → **149 passed, 21 skipped** (skipped = DB-integration tests needing `TEST_DATABASE_URL`; not run against the live dev DB on purpose). No regressions.
- **Frontend:** `flutter test` → **70 passed**; `flutter analyze` → clean.
- **Coverage gap:** the new endpoints/screens from this session (multi-store, vertical categories/catalog, GST report, POS deep-links) have **no automated tests** yet. See C3.

---

## A. Frontend — redundant network work (highest leverage)

### A1 (P1) — Same data fetched by multiple providers on one screen load
The shared backend logs show, in a single dashboard open:
- `GET /kirana/stores` ×3, `GET /kirana/stores/{id}/recommendations` ×3,
  `GET /pos/products` ×2, `GET /oltp/pricing` ×2, `GET /kirana/auth/me` ×2.

Root cause — independent providers each re-fetch overlapping data:
- `/kirana/stores`: `dashboard/providers/overview_provider.dart` **and**
  `profile/providers/store_settings_provider.dart` (both fetch the *whole* stores list and `firstWhere` client-side).
- `recommendations`: `overview_provider`, `pos_inventory/providers/inventory_provider.dart`, **and** `dashboard/providers/intelligence_provider.dart` — three separate calls for the same store.
- `/pos/products` + `/oltp/pricing`: `inventory_provider` **and** `pos_provider` each load the full product list (limit 1000) + pricing.

**Fix:** introduce shared source providers and have dependents read from them:
- `activeStoreProvider` (one fetch of the active store; overview + store-settings read it).
- `recommendationsProvider.family(storeId)` consumed by overview/inventory/intelligence.
- one `productsProvider` shared by POS + inventory (they already shape the same rows).
This alone removes ~6–8 duplicate calls per dashboard open.

### A2 (P1) — Store-switch invalidates ~11 providers, several overlapping
`features/stores/providers/stores_provider.dart::_refreshStoreScope` invalidates
vertical-config, subscription, pos, inventory, kpiCards, visibleKpis, overview,
storeSettings, customer, finance, loyaltyConfig. Correct for freshness, but `pos`
and `inventory` both then refetch products+pricing (see A1), and overview refetches
stores again. Once A1's shared providers exist, this cascade shrinks to the shared
sources + gating (`verticalConfig`, `subscription`).

### A3 (P2) — No single source of truth for the active `store_id`
~15 providers each do `SharedPreferences.getInstance()` + `getInt('store_id')` in
`build()`. Cheap individually, but it spreads the "current store" across the codebase
and makes invalidation manual. **Fix:** an `activeStoreIdProvider` seeded from prefs;
providers `watch` it (auto-rebuild on switch) instead of reading prefs ad-hoc — this
also makes A2 mostly automatic.

### A4 (P2) — `/kirana/auth/me` fetched twice on load
Confirm which two callers (likely `userProvider` + a screen). De-dupe to one.

### A5 (P3) — `products?limit=1000` fetched eagerly, unpaginated
Both POS and inventory pull up to 1000 products on open. Fine for small stores; add
server-side search/pagination before a store has thousands of SKUs.

---

## B. Backend

### B1 (P1) — `GET /kirana/stores` computes ML summary for ALL stores, returns one
`routers/stores.py::list_stores` → `service.list_stores()` loops **every** non-deleted
store (now 40+), calling `ml.store_summary(sid)` for each, then the route filters to
just the caller's store. So ~40× the needed work, and it's hit 2–3×/load (A1).
**Fix:** a store-scoped path — `list_stores(store_id=...)` that summarises only the
caller's store(s). (`store_summary` is in-memory pandas, so not catastrophic, but it's
pure waste repeated per request.)

### B2 (P1) — Duplicated auth/boilerplate across ~15 routers
Every router redefines identical `_auth`, `_repo`, `_require_*`, `_sid` helpers
(stores, loyalty, staff, warranty, tax, multistore, customer360, services, jobcards,
vision, …). Not a perf issue but a real maintenance/duplication smell and a place bugs
diverge. **Fix:** one `kirana/routers/_deps.py` with shared FastAPI dependencies; import
everywhere.

### B3 (P2) — New `KiranaRepository(engine)` per request, new connection per method
Routes build a fresh repo each request and each repo method opens its own
`engine.connect()` (`base.py::_conn`). Pooling absorbs it, but a multi-step endpoint
opens several short-lived connections. **Fix:** a request-scoped repo/connection
dependency; batch multi-statement methods on one connection. (Note: `_ensure_schema`
is correctly guarded by `_schema_initialized`, so it runs once per process — good.)

### B4 (P2) — `catalog/search` uses leading-wildcard ILIKE on the global product table
`routers/auth.py::catalog_search`: `p.name ILIKE '%q%'` over ~11k products can't use a
btree index. Fine today; add a `pg_trgm` GIN index on `product.name` (and `brand`)
before the catalog grows.

### B5 (P2) — POS trusts the `store_id` query param (multi-store surface)
`pos/routes.py::_resolve_store_scope` validates the requested `store_id` against the
POS JWT's store (good), but the kirana-side endpoints largely trust `?store_id=` from
the client. With multi-store this is worth a membership check (`store_user`) on
store-scoped reads, or deriving store strictly from the token.

### B6 (P3) — `_ensure_schema` does data-backfill UPDATEs every boot
Vision-key backfill, category grocery-backfill (guarded), copy_pack merge, etc. run on
every startup. They're idempotent/guarded, but as they accumulate, boot time grows.
Consider a lightweight migration-version table so one-time backfills run once.

---

## C. Correctness / logic / cleanup

### C1 (P2) — Legacy "pack-size = separate product" flow coexists with F2 variants
`add_product_sheet_new/addproductscreen.dart` keeps the old grocery multi-product
workaround alongside the real F2 variant grid. Intentional, but document/limit it so
new verticals don't accidentally use the legacy path.

### C2 (P2) — Auto-trial on every added store
`add_store_for_user` grants the new store the owner's active plan. Right for rollout,
but revisit when billing lands (per-store paid plans vs an owner-level plan covering N
stores) so trials don't multiply.

### C3 (P1) — No tests for this session's new surface
Add unit/route tests for: `my-stores`/`add`/`switch` + membership guard;
`get_categories(vertical)` + `catalog_search` vertical filter; `gst_summary`; the three
new KPI calculators; POS deep-link application in `create_order`.

### C4 (P3) — `print`/`DEBUG` noise
`whatsapp.templates` prints `DEBUG: Loading whatsapp.templates v3…` on import. Move to
`logger.debug`.

---

## Recommended order (quick wins first)
1. **A1 + B1** — shared FE source providers + a store-scoped `/kirana/stores`: removes most duplicate calls and the all-stores ML loop. Biggest, most visible win.
2. **A3** — `activeStoreIdProvider`; simplifies A2 and the switch cascade.
3. **C3** — tests for the new endpoints (lock in the multi-store/catalog work).
4. **B2** — consolidate router auth deps.
5. **B4 / B5 / B3** — indexes, membership checks, request-scoped repo as the app scales.

None of these are blocking; the app is functional and tests are green. They're
efficiency + maintainability. I can take them in the order above on your go.
