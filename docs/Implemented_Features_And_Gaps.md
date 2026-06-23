# Kirana AI — What We Built, How It Works, and Where the Gaps Are

A working session summary of the verticalisation programme: the four foundations
(**F1–F4**) and the nine net-new modules (**M1–M9**). For each item: *what it is*,
*how it works end-to-end*, and *what's still missing*.

- **Branch:** `feat/verticals-f2-f3-f4`
- **Status snapshot:** backend boots cleanly at **298 routes**; `flutter analyze` clean.
- **Companion docs:** `Foundations_And_Modules.md` (terse reference), `F1_Vertical_Config_Changes.md`, `F4_KPI_Packs.md`, `Vertical_Roadmap_Status.md`, `Gap_Fill_Playbook.md`.

## The shape of every change (so the rest reads fast)

The whole programme follows one repeatable pattern, on purpose:

- **Backend schema** lives in `kirana/repositories/base.py::_ensure_schema` — idempotent,
  runs on every boot, NULL-guarded `ALTER`/`ON CONFLICT DO NOTHING` so re-runs and
  existing rows are safe.
- **One repository mixin per domain** (`kirana/repositories/*.py`), all combined into
  `repositories/main.py::KiranaRepository`.
- **One router per domain** (`kirana/routers/*.py`), mounted in `routers/main.py`.
- **Frontend:** a feature folder `lib/features/<area>/` (Riverpod providers + screens),
  routed under `/profile/*`, surfaced through a **gated profile menu entry**.
- **Everything is opt-in / gated.** A plain grocery store sees none of it unless its
  vertical or an admin flag turns it on. This is why nothing here disturbs the existing
  single-store grocery experience.

The gate itself is F1: `verticalConfigOf(ref).has('flag')` / `.isOff('flag')` on the
frontend, and `get_vertical_config(store_id)` on the backend.

---

# Foundations (F1–F4)

These four absorb roughly 80% of the ~60 gaps in Guru's analysis because they're the
plumbing every vertical needs.

## F1 — Vertical Config *(committed)*

**What it is.** The master switch that makes one codebase behave like seven different
retail apps.

**How it works.**
- Two-level model: a granular `store.store_type` (14+ human picker labels like *boutique*,
  *pharmacy*, *salon*) collapses to a coarse `store.vertical_code` (7 behaviour profiles:
  **grocery, apparel, footwear, electronics, optical, services, general**).
- Seeded in `base.py::_ensure_schema` into a `vertical_config` table. Each vertical carries
  a feature set `{expiry, loose, variants, serial, warranty, appointments, vision, tax}`,
  plus `unit_set`, `ml_profile`, `tax_profile`, `copy_pack`.
- Resolution: `get_vertical_config(store_id)` in `repositories/store.py` (COALESCE →
  grocery default). Exposed at `GET /kirana/vertical-config`.
- Registration carries it through: `RegisterStoreOwnerRequest.vertical_code` →
  `register_store_owner_atomic` INSERT (null → 'grocery').
- Frontend: `lib/core/vertical/vertical_config.dart` (model + grocery fallback) and
  `vertical_config_provider.dart` (`verticalConfigProvider`, `verticalConfigOf(ref)`).
  Onboarding `business_step.dart` lists all 14 store types; `onboarding_provider`
  whitelists store types and maps store_type → vertical (default grocery).
- First consumers: add-product (`addproductscreen.dart`) gates **expiry** / **loose**
  fields and picks the right `unitSet`.

**Gaps / what's light.**
- Coverage of *reads* is still growing — F1 flags are wired into the high-traffic screens
  (add-product, POS picker, KPI visibility) but not yet every legacy surface.
- No owner-facing "switch my vertical later" flow; vertical is set at registration and
  otherwise changed by support/admin.

## F2 — Product Variants

**What it is.** Real size/colour/model/storage variants (apparel, footwear, electronics,
optical) with **per-variant stock**, instead of the grocery hack of "one product per pack size".

**How it works.**
- Schema: `product_variant` (attributes JSONB, price/mrp/cost, **stock**, is_implicit,
  is_active) + `product_attribute_def` (per-vertical axes — size/colour for apparel,
  model/storage for electronics, lens_type for optical…). `inventory.variant_id` and
  `order_item.variant_id` columns added.
