# Vertical-wise Feature Matrix — what each store type gets, and how ready it is

**Date:** 2026-07-22 · **Scope:** app (`kirana_ai`) + backend (`kirana-master-backend`) + admin panel
**Sources:** `Foundations_And_Modules.md`, `Vertical_UX_Audit.md`, `Incomplete_Features_Audit.md`, `Vertical_Fix_Plan.md`, `F1_Vertical_Config_Changes.md`, `F4_KPI_Packs.md`, `FEATURES.md`, plus the live code (`vertical_config` seed in `kirana/repositories/base.py`, `lib/core/vertical/*`, all `has('…')` gating call sites).

This doc answers: **how many kinds of store exist, what each one actually gets, why that feature exists, and how finished it is** — without needing to visit an outlet.

---

## 0. Readiness legend

| Mark | Means |
|---|---|
| ✅ **Done** | Built end-to-end (schema → API → screen), reachable in the UI, works on real data |
| 🟨 **Partial** | Core path works but a named piece is missing (l10n, a loop not closed, a deploy pending, one direction of the flow) |
| 🟥 **Not built** | Registered as an intent (KPI stub, config flag, plan item) but no working implementation |
| ⬜ **N/A** | Deliberately off for this vertical |

---

## 1. How the vertical system works (read this first)

Three layers, and people confuse them constantly:

1. **Store type** — 18 choices the owner picks at onboarding / add-store (`lib/features/stores/store_types.dart`, mirrored by onboarding `_mapVertical`). This is the *label* of the trade.
2. **Vertical code** — **7 behaviour profiles** the 18 types collapse into. This is what the app actually branches on.
3. **`vertical_config` row** — per vertical: **7 feature flags** + a **unit set** + `ml_profile` + `tax_profile` + a `copy_pack`. Seeded in `kirana/repositories/base.py` (~line 556), served by `GET /kirana/vertical-config`, read in the app via `verticalConfigOf(ref).has('flag')`.

### 1.1 Store type → vertical

| Store type (picker label) | Vertical |
|---|---|
| Kirana / General Stores, Provision Store, Fruits & Vegetables, Supermarket, Mini Supermarket, Bakery & Sweet Shop | **grocery** |
| Apparel & Clothing, Boutique, Mono Brand Store, Sports & Fitness | **apparel** |
| Footwear Shop | **footwear** |
| Mobile & Electronics | **electronics** |
| Optical Store | **optical** |
| Salon & Parlour | **services** |
| General Store, Stationery & Books, Fancy & Gift Store, Others | **general** |

> Pharmacy is **permanently out of scope** (own dedicated app) — it is not in the picker.

### 1.2 The 7 configs, verbatim from the seed

| Vertical | expiry | loose | variants | serial | warranty | appointments | vision | Units | ML profile |
|---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|---|---|
| **grocery** | ✅ | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ✅ | pcs, kg, g, L, ml, dozen, pack, box, bundle | grocery (21-day dead stock) |
| **apparel** | ⬜ | ⬜ | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | pcs, pair, set | apparel (60-day) |
| **footwear** | ⬜ | ⬜ | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | pair, pcs, set | apparel |
| **electronics** | ⬜ | ⬜ | ✅ | ✅ | ✅ | ⬜ | ⬜ | pcs, set | electronics (45-day) |
| **optical** | ⬜ | ⬜ | ✅ | ⬜ | ✅ | ✅ | ⬜ | pcs, pair | apparel |
| **services** | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ✅ | ⬜ | pcs, session, hour | services (30-day) |
| **general** | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | pcs, pack, box, set | grocery |

**Vision nuance:** the `vision` flag is `true` only for grocery, but since V0.3 **every vertical shows the Vision tab** — non-grocery gets a "coming soon" screen inside it, because the detector only recognises kirana items today. Flip the flag server-side and the real screen appears with no app update.

### 1.3 Bottom navigation per vertical (`lib/core/vertical/nav_preset.dart`) — ✅ Done

