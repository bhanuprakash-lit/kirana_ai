# Vertical Fix Plan — verified contracts + step-by-step execution

**Date:** 2026-07-15 · **Companion:** `Vertical_UX_Audit.md` (findings F1–F8). This doc adds the **verification layer** (every action's backend payload, state management, per-vertical behavior) and turns the audit's V0–V3 into an executable plan.

---

# Part 1 — What was verified (the ground truth the plan stands on)

## 1.1 Vertical config plumbing

| Aspect | Verified behavior |
|---|---|
| Fetch | `verticalConfigProvider` (FutureProvider) → `GET /kirana/vertical-config`; backend resolves store→`vertical_code`→config row, grocery fallback, unit_set-only self-heal (`store.py get_vertical_config`) |
| FE consumes | `features` (7 flags), `unit_set`, `copy_pack`. **Ignores** `attribute_set`, `kpi_set`, `ml_profile`, `tax_profile` (all consumed server-side or unused) |
| Cache / refresh | Session-cached. Invalidated explicitly on store switch (`stores_provider._refreshStoreScope`) and on vertical change in store settings (`store_settings_provider.updateStore`). Does **NOT** watch `storeScopeProvider` (works only because switch sites invalidate by hand) |
| Failure mode | **Any error silently returns grocery** — a salon on a flaky network gets grocery UI with no signal |
| Store switch | `/kirana/stores/switch` re-mints POS JWT inline; `storeScopeProvider.bump()` + 11 explicit invalidations |

## 1.2 Tab/state contracts (must survive any nav change)

- `dashboardTabProvider`: 0=Home, 1=Khata, 2=Billing, 3=Vision (conditional, always last).
- `dashboardSubTabProvider` (Billing): 0=Sale, 1=Inventory, 2=Suppliers. `financeSubTabProvider`: 0=Cashflow, 1=Udhaar, 2=Distributor.
- **FCM / home-widget deep links resolve tab *names* ('finance','pos','vision') to fixed indices** in `dashboard_screen._handlePendingNotification` — the single place to remap when nav becomes per-vertical.
- Tutorial anchors nav via `TutorialKeys.nav*` GlobalKeys; the engine already survives missing anchors (needed when tabs differ per vertical).
- Lazy tabs: `_visitedTabs` + `IndexedStack` — unvisited tabs never fetch. Any new tab must keep this.

## 1.3 Store-scope hygiene (state management)

Providers verified to watch `storeScopeProvider` (refetch on switch): services, appointments, associations, baskets, procurement, rack placements, supplier overview. Core providers (pos/inventory/kpi/overview/finance/customer/loyalty/subscription/storeSettings) are explicitly invalidated at the switch site. **Gap:** `verticalConfigProvider` relies on the manual invalidation only.

## 1.4 Every vertical-relevant action → backend payload (verified in code)

**Onboarding** — `register`: `store_type` (16 codes from `business_step.dart`) + `vertical_code` (7, via `_mapVertical`) + city/location/region/footfall/budget. Store settings can PATCH `vertical_code` later (config re-fetched).

**Add product** (`inventory_provider._executeAddProduct`) — flag-dependent composition:
- always: `POST /oltp/product` {name, category_id, brand, unit, weight, barcode, is_perishable, is_loose, image_url} → `POST /oltp/inventory` {store_id, product_id, quantity} → `POST /oltp/pricing` {store_id, product_id, selling_price, mrp, valid_from(UTC−1m)}
- `expiry` flag: `POST /oltp/inventory_batch` {batch_no, expiry_date, quantity}
- cost: `POST /kirana/inventory/cost` {product_id, cost_price}
- non-grocery: `POST /kirana/products/{id}/tax` {gst_rate, hsn_code}
- `warranty` flag: `POST /kirana/products/{id}/warranty` {warranty_months}
- `variants` flag: base inventory opens at **0**; per spec `POST /kirana/products/{id}/variants` {attributes{axis:value}, price, mrp, cost, stock, barcode}. Variant axes come from `GET /kirana/attribute-defs?category=` (category-driven, NOT vertical_config.attribute_set — that column is vestigial).

**Edit product** — `PATCH /oltp/product` + `POST /kirana/inventory/price` {product_id, price, mrp} (windowed writer) + `PATCH /oltp/inventory` qty with `variant_id=__null__` (skipped for variant products). Readers pick open pricing window (`isNewerPricingRow`).

**POS order** (`pos_provider.placeOrder` → `POST /pos/orders`): {total_amount, payment_method, customer_id, items[{product_id, variant_id?, quantity, selling_price, unit_price}], coupon_id/coupon_discount?, redeem_points?, serial_items[{serial_no, product_id, variant_id}]?, membership_id?, appointment_id?, job_card_id?, staff_id?, udhaar_amount/cash_paid?, due_date?, basket_*?}. Backend honors caller total; udhaar auto-creates the single khata row; trigger `update_inventory_on_sale` decrements stock per order_item (**matters for V2**). Deep-link section gating: serial→`has('serial')`, appointment/membership→`has('appointments')`, section hidden unless warranty|appointments|variants.

**Modules** (all bearer-auth, store from token): services `GET/POST /kirana/services`, `PATCH /{id}`; appointments `GET ?day=`, `POST`, `PATCH /{id}` {status}; memberships `GET/POST /kirana/memberships`, `POST /{id}/use` (BE ready, FE thin); job cards `/kirana/job-cards` CRUD+status; warranty `/kirana/serials`, `/kirana/warranty-claims`; estimates `/kirana/estimates` (+PATCH status/order link); returns `/kirana/sales-returns` (read) + `/kirana/returns` (write, txn-unified); staff `/kirana/staff` CRUD + attendance + tasks + `sales?days=30`; loyalty `/kirana/loyalty/config`, coupons CRUD/validate, redeem; baskets CRUD + tier-config + retier; referral campaigns/token/scan/vouchers; customer360 profile/wishlist; multistore `/kirana/stores/rollup`; GST `/kirana/tax/gst-summary?date_from&date_to`.

**KPIs** — `GET /kirana/kpis/visible` is **already vertical-filtered server-side** (registry `applies_to(vertical_code)` + admin overrides). `ml_profile` feeds KPI calculator thresholds (`kpis/calculators/core.ml_profile_for`). The home screen just never consumes the vertical section (`_VerticalKpiSection` commented out).

**Categories/products** — `/pos/categories` filters by store vertical (`vertical_code = :vc OR NULL`); starter categories+products seeded per vertical at boot.

## 1.5 Per-store-type reality (16 types → 7 profiles)

Since types collapse into 7 configs, behavior differs only by profile: grocery (all grocery-family types + other), apparel (apparel/boutique/mono_brand), footwear, electronics, optical, services (salon/sports_fitness), general (fancy_gift/stationery). All payloads above verified identical within a profile; the *only* per-type differences today are the label shown at onboarding and starter categories.

---

# Part 2 — The plan

Ordering: **V0 (foundations) → V1 (nav presets) → V2 (services @ POS) → V3 (marketing fit)**, then per-vertical polish passes (services → electronics → apparel/footwear → optical → general).

## V0 — Foundations (1 PR each, independent)

### V0.1 Config hardening (state management)
- `vertical_config_provider.dart`: `ref.watch(storeScopeProvider)` inside the provider (rot-proof, matches the canonical pattern); persist the last-good config JSON in SharedPreferences keyed by store_id and use it (not grocery) as the fallback → no "flash of grocery" / silent downgrade on flaky network; add `ref.invalidate` retry on next app foreground if the fetch failed.
- Risk: none — same shape, better fallback. Verify: switch store between verticals, airplane-mode relaunch keeps the right gating.

### V0.2 Vertical copy — ARB-based, copy_pack demoted
**Design decision (important):** `copy_pack` values are raw single-language strings from the DB; the app ships 7 locales. Backend copy packs therefore CANNOT be the primary copy mechanism. Plan:
- Add a FE helper `vcopy(l10n, verticalCode, slot)` backed by **ARB entries per (slot × vertical)** with fallback to the generic string. Slots (~15): nav labels (khata/billing), POS sub-tab titles (Sale/Stock/Suppliers), add/edit product title, product search hint, empty-inventory title+hint, new-sale FAB, customer word, inventory word, procurement word, today-sales card title.
- `copy_pack` stays as an **emergency server override** (highest priority when non-empty) — unchanged contract, now documented; leave packs empty.
- 7 ARBs × ~15 keys × up to 6 vertical variants — generate only where wording actually differs (services/optical/electronics mostly; apparel/footwear/general partial).
- Examples: services → Billing tab "Services & Billing", inventory "Products & kits", add title "Add service item"; electronics → inventory "Stock & IMEI", khata "Credit"; optical → search hint "Search frames/lenses…".
- Files: `vertical_config.dart` (helper), all `l10n/app_*.arb`, the ~15 call sites.

### V0.3 Gate the Vision CTAs
- `inventory_tab.dart _EmptyInventory`: hide the "photograph shelves" block + `onSnapShelves` path when `verticalConfigOf(ref).isOff('vision')`; same for the vision quick-path in the add-product surroundings and the getting-started checklist item if present.
- Verify: apparel store empty inventory shows only "Add first product".

### V0.4 Vertical home: KPI section + quick actions
- Revive `_VerticalKpiSection` (overview_tab.dart 211/251): consume the existing `visibleKpisProvider` (`/kirana/kpis/visible`, already vertical-aware) — render the vertical's non-generic KPI cards (services: appointment utilisation, service revenue; electronics: warranty/serials KPIs; multistore zone comparison stays admin-gated).
- Add `_QuickActionsRow` under the greeting, driven by a FE map `verticalCode → [actions]`:
  - grocery: New sale · Scan shelves (vision) · Add udhaar
  - services: **Book appointment** (→ appointments screen) · New sale · Memberships
  - electronics: **New job card** · **Check warranty** (serial search) · New sale
  - apparel/footwear: **New estimate** · New sale · Returns
  - optical: **Book appointment** · Prescription · New sale
  - general: New sale · Add product · Customers
- All targets are existing routes/screens; no BE work.

### V0.5 GST report → store-level setting
- BE: `ALTER TABLE store ADD COLUMN IF NOT EXISTS gst_enabled BOOLEAN` (guarded, in `base.py` ensure-schema); include in `/kirana/stores` payload + PATCH whitelist.
- FE: store settings screen gains a "GST registered" switch; profile row shows GST Report when `gst_enabled == true` **OR** vertical is non-grocery (back-compat default).
- Verify: grocery store toggles GST on → report row appears; `/kirana/tax/gst-summary` unchanged.

### V0.6 Store-type → vertical mapping fixes
- FE `_mapVertical`: `sports_fitness` → **apparel** (variants needed; appointments loss acceptable — or new profile later); `other` → **general** (not grocery).
- Add `pharmacy` to `business_step.dart` list (→ grocery profile: expiry+loose already fit) + `businessTypePharmacy` in 7 ARBs.
- BE: nothing (vertical_config rows unchanged). Existing stores keep their vertical (switchable in settings) — no backfill.
- Note in release: `mono_brand` stays apparel until a real electronics-mono-brand ask exists.

### V0.7 l10n sweep of vertical-swapped controls
- `posbottombar.dart` ('Scan'/'Appointments'/'Prescription'/'Voice'/'Write'), `setcustomerpricesheet.dart` strings, deep-link section labels → ARB keys ×7.

## V1 — Per-vertical navigation presets (the big unlock)

**Design:** FE-derived presets (no BE change) — a pure function `navPresetFor(VerticalConfig)`:

| Vertical | Slot 1 | Slot 2 | Slot 3 | Slot 4 |
|---|---|---|---|---|
| grocery | Home | Khata | Billing | Vision |
| services | Home | **Appointments** | Billing | Khata |
| optical | Home | **Appointments** | Billing | Khata |
| electronics | Home | Billing | **Repairs** | Khata |
| apparel/footwear | Home | Billing | **Orders** | Khata |
| general | Home | Billing | Khata | Customers |

Steps:
1. `dashboard_screen.dart`: replace the hardcoded tabs/destinations with a preset list of `(id, icon, label, screenBuilder)`; keep `IndexedStack` + `_visitedTabs` laziness; `label` via V0.2 `vcopy`.
2. **Deep-link remap**: `_handlePendingNotification` resolves `tab` names → index via the active preset (`indexOf(id)`); names stay semantic and grow: 'appointments', 'repairs', 'orders', 'customers'. Home-widget & FCM payloads unchanged (they already send names). Fallback: unknown name → Home.
3. New composite screens (assembled from existing ones, no new BE):
   - `AppointmentsScreen`: extract the calendar+booking part of `services_screen.dart` into a top-level tab (catalogue/memberships stay as its sub-tabs).
   - `RepairsScreen` (electronics): TabBar = Job cards / Warranty claims / Serials — embeds the three existing screens.
   - `OrdersScreen` (apparel/footwear): TabBar = Estimates / Returns / Job cards (existing fulfilment + jobcards screens).
4. Khata never disappears — where demoted it keeps its Profile row + home metric card tap-through (already exists: `_MetricCard` → Finance).
5. Tutorial: nav anchor steps skip absent tabs (engine already tolerates missing anchors — verify `flowFirstSale`/checklist against a services store).
6. Profile rows stay (same screens reachable both ways) — no route changes, `app_router.dart` untouched except any new top-level composites if routed.
- Risks: tab index assumptions — audit all `switchTab(` call sites (~12, listed in overview/postab/order flows) and convert to `switchTabById()`. Sub-tab providers unchanged.
- Verify per vertical: cold start, deep-link from FCM ('pos'), home-widget New Bill, tutorial first-sale, store switch grocery↔services mid-session (preset swaps live; clamp handles index overflow).

## V2 — Services sellable at POS

**Verified constraint:** `order_item` has FK → product and the BEFORE-INSERT trigger `update_inventory_on_sale` decrements inventory + validates stock — a service line must not fight the trigger.

Plan (B-lite, service = flagged product):
1. BE migration (guarded): `ALTER TABLE product ADD COLUMN IF NOT EXISTS is_service BOOLEAN DEFAULT FALSE`; trigger fn updated to **skip inventory decrement/validation when product.is_service** (single `IF` + product lookup; regression-test normal products).
2. `create_service` (services repo) also upserts a linked product row (`is_service=true`, name/price synced on service PATCH); store `service.product_id`.
3. FE: POS search merges `servicesProvider` results (chip "Service", price = service price) → `addToCart` with the linked product; checkout flows unchanged (`items[]` carries it; revenue/KPIs see a normal order_item). Appointment deep-link remains for booked work (its `extraCharge` path untouched).
4. Backfill: one-time linked products for existing services (guarded `app_migrations` key).
- Verify: salon sells 1 haircut + 1 shampoo in one bill → order has 2 items, shampoo stock −1, no stock error, service revenue KPI moves; returns flow excludes service items (resaleable flag off by default when `is_service`).

## V3 — Marketing fit per vertical
- Profile gating: My Baskets + Area Associations → grocery-family only (`verticalCode == 'grocery' || 'general'`); Loyalty stays universal; Campaigns copy via V0.2.
- Services: surface **memberships** properly (BE endpoints exist; FE add a Memberships tab in services screen: list/create/use-history) — closes the loop with the checkout `membership_id` deep-link.
- Electronics/apparel: keep loyalty/coupons; hide basket tiers.

## Per-vertical polish passes (after V1, one at a time)
1. **services**: appointments tab default view = today; staff pairing on appointment (staff module link); membership sales.
2. **electronics**: Repairs tab; serial-first search in POS (scan IMEI → product); warranty-expiry notifications (BE has fields).
3. **apparel/footwear**: Orders tab; size/colour matrix quick-add (attribute-defs already category-driven).
4. **optical**: appointments + prescription surface polish.
5. **general**: leanest preset; confirm nothing grocery leaks.

## Sequencing & effort

| Phase | Size | Deploy needs |
|---|---|---|
| V0.1–V0.7 | ~2–3 sessions, FE-heavy; V0.5 tiny BE migration | BE deploy for V0.5 only |
| V1 | ~2 sessions FE | none |
| V2 | 1 session (BE trigger migration + FE search merge) | BE deploy + staging trigger test |
| V3 | 1 session | none |

Every BE migration goes through the guarded `app_migrations` / `ADD COLUMN IF NOT EXISTS` pattern; deploy via `deploy.ps1` with the revision-verification step (boot-crash trap documented in RUNBOOK).