- **Grocery stays simple:** every existing product gets one *implicit* variant via an
  idempotent migration; implicit variants can't be deactivated and the legacy grocery
  flow is untouched.
- Repo `variants.py` (`ensure_implicit_variant` lazily covers products created through the
  oltp path, list/create/update/get/deactivate, list_attribute_defs). Router `variants.py`:
  `GET /kirana/attribute-defs`, `GET/POST /kirana/products/{id}/variants`,
  `PATCH/DELETE /kirana/variants/{id}`.
- POS sale: real variants check + decrement `product_variant.stock` and record
  `order_item.variant_id`; grocery/implicit still uses the inventory table.
- Frontend, **producer side:** inline size×colour-style grid in add-product
  (`_buildF2VariantRow`, one product → many variants), and a full "Manage Variants" sheet
  on edit-product (gated by `has('variants')`).
- Frontend, **consumer side:** variant-aware cart (`CartItem.variantId/variantLabel`,
  lineKey `'$productId:$variantId'`); a POS variant-picker sheet appears before add-to-cart
  when a variant-vertical product has real variants (out-of-stock disabled); checkout
  payload sends `variant_id`.

**Gaps / what's light.**
- **Per-variant inventory constraint:** `inventory` is still `UNIQUE(store_id, product_id)`
  with a nullable `variant_id`. True per-variant inventory needs the constraint widened to
  `(store_id, product_id, variant_id)`. Today per-variant truth lives on
  `product_variant.stock`; the inventory table is the aggregate.
- Products created via the **oltp** module get their implicit variant lazily (on first
  variant access), not eagerly — fine, but worth knowing.

## F3 — Tax / GST

**What it is.** GST handling on a previously tax-free app, built greenfield.

**How it works.**
- GST is treated as **inclusive** in the retail price — the bill total never changes; the
  tax component is *extracted* for the invoice breakup.
- Resolution order: `product.gst_rate` → store `tax_rule` (by category / HSN / price band)
  → 0. Implemented in `repositories/tax.py::resolve_gst_rate`.
- Schema: `product.hsn_code` / `product.gst_rate`, a `tax_rule` table,
  `orders.tax_amount` / `taxable_amount`, `order_item.gst_rate` / `tax_amount`.
- Router `tax.py`: `POST /kirana/products/{id}/tax`, `GET/POST/DELETE /kirana/tax-rules`.
  `pos/crud.create_order` computes per-line inclusive GST and the order totals.
- Frontend: GST% / HSN fields in add- and edit-product (gated to non-grocery verticals);
  an "Incl. GST ₹X" line in the cart footer; receipt prints a Taxable + GST breakup.

**Gaps / what's light.**
- No GST *reporting* yet (GSTR-style summaries / export); the data is captured per order
  but there's no filing-grade report screen.
- Inclusive-only model — no separate exclusive/B2B tax-on-top invoicing path.

## F4 — Vertical KPI packs + admin visibility

**What it is.** A vertical-aware analytics layer, and — the headline ask — **admin control
over which KPIs each vertical sees, live, with no app update**.

**How it works.**
- `KPIDef.verticals: list[str]` tags each KPI (empty = all verticals). The registry grew
  from 46 untagged common KPIs to **58** (12 new vertical KPIs first registered as
  *coming-soon*).