| Vertical | Nav tabs |
|---|---|
| grocery | Home · Khata · Billing · Vision |
| services, optical | Home · **Bookings** · Billing · Khata · Vision |
| electronics | Home · Billing · **Repairs** · Khata · Vision |
| apparel, footwear | Home · Billing · **Orders** (estimates/returns) · Khata · Vision |
| general | Home · Billing · Khata · Vision |

Tabs are addressed by semantic id (`NavTabId`), never by index — FCM deep links and home-widget links resolve through the preset.

---

## 2. The universal core — every vertical gets these

These aren't gated at all; they're the product. Purpose + readiness:

| Feature | Purpose | Readiness |
|---|---|---|
| **Onboarding + phone-OTP auth** | Create store, pick store type (sets vertical), location, trial plan | ✅ |
| **Multi-store per owner** | One login → store picker → switch store; POS token re-minted on switch | ✅ (catalog/categories still global) |
| **POS billing** | The till: search, cart, discounts, payment modes, checkout | ✅ |
| **Inventory** | Stock list, add/edit product, low-stock, search, barcode | ✅ |
| **Procurement / suppliers** | Purchase orders, receive stock → inventory, supplier dashboard | ✅ |
| **Khata — customer udhaar** | Credit ledger with due dates, settlement, recovery, voice consent (Pro) | ✅ (voice-consent path built; needs blob env on deploy) |
| **Khata — distributor credit** | What the store owes suppliers | ✅ |
| **Cashflow / expenses** | Money in/out beyond sales | ✅ |
| **Customers / CRM** | Unified customer sheet, areas, history, per-customer pricing | ✅ (pinned/last-paid pricing built; inferred-discount phase not started) |
| **KPI engine — 46 common KPIs** | The analytics spine; each KPI subscribable | ✅ |
| **Admin per-vertical KPI visibility** | Ops can show/hide any KPI for any vertical, live, no app update | ✅ |
| **AI intelligence strip** | Fast-moving, stockout risk, reorder, dead stock — ML-profile tuned per vertical | ✅ (thresholds tuned; surfaces still grocery-flavoured for others) |
| **Forecast strip / demand forecast** | Next-period demand | ✅ |
| **Loyalty & offers (M1)** | Points, tiers, coupons, birthdays — repeat-visit lever | ✅ |
| **Referral** | Customer-gets-customer | ✅ |
| **Campaigns** | Push/marketing pushes to customer segments | ✅ |
| **Staff ops (M5)** | Roster, attendance, tasks, "Billed by" at checkout → per-staff sales + commission | ✅ |
| **Stock racks (M3)** | Where physically is SKU X — browse racks, place/move stock, rack badge in inventory | ✅ |
| **Estimates & returns (M6)** | Quotation → convert to sale; unified return history that actually restocks | ✅ |
| **Customer 360 (M8)** | Wishlist, prescription/style/size profile on the customer record | ✅ |
| **Multi-store rollup (M2)** | Chain owner compares stores/zones/cities | ✅ (grouping is admin-only) |
| **GST report** | Filing summary; **store-level toggle** (a registered kirana files GST too) | ✅ |
| **Thermal printer** | Bluetooth receipt printing | ✅ |
| **7-language localisation** | Whole app in 7 Indian languages | 🟨 core done; newest module screens partly English (see §10) |
| **Push notifications + home widget** | Re-engagement + at-a-glance stats | ✅ |
| **Guided tutorials** | Getting-started checklist, add-product, first-sale tours | 🟨 khata/module tours pending |
| **Subscription (Basic/Pro)** | Plan gating (Vision, voice consent are Pro) | ✅ |

---

## 3. Grocery — kirana, supermarket, mini-super, provision, fruits & veg, bakery

**Who:** the original product. Highest-fidelity vertical by a distance.

