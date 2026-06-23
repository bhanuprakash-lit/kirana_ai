# Gap-Fill Playbook — how to actually build it

> You felt stuck because the two sheets read as **~60 features**. As a developer you can't hold 60 features in your head. The trick: **~80% of those gaps collapse onto 4 foundations.** Build the foundations, and most "features" become *a config flag + a form field + a query* — not new systems.
>
> This doc is the developer view: the 4 foundations (what to create, where), the **unlock map** (which gaps each foundation kills), and the ~20% that are genuinely new modules.

---

## The mental model

```
                ┌───────────────────────────────────────────────┐
                │   F1. VERTICAL CONFIG  (the master switch)    │
                │   one row per vertical → flags/units/attrs/   │
                │   kpi-set/ml-profile/tax/copy                 │
                └───────────────┬───────────────────────────────┘
        ┌───────────────┬───────┴───────┬────────────────┐
        ▼               ▼               ▼                ▼
   F2. VARIANTS &   F3. TAX/GST     F4. VERTICAL      (config reads)
   ATTRIBUTES       ENGINE          KPI/ML/AI PACKS   → feature-flag UI,
   (product_variant,(tax_rule,                         units, copy, prompts,
    attribute_def)   gst at POS)                       vision gating, widget
```

Everything in both sheets is either: **(a) rides a foundation** (≈80%), or **(b) a net-new operational module** (≈20% — loyalty, services/appointments, staff ops, multi-store). Build (a) first; it's mostly mechanical once the foundation lands.

---

## Foundation 1 — Vertical Config layer  *(start here; ~1 week)*

**Why:** today `store.store_type` exists but branches nothing. One config object per vertical becomes the single switch the whole app reads.

**DB** (`kirana/repository.py` → `_ensure_schema`, same place the other `CREATE TABLE`s live):
```sql
CREATE TABLE IF NOT EXISTS kirana_oltp.vertical_config (
  vertical_code TEXT PRIMARY KEY,          -- 'grocery','apparel','footwear','electronics',...
  features      JSONB NOT NULL DEFAULT '{}',-- {expiry:false, loose:false, variants:true, serial:false, warranty:false, appointments:false, ...}
  unit_set      JSONB,                      -- ["pcs","pair","set"]
  attribute_set JSONB,                      -- which product_attribute_def codes apply
  kpi_set       JSONB,                      -- which KPI slugs to show
  ml_profile    TEXT,                       -- 'grocery'|'apparel'|'electronics'
  tax_profile   TEXT,
  copy_pack     JSONB                       -- brand name, example words, welcome copy
);
ALTER TABLE kirana_oltp.store ADD COLUMN IF NOT EXISTS vertical_code TEXT;
```
Seed one row per vertical (grocery = everything-on, others = expiry/loose OFF, variants ON, etc.). Backfill `store.vertical_code` from existing `store_type`.

**Backend:** `GET /kirana/vertical-config` → returns the calling store's merged config. (One handler, reads `store.vertical_code` → `vertical_config` row.)

**Frontend:** a `verticalConfigProvider` that fetches once at login and caches; a tiny helper:
```dart
final vf = ref.watch(verticalConfigProvider);
if (vf.has('expiry')) ExpiryPickerWidget(),   // else nothing
```

**Files you'll touch:** `kirana/repository.py` (schema+query), `kirana/routes.py` (endpoint), new `lib/core/vertical/vertical_config_provider.dart`, onboarding `business_step.dart` (real vertical picker → sets `vertical_code`).

### 🔓 What F1 alone unlocks (these stop being features, become 1-line config reads)
- G-03 hide grocery-only UI (expiry/loose/weight) → `if (vf.has('expiry'))`
- G-09 units per vertical → read `vf.unitSet` instead of the hardcoded `_units` list
- G-16 / G-24 dashboard + brand/example copy → read `vf.copyPack`
- G-29 / G-31 / G-32 customer fields / widget / basket copy → config
- G-19 / G-20 AI prompts, G-21 Vision on/off, G-25 WhatsApp menus → choose by `vf`
- Guru's "onboarding shows right store types" → the new picker

**That's ~10 of your 34 gaps closed by one foundation, with almost no new logic.**

---

## Foundation 2 — Product variants + dynamic attributes  *(the keystone; ~1.5 weeks)*

**Why:** apparel/footwear/electronics/cosmetics = one product, many sellable variants (size×colour, model/config, shade). Today that's impossible (each weight is a separate `product_id`). This is **Guru's #1 Critical** AND your G-04.

**DB:**
```sql
CREATE TABLE kirana_oltp.product_attribute_def (
  id BIGSERIAL PK, vertical_code TEXT, attr_code TEXT, label TEXT,
  type TEXT, options JSONB, is_variant_axis BOOLEAN, sort INT);

CREATE TABLE kirana_oltp.product_variant (
  variant_id BIGSERIAL PK, product_id BIGINT FK, sku TEXT, barcode TEXT,
  attributes JSONB,            -- {size:'M', colour:'Blue'}
  price NUMERIC, mrp NUMERIC, cost NUMERIC, is_active BOOLEAN);

ALTER TABLE inventory ADD COLUMN variant_id BIGINT;   -- stock per variant
-- order_item references variant_id too
```
**Migration rule that keeps grocery safe:** *grocery = one implicit variant.* Existing products get a single auto-variant; all old queries keep working. (This is your G-34 — do it in the same PR.)

