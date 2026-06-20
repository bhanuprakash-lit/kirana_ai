# Kirana AI — Verticalisation: Foundations (F1–F4) & Modules (M1–M9)

Single reference for everything built to take the grocery app multi-vertical and
fill Guru's feature-gap analysis. Branch: **`feat/verticals-f2-f3-f4`**.

**Conventions used throughout**
- Backend: schema lives in `kirana/repositories/base.py::_ensure_schema` (idempotent, runs on boot); one repository *mixin* per domain (`kirana/repositories/*.py`) combined in `repositories/main.py::KiranaRepository`; one router per domain (`kirana/routers/*.py`) mounted in `routers/main.py`.
- Frontend: a feature folder per area (`lib/features/<area>/`) with Riverpod providers + screens, routed under `/profile/*`, with **gated profile entries**.
- KPIs from F4 flip from *coming-soon* to *live* as the module that supplies their data lands.
- Everything is **opt-in / gated** so existing grocery stores are never affected.

---

## Foundations

### F1 — Vertical Config  *(committed)*
The master switch. `vertical_config` table (7 verticals: grocery, apparel, footwear, electronics, optical, services, general) + `store.vertical_code`. Onboarding picker (14 store types → vertical). `GET /kirana/vertical-config`; FE `verticalConfigProvider` + `verticalConfigOf(ref)` with `.has(flag)` / `.isOff(flag)`. Wired reads: add-product gates expiry/loose + units.
**Feature flags:** expiry, loose, variants, serial, warranty, appointments, vision, tax.

### F2 — Product Variants
`product_variant` (attributes JSONB, price/mrp/cost, **stock**, is_implicit) + `product_attribute_def` (per-vertical axes); `inventory.variant_id` + `order_item.variant_id`. Grocery = one implicit variant (migration backfills). Repo `variants.py`; routes `/kirana/products/{id}/variants`, `/kirana/attribute-defs`. FE: inline variant grid in add-product, variant manager (edit-product), **POS variant picker** + per-variant stock decrement at sale.

### F3 — Tax / GST
`tax_rule` + `product.hsn_code/gst_rate`; `orders`/`order_item` tax columns. GST treated **inclusive**; extracted at checkout for the bill breakup. Repo `tax.py` (resolve_gst_rate → product → store rule → 0); routes `/kirana/products/{id}/tax`, `/kirana/tax-rules`. FE: GST/HSN fields in add/edit product (non-grocery), "Incl. GST" cart line, receipt breakup.

### F4 — Vertical KPI packs + admin visibility
`KPIDef.verticals` tags; `kpi_visibility_config(kpi_id, vertical_code, is_visible)` — **admin shows/hides KPIs per vertical, live, no app update** (admin-panel *KPI Visibility* grid; `GET/PUT /kirana/admin/kpi-visibility`; app `GET /kirana/kpis/visible`). New calculators (`kpis/calculators/vertical.py`): sell-through, size-curve, markdown, GMROI (data-backed); plus ML profiles (`ml_profile_for` → per-vertical dead-stock window), vertical-aware AI intake (`ai/routes.py` hints), and Vision gating. Doc: `F4_KPI_Packs.md`.

---

## Net-new modules (Guru gap analysis)

> Each = schema + repo mixin + router + FE screen (routed `/profile/*`, gated). Opt-in.

### M1 — Loyalty & Offers  *(🔴, committed)*
Points ledger (`loyalty_transaction`, balance = SUM), tiers, per-store `loyalty_config`, `coupon` + redemption, customer `birthday`/`anniversary`. Earn on sale (create_order hook), redeem points + apply coupon at POS checkout. FE: loyalty settings, coupon manager, customer loyalty card, birthday capture. `repositories/loyalty.py`, `routers/loyalty.py`, `lib/features/loyalty/`.

### M4 — Services & Appointments  *(🔴 salon/fitness/optical, committed)*
`service` catalogue, `appointment` (calendar + status), `membership` (prepaid sessions). KPIs **service-revenue** + **appointment-utilisation** live. FE: tabbed Appointments (day nav, book, complete/cancel/no-show) + Services catalogue. Gated by `has('appointments')`. `repositories/services.py`, `routers/services.py`, `lib/features/services/`.

### M2 — Multi-store rollup  *(🔴, committed)*
`store_group` + `store.group_id`/`city`. `store_rollup` aggregates per-store + per-city/area sales across the owner's chain. KPI **zone-comparison** live. FE: Store Comparison screen (revenue bars + area tiles), gated on `isMultiStore`. Grouping is admin-only. `repositories/multistore.py`, `routers/multistore.py`, `lib/features/multistore/`.

### M5 — Staff Operations  *(🟠)*
`staff`, `staff_attendance` (one/day), `staff_task` (checklist). Staff performance from `orders.user_id`. KPI **staff-performance** live. FE: Staff screen (team + per-day attendance chips + tasks). `repositories/staff.py`, `routers/staff.py` (`/kirana/staff*`), `lib/features/staff/`.

### M6 — Orders & Fulfilment  *(🟠)*
`estimate` + `estimate_item` (proforma), `sales_return` (customer returns/exchange), `orders.delivery_status/address/fee`. (Purchase orders + return-to-vendor already existed.) FE: tabbed Estimates + Returns. `repositories/fulfilment.py`, `routers/fulfilment.py` (`/kirana/estimates`, `/kirana/sales-returns`, `/kirana/orders/{id}/delivery`), `lib/features/fulfilment/`.

### M3 — Multi-location / Multi-rack stock  *(🔴)*
`inventory_location` (qty per product/variant/rack). Repo `stocklocations.py`; routes `/kirana/products/{id}/locations`, `/kirana/racks?q=`. FE: Stock Racks screen (rack finder + place stock). `lib/features/stockracks/`.

### M7 — Warranty & Serial  *(🟠 electronics)*
`product_serial` (IMEI/serial register, status) + `warranty_claim`. KPI **warranty-claim-rate** live. FE: tabbed Warranty (claims with status + serials), gated by `has('warranty')`. `repositories/warranty.py`, `routers/warranty.py`, `lib/features/warranty/`.

### M8 — Customer 360+  *(🟠)*
`wishlist` + customer `prescription`/`style_profile`/`size_profile`. (Referral already existed.) FE: Profile & Wishlist card inside customer detail (edit profile, add/remove wishlist). `repositories/customer360.py`, `routers/customer360.py` (`/kirana/customers/{id}/profile`, `/kirana/customers/{id}/wishlist`), `lib/features/customer360/`.

### M9 — Job Cards / Repair  *(🟠)*
`job_card` (alteration / repair / pre-order) with status workflow. FE: Job Cards screen (type chips, create, status). `repositories/jobcards.py`, `routers/jobcards.py` (`/kirana/job-cards`), `lib/features/jobcards/`.

---

## KPI status after all modules
**Live now** (admin-toggleable per vertical): all 46 common KPIs + sell-through, size-curve, markdown, GMROI, service-revenue, appointment-utilisation, zone-comparison, staff-performance, warranty-claim-rate.
**Still coming-soon** (need more than a module): outfit/bundle uptake (recommender), accessory attach-rate (category↔accessory map), prescription-renewal (structured Rx dates).

## What's intentionally light (good next steps)
- Admin-panel UIs for store-group setup (M2) and staff/serial bulk ops.
- POS deep links: sell a service/job into an order; auto-register serial at sale; per-variant stock unique-constraint for true per-variant inventory.
- The 3 coming-soon KPIs above.

## Backend size check
App boots cleanly — **298 routes**. `flutter analyze` — no issues.