| Feature | Purpose | Readiness |
|---|---|---|
| **Expiry dates on products** | Prevent write-off on perishables; drives the expiry alert strip | ✅ |
| **Loose / by-weight selling** | Sell 250 g dal — kg/g/L/ml unit set, decimal quantities | ✅ |
| **Vision AI — shelf scan** | Photograph shelves → auto stock count (Pro) | ✅ live |
| **Vision AI — counter scan** | Point at the counter → sticky item tracking + live ₹ prices | ✅ live |
| **Vision AI — stock-in scan** | Photograph an incoming carton → stock entry | ✅ live |
| **Vision scan history** | Past scans with photos, non-blocking uploads | ✅ |
| **Baskets / combo tiers** | Bronze→Platinum auto-discount bundles; freeze-at-creation + retier prompt | ✅ (grocery + general only) |
| **Area associations** | Apartment/hostel/colony catchment heatmap for local marketing | ✅ (grocery + general only) |
| **Reorder / dead-stock ML @ 21-day window** | Fast-turn grocery velocity | ✅ |
| Job cards | ⬜ hidden (meaningless for kirana) | ⬜ |
| Variants / serial / warranty / appointments | ⬜ off | ⬜ |
| GST report | Off by default, **opt-in** in Store Settings | ✅ |

**Known misfits (not defects, but unbuilt fit):**
- **Bakery → grocery** 🟥 — own-make/production items don't fit "procure & restock"; no recipe/production or pre-order-cake concept beyond the generic job card (which is hidden for grocery).
- **Fruits & vegetables → grocery** 🟨 — loose + expiry fit well, but shelf-Vision and MRP-centric flows assume packaged goods.

---

## 4. Apparel — clothing, boutique, mono-brand, sports & fitness

**Who:** size/colour retail. The best-served non-grocery vertical.

| Feature | Purpose | Readiness |
|---|---|---|
| **Product variants (size × colour)** | One product, many sellable SKUs; per-variant price/stock | ✅ |
| **Attribute axes per vertical** | Size/colour axes come from `/kirana/attribute-defs` | ✅ |
| **Inline variant grid at add-product** | Create a product + all its variants in one save | ✅ |
| **Variant manager (edit product)** | Add/edit/deactivate variants later | ✅ |
| **POS variant picker** | Pick size/colour before add-to-cart; out-of-stock disabled | ✅ |
| **Per-variant stock decrement at sale** | Real per-SKU inventory truth | ✅ |
| **GST / HSN on products** | GST-inclusive extraction at checkout, cart line + receipt breakup | ✅ |
| **Orders nav tab** | Estimates + returns promoted to the bottom bar | ✅ |
| **Estimates → convert to sale** | The boutique's quotation habit, closed loop + WhatsApp share | ✅ |
| **Job cards — alteration** | Alteration job with status workflow + promised date | ✅ |
| **Sell-through KPI** | % of received stock sold — the apparel buying metric | ✅ live |
| **Size-curve KPI** | Which sizes actually sell | ✅ live |
| **Markdown KPI** | Discount depth impact | ✅ live |
| **GMROI KPI** | Return on inventory investment | ✅ live |
| **Outfit / bundle uptake KPI** | Needs a recommender | 🟥 coming-soon stub |
| **Accessory attach-rate KPI** | Needs a category↔accessory map | 🟥 coming-soon stub |
| **Size × colour matrix quick-add** | Bulk-create a full grid in one gesture | 🟥 planned, not started |
| **Outfit recommender (M10)** | Style suggestion engine | 🟥 not started |
| Baskets, associations, Vision | ⬜ hidden / coming-soon screen | ⬜ |

**Misfit:** **Mono Brand → apparel** 🟨 — a mono-brand *mobile/appliance* store gets size/colour variants but **not** serial + warranty, which is what it actually needs. Sports & Fitness was deliberately re-pointed here (V0.6) to get variants instead of appointments.

---

## 5. Footwear

Behaviourally **identical to apparel** — same flags, same ML profile, same KPIs, same Orders nav tab. The only differences are the **unit set** (`pair, pcs, set`) and that copy falls back to apparel wording (`vertical_copy.dart` maps `footwear → apparel`).

Readiness: same as §4. No footwear-exclusive feature exists (no width/last sizing model) — 🟥 by design, not currently planned.

