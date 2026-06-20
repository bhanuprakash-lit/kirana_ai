# Vertical Roadmap — Status & What's Remaining

Branch: **`feat/verticals-f2-f3-f4`** (off `feat/f1-vertical-config`).

## ✅ Done — Foundations F1–F4

| | Foundation | Highlights |
|---|---|---|
| **F1** | Vertical config | `vertical_config` (7 verticals) + `store.vertical_code`; onboarding picker (14 store types → vertical); add-product gates expiry/loose + units. *(committed)* |
| **F2** | Product variants | `product_variant` + attribute defs; inline add-product grid + variant manager; POS variant picker; per-variant stock + sale decrement. |
| **F3** | Tax / GST | `tax_rule` + product HSN/GST; GST-inclusive extraction at checkout; cart line + receipt breakup. |
| **F4** | KPI packs | KPIs tagged by vertical; **admin-controlled per-vertical visibility** (live); 4 new calculators (sell-through, size-curve, markdown, GMROI); ML profiles; vertical-aware AI intake; Vision gating. |

This already closes the Guru gaps that were **config/foundation**: variant mgmt 🔴, GST invoicing, expiry gating, and most Reports/Analytics (P&L, category, fast/slow, footfall, shrinkage) via the KPI packs.

## 🚧 Remaining — Net-new modules (from Guru's gap finding)

Each is a real subsystem (not a config flag). Priority = Guru's flag. "Unlocks" = which F4 coming-soon KPIs go live.

| # | Module | Guru priority | Verticals most impacted | Unlocks (F4 KPIs) |
|---|---|---|---|---|
| M1 | **Loyalty & Offers** (points, tiers, redemption; birthday/anniversary; discount & coupon rules) | 🔴 Critical | supermarkets, apparel, boutique, mono-brand, salon, gift | — |
| M2 | **Multi-store rollup** (zone/city comparison, footfall/conversion) | 🔴 Critical | supermarkets, mini-super, chains, electronics | zone/city, (footfall) |
| M3 | **Multi-location / multi-rack stock** (bin/rack locations per SKU) | 🔴 Critical | supermarkets, mini-super, mono-brand | — |
| M4 | **Services & Appointments** (booking + calendar, membership/package billing, service catalogue) | 🔴 (salon/fitness/optical) | salon, fitness, optical | service-wise revenue, appointment utilisation |
| M5 | **Staff Operations** (RBAC, attendance/payroll, commission, shift/roster, task checklist, staff perf report) | 🟠 Important | supermarkets, apparel, salon | staff performance |
| M6 | **Orders & Fulfilment** (purchase order to supplier, online catalogue / WhatsApp ordering, returns & exchange, estimate/proforma, split billing, home delivery) | 🟠 Important | supermarkets, apparel, most retail | — |
| M7 | **Warranty & Serial** (IMEI/serial register + warranty-claim tracking) | 🟠 (electronics) | mobile & electronics | warranty-claim rate |
| M8 | **Customer 360+** (referral tracking*, wishlist/saved cart, prescription/fitting profile, style/size profile) | 🟠 Important | optical, apparel, boutique | (rx-renewal w/ M4) |
| M9 | **Job Cards / Repair** (alteration job — apparel; repair job card — mobile/optical; bakery pre-order/custom cake) | 🟠 (vertical) | apparel, electronics, optical, bakery | — |
| M10 | **AI/Smart upgrades** (WhatsApp AI chatbot, demand forecast, personalised suggestion, price optimisation, outfit recommender, Rx renewal reminder) | 🟠 Important | broad | outfit-uptake, attach-rate, rx-renewal |

\* Referral tracking partly exists (referral campaign tables) — M8 would extend it.

### Reusable building blocks already in the codebase
- **referral** tables → extend for M1/M8 · **baskets** → reuse for M9 bundles/outfits · **udhaar split** → partial M6 split-billing · **intelligence engine** → M2 footfall, M10 forecasting · **product_supplier** → M6 purchase orders · **F2 serial flag** → M7.

## Prioritisation (proposed — to confirm)
Guru's 🔴 Criticals first, weighted by breadth and KPI unlocks:
1. **M1 Loyalty & Offers** — widest vertical impact, pure revenue lever, reuses referral/baskets.
2. **M4 Services & Appointments** — unblocks an entire vertical class (salon/fitness/optical) that today has *no* core workflow; unlocks 2 KPIs.
3. **M2 Multi-store rollup** — Guru 🔴, unlocks zone/city; needed for chains/supermarkets.
4. **M5 Staff Ops** then **M6 Orders & Fulfilment** (broad 🟠).
5. **M7 Warranty**, **M9 Job Cards**, **M8 Customer 360+**, **M10 AI** — vertical-specific / enhancement.
6. **M3 Multi-rack** — valuable but lower urgency for single-location stores.