- **Admin visibility:** `kpi_visibility_config(kpi_id, vertical_code, is_visible)` table;
  registry helpers `visible_kpis_for(vc, overrides)` + `default_visible` (live KPIs shown,
  coming-soon hidden). Endpoints: `GET/PUT /kirana/admin/kpi-visibility` and
  `GET /kirana/kpis/visible` (a store's effective set).
- **Admin panel:** `admin-panel/src/pages/KpiVisibility.jsx` — a KPI × vertical toggle grid.
- **App:** `visibleKpisProvider` (GET `/kpis/visible`); the KPI subscription screen now
  shows only the vertical's admin-visible KPIs (was the full registry).
- **Live calculators** (`kpis/calculators/vertical.py`): sell-through, size-curve, markdown,
  GMROI — all data-backed by F2 variant sales + F3 cost.
- Three more sub-parts: **ML profiles** (`ml_profile_for` → per-vertical dead-stock window:
  grocery 21 / apparel 60 / electronics 45 / services 30 days); **vertical-aware AI intake**
  (`ai/routes.py` appends size/colour or model/storage hints to voice/handwrite); and
  **Vision gating** (grocery on, others off; dashboard drops the Vision tab when off).

**Gaps / what's light.**
- Several vertical KPIs stayed coming-soon until their module shipped (most now live — see
  the KPI table below). The genuinely still-pending three need *more than a module*:
  - **outfit / bundle uptake** — needs a recommender.
  - **accessory attach-rate** — needs a category ↔ accessory map.
  - **prescription-renewal** — needs structured Rx renewal dates (M8 added free-text
    prescription, not structured dates).

---

# Net-new modules (M1–M9)

Each is a real subsystem, not a config flag. All built end-to-end (backend + FE) and
committed on `feat/verticals-f2-f3-f4`. Listed in build order.

## M1 — Loyalty & Offers *(🔴 Critical)*

**What it is.** Points, tiers, coupons, and occasion (birthday/anniversary) offers. Opt-in
per store (`loyalty_config.is_active`, default off).

**How it works.**
- Schema: `customer` + birthday/anniversary; `loyalty_config` (points_per_100,
  redeem_paise_per_point, silver/gold thresholds); `loyalty_transaction` (±points,
  kind earn|redeem|bonus|adjust — **balance = SUM**); `coupon` (+ `coupon_redemption`).
- Repo `loyalty.py`: get/upsert config, points balance, tier_for, earn_points (no-op if
  inactive), redeem_points (balance-checked), validate/redeem coupon, offers_due
  (birthday/anniversary within N days).
- **Earn loop:** `pos/crud.create_order` awards points after commit (best-effort) when a
  customer is attached and loyalty is active.
- **Redeem loop:** POS checkout (`order_dialog.dart`) has a coupon field + Apply and a
  points-redeem checkbox; `_effectiveTotal = subtotal − couponDiscount − redeemValue`
  drives the grand total and the udhaar split.
- FE: loyalty settings screen, coupon manager, a customer loyalty card (points/tier/redeem
  value), and birthday/anniversary capture in the customer form.

**Gaps / what's light.**
- No in-app "offers due today" surface yet (the `offers-due` endpoint exists; nothing
  consumes it).
- No admin-panel loyalty overview.

## M4 — Services & Appointments *(🔴 for salon/fitness/optical)*

**What it is.** A core workflow for verticals that previously had *none*. Gated by
`has('appointments')` (services + optical).

**How it works.**
- Schema: `service` (catalogue), `appointment` (customer, service, staff_user_id, starts_at,
  status booked|completed|cancelled|no_show, order_id), `membership` (prepaid sessions).
- Repo `services.py`: service CRUD; appointment create (defaults duration+price from the
  service) + status update; `appointment_utilisation` and `service_revenue` (both KPIs);
  membership create + `use_membership_session` (auto-deactivates when exhausted).
- Router `services.py`: services, `/appointments` (by day or range), status PATCH,
  utilisation, memberships + use.
- **KPIs live:** service-revenue + appointment-utilisation.
- FE: tabbed screen — Appointments (day bar, cards with complete/cancel/no-show, Book FAB)
  and Services (catalogue + toggle + editor).

**Gaps / what's light.**
- **Membership has no UI** yet (provider + backend exist; no screen).
- Staff assignment to appointments is a column (`staff_user_id`) but not wired to a picker.
- Service-sale → POS order link is a column (`order_id`) but not yet a flow.

## M2 — Multi-store rollup *(🔴 Critical)*

**What it is.** A group layer for chains, on top of the existing one-user-one-store model,
without disturbing single-store.

**How it works.**
- Schema: `store_group` (owner_user_id) + `store.group_id` / `store.city`.
- Repo `multistore.py`: `group_store_ids` (→ just `[store_id]` if ungrouped), `store_rollup`
  → `{store_count, is_multi_store, total_revenue, by_store[], by_area[]}` aggregating orders
  across the group by store and by city/region.
- Router: `GET /kirana/stores/rollup` (caller's group) + admin
  `POST /kirana/admin/store-groups`, `/admin/stores/{id}/group`.
- **KPI live:** zone-comparison.
- FE: Store Comparison screen (summary card + per-store revenue bars + per-area tiles;
  shows "ask support to link stores" when not multi-store). Profile entry gated on
  `isMultiStore`.

**Gaps / what's light.**
- **No admin-panel UI** for creating groups / assigning stores — admin must call the API
  directly today (by design: chain setup is a back-office action).
- Onboarding doesn't capture `store.city` yet (column exists; rollup falls back to
  region/location).
- No per-store footfall / conversion (Guru 🟠, needs footfall capture).

## M5 — Staff Operations *(🟠)*

**What it is.** Team, attendance, and task checklist.

**How it works.** Tables `staff`, `staff_attendance` (one row/day), `staff_task`. Repo
`staff.py`; routes `/kirana/staff*`. **KPI staff-performance** live (computed from
`orders.user_id`). FE: Staff screen — team list + per-day attendance chips + tasks.

**Gaps / what's light.** No RBAC/roles, payroll, commission, or shift/roster yet (the
original M5 scope was broad; this is the operational core). No bulk staff admin UI.