---

## 6. Electronics — mobile & electronics

| Feature | Purpose | Readiness |
|---|---|---|
| **Variants (model / storage)** | 128 GB vs 256 GB as separate sellable SKUs | ✅ |
| **Serial / IMEI register** | Track individual units — the legal + service backbone | ✅ list, search, status filter, add-serial sheet with product picker |
| **Auto-register serial at sale** | Capture IMEI at checkout without a separate step | 🟨 deep-link section exists at POS; auto-registration listed as an intentional gap |
| **Warranty tracking** | `warranty_until` per serial, urgency badge (active/expiring/expired) | ✅ |
| **Warranty claims** | Claim register with status workflow, customer + days-open | ✅ |
| **Warranty-claim-rate KPI** | Quality/supplier signal | ✅ live |
| **Job cards — repair** | "Customer walks in with a dead phone" — repair job with status | ✅ |
| **Repairs nav tab** | Job cards promoted to the bottom bar | ✅ |
| **GST / HSN** | High-ticket GST invoicing | ✅ |
| **Dead-stock ML @ 45-day window** | Slower electronics turn | ✅ |
| **Warranty-expiry notification** | "These sold units go out of warranty this month" | 🟥 planned (audit phase 2), not built |
| **Serial-first POS search** | Type an IMEI at the till and find the unit | 🟥 planned, not started |
| **Exchange / EMI campaigns** | Vertical-specific marketing surface | 🟥 named in V3, not built |
| Baskets, associations, Vision, appointments | ⬜ hidden / coming-soon | ⬜ |

---

## 7. Optical

The **hybrid** vertical — retail + appointments + clinical record.

| Feature | Purpose | Readiness |
|---|---|---|
| **Appointments / bookings** | Eye-test calendar; Bookings is nav slot 2 | ✅ |
| **Service catalogue** | Eye test, fitting — priced services | ✅ |
| **Memberships / prepaid sessions** | Package billing | ✅ (l10n gap, §10) |
| **Prescription capture** | Rx on the customer record (M8 `prescription` field) + POS Prescription button | 🟨 stored + reachable; **free-form, not structured** |
| **Prescription-renewal KPI / reminder** | "Rx due for renewal" nudge | 🟥 blocked on structured Rx dates |
| **Variants (lens type etc.)** | Lens/frame axes seeded in attribute defs | ✅ |
| **Warranty** | Frame/lens warranty + claims | ✅ |
| **Service-revenue KPI** | Revenue split service vs product | ✅ live |
| **Appointment-utilisation KPI** | Chair/slot utilisation | ✅ live |
| **Services sellable at POS** | Bill an eye test without creating an appointment first | ✅ (V2 — needs backend ≥ `82bfc6d` deployed) |
| **Job cards** | Lens fitting jobs | ✅ (generic job card) |
| **GST / HSN** | ✅ |
| Baskets, associations, Vision, serial, expiry, loose | ⬜ |

---

## 8. Services — salon & parlour

**Who:** the vertical with the largest gap between "what they need" and "what the grocery app showed" before V0–V3. Now the closest thing to a purpose-built app.

| Feature | Purpose | Readiness |
|---|---|---|
| **Appointments tab in nav** | Their day starts at the booking calendar, not the till | ✅ |
| **Appointment book** | Day navigation, book, complete / cancel / no-show | ✅ |
| **Service catalogue** | Priced services with duration | ✅ |
| **Memberships / prepaid packages** | Sell 10 sessions, consume per visit | ✅ (V3 — `_MembershipCard`/editor, store-wide provider) |
| **Sell a service at POS** | Bill a haircut directly from search (purple Service chip) — no appointment needed | ✅ (V2; requires deployed backend with `product.is_service`) |
| **Service ↔ product link** | Services are backed by a hidden product row so one bill can mix service + goods, with the stock trigger skipping services | ✅ |
| **Service-revenue KPI** | ✅ live |
| **Appointment-utilisation KPI** | ✅ live |
| **Home quick actions** | Book appointment / memberships / customers on the home screen | ✅ |
| **Staff commission on services** | Stylist-wise earnings — "Billed by" at checkout → sales × commission % | ✅ (generic staff module; no service-specific split) |
| **Services screen localisation** | 7 languages like the rest of the app | 🟨 chrome + membership strings still hardcoded English |
| **Membership expiry / renewal reminders** | Not built | 🟥 |
| **Services-flavoured marketing** | V3 named "memberships & offers" as the services marketing surface; loyalty is generic | 🟨 |
| Variants, serial, warranty, expiry, loose, baskets, associations, Vision | ⬜ |

