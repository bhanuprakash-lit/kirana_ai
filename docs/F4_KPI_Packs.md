# F4 — Vertical KPI Packs (admin-controlled visibility)

> Sourced from **Guru's Feature Gap Analysis** (`docs/Guru_Kirana_AI_Feature_Gap_Analysis.xlsx`, Reports/Analytics + AI rows). Every KPI Guru flagged per vertical is now **registered** and shown in the **admin panel → KPI Visibility**. Computable ones are live; the rest are *"coming soon"* (hidden from shopkeepers by default) and an admin can switch them on **per vertical** the moment the data lands — no app release needed.

## How it works

- **Registry** (`kpis/registry.py`): each `KPIDef` now carries `verticals: list[str]` (empty = applies to all). The 46 existing KPIs stay untagged (visible to every vertical); 12 new Guru KPIs are tagged to their verticals.
- **Status**: `ok` (computable, shown by default) vs `data_unavailable` (registered, hidden by default, carries a `missing_data` note).
- **Visibility override** (`kpi_visibility_config` table): per `(kpi_id, vertical_code)` an admin can force show/hide. No row → registry default.
- **Admin panel**: *KPI Visibility* page — a KPI × vertical toggle grid (`GET/PUT /kirana/admin/kpi-visibility`).
- **App**: `GET /kirana/kpis/visible` returns the store's effective set (vertical pack ∩ admin visibility). The Flutter `visibleKpisProvider` consumes it, so admin changes reflect live.
- **Vertical codes**: `grocery, apparel, footwear, electronics, optical, services, general`.

## Status: existing vs. data-needed

### ✅ Already computable (live, common to all verticals)
Daily revenue, gross-profit-margin, avg-basket-value, stockout-rate/lost-sales, dead-stock, repeat-customer, category-mix, shrinkage, inventory-turnover/holding, walk-in→purchase, GST (F3), … (the existing 46). These already cover much of Guru's *Daily sales report, P&L, Fast/slow-moving, Category analytics, Footfall/conversion, Anomaly/shrinkage*.

### ✅ New vertical KPIs now LIVE (calculators written, `kpis/calculators/vertical.py`)

| KPI | Verticals | Slug | Source |
|---|---|---|---|
| Sell-through % | apparel, footwear | `sell-through` | variant sales (F2) ÷ (sold + stock) |
| Size-curve / size-mix | apparel, footwear | `size-curve` | `product_variant.attributes->>'size'` + variant sales |
| Markdown % | apparel, footwear | `markdown` | `order_item.unit_price` vs `pricing.mrp` |
| GMROI | apparel, footwear, electronics | `gmroi` | `order_item.cost_price` (F3) ÷ avg inventory cost |

> These are `status=ok` — an admin can switch them on for their verticals from the KPI Visibility page and they compute live.

### 🚧 Still "coming soon" (registered, need a module first)

| KPI | Verticals | What it needs | What exists |
|---|---|---|---|
| Outfit/bundle uptake | apparel, footwear | recommender + calc | ✅ basket co-occurrence data |
| Accessory attach-rate | electronics | coming-soon | calculator + category links | ⚠️ needs accessory↔device category mapping |
| Warranty-claim rate | electronics | coming-soon | calculator | ❌ needs a **warranty/serial claim register** (F2 has `serial` flag only) |
| Prescription renewal due | optical | coming-soon | calculator | ❌ needs an **optical prescription register** |
| Service-wise revenue | services | coming-soon | calculator | ❌ needs a **services + appointments module** |
| Appointment utilisation | services | coming-soon | calculator | ❌ needs an **appointments module** |
| Zone / city comparison | all (Guru 🔴) | coming-soon | calculator | ❌ needs **multi-store rollup** (one owner, many stores) |
| Staff performance | all | coming-soon | calculator | ❌ needs a **staff/roster module** + per-staff sale attribution |

**Legend:** ✅ data exists (just needs a calculator) · ⚠️ partial · ❌ needs a new module first.

## Other F4 sub-parts (done)

- **ML profiles** — `kpis/calculators/core.py::ML_PROFILES` + `ml_profile_for(engine, store_id)` resolve thresholds from `vertical_config.ml_profile`. `calc_dead_stock` now uses a per-vertical "unsold-for-N-days" window (grocery 21d, apparel 60d seasonal, electronics 45d, services 30d).
- **AI intake** — `ai/routes.py` voice + handwriting extraction append a vertical hint (`_vertical_hint`) so apparel captures size/colour, electronics captures model/storage, etc. Grocery unchanged.
- **Vision gating** — `vertical_config.features.vision` (grocery true, others false); the app drops the Vision tab when `verticalConfigOf(ref).isOff('vision')`. Absent flag (legacy stores) keeps Vision on.

## Next steps (to turn remaining "coming soon" → live)
1. **Quick wins** (data already exists from F2/F3): write calculators for **sell-through, size-curve, markdown %, GMROI** and flip their status to `ok`. These are the highest-value apparel/footwear/electronics KPIs.
2. **Need a module first:** warranty-claim (warranty register), prescription-renewal (optical module), service-wise revenue + appointment utilisation (services module), zone/city (multi-store), staff performance (staff module) — these align with the playbook's "net-new modules".

Until then, an admin can already preview/enable any of them per vertical from the KPI Visibility page.