## M6 — Orders & Fulfilment *(🟠)*

**What it is.** Proforma estimates, customer returns/exchange, and delivery fields.

**How it works.** `estimate` + `estimate_item`, `sales_return` (customer returns — distinct
from the pre-existing return-to-vendor), `orders.delivery_status/address/fee`. (Purchase
orders already existed.) Repo `fulfilment.py`; routes `/kirana/estimates`,
`/kirana/sales-returns`, `/kirana/orders/{id}/delivery`. FE: tabbed Estimates + Returns.

**Gaps / what's light.** No online catalogue / WhatsApp ordering, no split billing, and the
home-delivery side is fields-only (no driver/dispatch flow).

## M3 — Multi-location / Multi-rack stock *(🔴)*

**What it is.** Knowing *which rack/bin* a SKU sits in.

**How it works.** `inventory_location` (qty per product/variant/rack). Repo
`stocklocations.py`; routes `/kirana/products/{id}/locations`, `/kirana/racks?q=`. FE: Stock
Racks screen — rack finder + place stock by product.

**Gaps / what's light.** Rack stock is a parallel ledger to the main inventory count — no
reconciliation/transfer-between-racks flow yet.

## M7 — Warranty & Serial *(🟠 electronics)*

**What it is.** IMEI/serial register + warranty-claim tracking. Gated by `has('warranty')`.

**How it works.** `product_serial` (serial register + status) + `warranty_claim`. Repo
`warranty.py`. **KPI warranty-claim-rate** live. FE: tabbed Warranty (claims with status +
serials).

**Gaps / what's light.** No auto-register of a serial at point of sale (it's manual entry);
that's part of the "POS deep links" lean spot below.

## M8 — Customer 360+ *(🟠)*

**What it is.** Wishlist + richer customer profiles.

**How it works.** `wishlist` table + customer `prescription` / `style_profile` /
`size_profile` columns. (Referral already existed.) Repo `customer360.py`; routes
`/kirana/customers/{id}/profile`, `/wishlist`. FE: a "Profile & Wishlist" card *inside*
customer detail (not a standalone route).

**Gaps / what's light.** `prescription` is free-text — no structured renewal dates, which is
exactly why the **prescription-renewal KPI is still coming-soon**.

## M9 — Job Cards / Repair *(🟠)*

**What it is.** Alteration (apparel), repair (mobile/optical), pre-order (bakery) tickets.

**How it works.** `job_card` (type + status workflow). Repo `jobcards.py`; routes
`/kirana/job-cards`. FE: Job Cards screen — type chips, create, status.

**Gaps / what's light.** No job → POS order/billing link; no customer notification on status
change.

---

# KPI status after all modules