---

## 9. General — general store, stationery & books, fancy & gift, others

**Who:** the catch-all. **Every flag is off** — it is the deliberately neutral profile (`others` was re-pointed here from grocery in V0.6 so unknown trades no longer get the most grocery-specific app).

| Feature | Purpose | Readiness |
|---|---|---|
| Universal core (§2) | Billing, inventory, khata, customers, KPIs, loyalty, staff, racks, estimates | ✅ |
| **Baskets + associations** | Kept on here (V3 gated to `{grocery, general}`) | ✅ |
| Simple piece-based selling | pcs/pack/box/set units | ✅ |
| **Gift-wrap / occasion features** | Named in the UX audit as the fancy-gift need | 🟥 not built |
| **School-season / stationery seasonality** | Named in the audit | 🟥 not built |
| Variants, expiry, serial, warranty, appointments, Vision | ⬜ off by design |

**Honest summary:** general = "core app, nothing added". It is the least *tailored* vertical, and that is a known, accepted state.

---

## 10. Cross-vertical readiness gaps (apply to several verticals at once)

| # | Gap | Effect | State |
|---|---|---|---|
| G1 | **`copy_pack` is `{}` for all 7 verticals** | **Resolved — this is the intended design, not a gap.** A DB string can only ever be one language, so vertical wording lives in the ARBs via `vcopy()` (V0.2, ~25 keys, 5 slots). `copy_pack` stays as an emergency server-side override for hotfixes and should remain empty. Documented in `lib/core/vertical/vertical_copy.dart`. | ✅ closed |
| G2 | **Module-screen localisation** | Services & Appointments (26 strings) and the staff sheets (3) localised across all 7 locales. Remaining: serial-picker search/status strings. | ✅ mostly closed |
| G3 | **3 coming-soon KPIs** | outfit/bundle uptake (needs recommender), accessory attach-rate (needs category↔accessory map), prescription-renewal (needs structured Rx) | 🟥 |
| G4 | **Backend deploy lag** | Bill-breakdown persistence (`a2f1543`) and V2 service-sale support (`82bfc6d`) must be on the deployed revision or the FE degrades silently | 🟨 verify before testing |
| G5 | **Admin UIs still light** | Store-group setup (M2) and staff/serial bulk ops are admin-thin | 🟨 |
| G6 | **Per-vertical ML surfaces** | Thresholds are per-vertical, but the *cards* (fast-moving/reorder/dead-stock) are grocery-worded everywhere | 🟨 |
| G7 | **Catalog / categories are global** | Not scoped per store in a multi-store setup | 🟨 |
| G8 | **WhatsApp AI chatbot, price optimisation, personalised suggestion (M10)** | Broad AI upgrades from the gap analysis | 🟥 not started |

---

## 11. One-page answer

**7 verticals** (from 18 store types): grocery, apparel, footwear, electronics, optical, services, general.

- **Fully realised:** grocery (Vision + expiry + loose + baskets), services (bookings + memberships + POS-sellable services), electronics (serial + warranty + repairs), apparel/footwear (variants + estimates + 4 buying KPIs), optical (bookings + warranty + variants).
- **Deliberately plain:** general.
- **The remaining work is not "verticals" any more, it's polish and depth:** module l10n, 3 recommender-class KPIs, warranty-expiry alerts, serial-first search, size-matrix quick-add, gift/stationery flavour, and getting the newest backend revision deployed.