**Backend:** CRUD for variants; inventory + order creation reference `variant_id` (fall back to the implicit one).

**Frontend:** size×colour **grid** in add-product (`add_product_sheet.dart`); **variant picker** before add-to-cart in POS (`pos_tab.dart` / `order_dialog.dart`) instead of the weight dialog.

### 🔓 What F2 unlocks
- G-04 variant mgmt (Guru Critical) · G-05 attributes · G-11 variant pricing · G-22 variant-aware POS · G-23 (with F3) tax on bill
- G-06 serial/IMEI and G-07 warranty become a *small extension* of variant (a `product_serial` child table) — Guru's "serial tracking" for electronics
- Guru's apparel/footwear/electronics/cosmetics catalog needs · size-curve KPIs (F4)

---

## Foundation 3 — Tax / GST engine  *(~3–4 days)*

**Why:** you found GST is parsed from invoices but **never applied at checkout**. Every higher-value vertical needs compliant tax + tax lines on the bill. (Your G-10/G-23; resolves the disagreement with Guru's matrix which assumed GST was done.)

**DB:** `tax_rule(hsn/category, min_price, max_price, gst_rate)`; add `product.hsn_code, product.gst_rate`.
**Backend:** at order create, resolve rate (HSN/category + price threshold) → store tax breakup on the order.
**Frontend:** tax lines on the cart summary, order details, and the **thermal receipt** template.

### 🔓 Unlocks: G-10, G-23, Guru's "GST-compliant invoicing" (made real), P&L COGS/margin accuracy (G-19/Guru P&L).

---

## Foundation 4 — Vertical KPI / ML / AI packs  *(rides F1; ~1 week per vertical)*

Once F1 exists, a "pack" = a named set the config points to.
- **KPIs:** `kpis/registry.py` — tag each KPI with the verticals it applies to; the dashboard reads `vf.kpiSet`. Add apparel pack (sell-through, size-curve, GMROI, markdown%) and electronics pack (attach-rate, warranty-claim, GMROI). *(G-13/14/15)*
- **ML:** `ml_models/` — per-vertical profile (features/windows/thresholds). The grocery `DEAD_STOCK_DAYS=21` etc. become per-profile. *(G-17/18, Guru demand-forecast)*
- **AI intake:** `ai/routes.py` — pick the prompt by vertical and **ground against the store's own catalog/variants** instead of the hardcoded grocery glossary. *(G-19/20)*
- **Vision:** gate off where unsupported via `vf.has('vision')`; redesign capture later. *(G-21)*

### 🔓 Unlocks: G-13–G-21, Guru's demand-forecast / personalised-suggestion / price-optimisation / anomaly (these are *tuning existing engines per profile*, not new engines).

---

## The ~20% that are genuinely NEW modules (Guru surfaced these — they don't ride a foundation)

Schedule these as standalone features *after* the foundation, because they're real subsystems:

| Module | Covers Guru gaps | Rough size |
|---|---|---|
| **Loyalty engine** (points, tiers, redemption) | Loyalty 🔴, Birthday/anniversary offers 🔴 | L |
| **Services pack** (appointments + calendar + membership/package billing) | Saloon/fitness/optical 🔴 | XL |
| **Staff ops** (attendance, shift roster, commission, performance report) | Commission 🔴, payroll/shift/task/perf 🟠 | L |
| **Multi-store rollup** (zone/city comparison, footfall) | Zone/city 🔴, footfall 🟠 | L |
| **Light add-ons** | discount/coupon rules, estimate/proforma, split pay, returns reason-codes, PO auto-fill, online catalogue | M each |

You already have the building blocks for some: **referral** (extend for referral-tracking), **baskets** (reuse for bundle/outfit), **udhaar** (credit, cross-vertical strength), **returns sheet** (extend with reason codes).

---

## Suggested order (and your 3–4 day spike)

**Correct overall order:** F1 → F2 (+migration) → F3 → F4 → new modules. Don't parallelise F2 against people building features that need variants — that's rework.

**For the 3–4 days you have now** (realistic — this is a *spike*, not the whole thing):
1. **Day 1:** F1 DB table + seed + `store.vertical_code` migration + `GET /vertical-config` + FE provider. (One BE dev + one FE dev.)
2. **Day 2:** Wire 3–4 config reads to prove it: hide expiry/loose (G-03), vertical units (G-09), onboarding picker (G-02). *Visible win, no new systems.*
3. **Day 3:** F2 schema (`product_variant`, `product_attribute_def`) + the grocery=implicit-variant migration, behind the flag. API CRUD stub.
4. **Day 4:** Tax-rule table + apply-at-checkout stub + tax line on receipt (F3). Demo: a non-grocery vertical that hides grocery fields, shows its own units, and a variant skeleton.

That gets the **spine in** — after which your team fills features against a foundation instead of from scratch, which is how you actually reach 80%.

---

*See `Combined_Gap_Backlog.xlsx` for the merged, de-duplicated task list (every gap → foundation it rides → owner/effort/priority).*