**Live now** (each admin-toggleable per vertical): all 46 common KPIs **plus** sell-through,
size-curve, markdown, GMROI, service-revenue, appointment-utilisation, zone-comparison,
staff-performance, warranty-claim-rate, **outfit/bundle uptake, accessory attach-rate,
prescription-renewal-due** (the last three flipped live in the follow-up pass below).

**Coming-soon:** none of the vertical KPIs remain blocked — all are now computable.

---

# Follow-up pass — cross-cutting items 1–6 (DONE)

The six cross-cutting gaps below were all built in a dedicated pass. Backend boots at
**308 routes**; `flutter analyze` clean; admin-panel `vite build` clean.

1. **Admin-panel UIs** *(done)* — three new React pages + sidebar/routes/api.js:
   `StoreGroups.jsx` (create chain groups + assign stores, M2), `LoyaltyOverview.jsx`
   (adoption + points liability per store, M1), `StoreOps.jsx` (per-store staff & serial
   view + bulk add, M5/M7). New admin endpoints: `GET /admin/store-groups`,
   `GET /admin/loyalty/overview`, `GET/POST /admin/stores/{id}/staff[/bulk]`,
   `GET/POST /admin/stores/{id}/serials[/bulk]`.
2. **POS deep links** *(done)* — `OrderCreate` gained `serials`, `membership_id`,
   `appointment_id`, `job_card_id`; `pos/crud.create_order` applies them best-effort
   (mark serials sold, consume a membership session, complete + bill an appointment, bill
   a job card via new `job_card.order_id` + `link_job_to_order`). FE: a gated
   `PosDeepLinkSection` in the checkout sheet (serials field, appointment/membership/job
   pickers) threaded through `placeOrder`.
3. **Per-variant inventory** *(done)* — replaced the `inventory (store_id, product_id)`
   unique with a version-agnostic functional unique index
   `(store_id, product_id, COALESCE(variant_id, 0))` (grocery's NULL/implicit row still
   dedupes; each real variant gets its own row). Updated the OLTP upsert
   (`oltp/repository.py`) to target it; boot migration seeds variant rows from
   `product_variant.stock`; POS sale + variant create/edit write through to the inventory
   row. ⚠️ Run the migration on **staging first** (it drops/replaces a unique constraint).
4. **The 3 coming-soon KPIs** *(done)* — `calc_outfit_uptake` (multi-item attach % + top
   co-purchased pairs), `calc_attach_rate` (device↔accessory via category-name keyword
   map), `calc_rx_renewal` (new structured `customer.prescription_date` +
   `prescription_valid_months`). Registry V_AP_5 / V_EL_1 / V_OP_1 flipped `_ok`.
5. **GST reporting** *(done)* — `gst_summary` repo method +
   `GET /kirana/tax/gst-summary?date_from&date_to` (GSTR-style per-rate slab breakup with
   CGST/SGST split + totals). FE: `lib/features/tax/` GST Report screen (month selector),
   profile entry gated to non-grocery verticals.
6. **Onboarding city + vertical switch** *(done)* — registration now persists `store.city`
   (seeded from the reverse-geocoded city); store-settings screen gained a **vertical
   switcher** (7 verticals) + a **city** field; `update_store` accepts `city`/`vertical_code`
   and the FE invalidates `verticalConfigProvider` so gated features update immediately.

**Residuals from this pass (small):**
- The Rx-renewal KPI is live, but an **owner-facing date picker** for `prescription_date`
  in the M8 customer profile card is not yet wired (the backend endpoint accepts it).
- Per-variant inventory keeps `product_variant.stock` as the operational truth with
  write-through to the inventory row; a future cleanup could make the inventory row the
  single source.
- Membership/job-card pickers in checkout only appear when such records exist; there's no
  "create one inline" path (by design — they're created in their own screens).

---

# Original cross-cutting list (now closed) & branch status

Items 1–6 above correspond to the original "recommended next steps." **Branch / merge:**
F1–F4 + M1–M9 were committed on `feat/verticals-f2-f3-f4`; this follow-up pass is in the
working tree (not yet committed). Next decision is review + commit, then merge to `master`.

---

*Generated as a session summary. The terse engineering reference is
`Foundations_And_Modules.md`; deep dives live in `F1_Vertical_Config_Changes.md` and
`F4_KPI_Packs.md`.*
