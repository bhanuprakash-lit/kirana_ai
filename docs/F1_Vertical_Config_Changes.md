# F1 — Vertical Config: what we changed & how it fills the gap

> **Goal of F1 (per `Gap_Fill_Playbook.md`):** one master switch per *vertical* that the
> whole app reads, so the ~80% of "features" that are really *"behave differently for this
> kind of shop"* become a **config read** instead of a new system. Today `store.store_type`
> existed but branched nothing — every shop behaved like a grocery store.

F1 is now **complete end-to-end**: a shop picks its type at onboarding → that maps to a
coarse `vertical_code` → the backend serves that vertical's config → the app branches UI,
units, and (later) KPIs/ML/tax off it.

---

## The two-level model

| Level | Field | Granularity | Example |
|---|---|---|---|
| What the owner picks | `store.store_type` | 14+ granular labels | `boutique`, `optical`, `bakery` |
| What the app branches on | `store.vertical_code` | 7 behaviour profiles | `apparel`, `optical`, `grocery` |

Many store types collapse onto one behaviour profile — that collapse is the whole point
(don't build 14 things, build 7 config rows + a map).

### Store type → vertical mapping (frontend `onboarding_provider._mapVertical`)

| Store type (picker) | vertical_code |
|---|---|
| Kirana / General Stores, Supermarket, Mini Supermarket, Provision, Fruits & Veg, Pharmacy, Bakery & Sweet | **grocery** |
| Clothing & Apparel, Boutique, Mono Brand | **apparel** |
| Footwear | **footwear** |
| Mobile & Electronics | **electronics** |
| Optical | **optical** |
| Saloon & Parlour, Sports & Fitness | **services** |
| Fancy & Gift, Stationery & Books | **general** |
| Others / unknown | **grocery** (safe everything-on default) |

### What each vertical turns on (backend seed in `repositories/base.py`)

| vertical | expiry | loose | variants | serial | warranty | appointments | units |
|---|:--:|:--:|:--:|:--:|:--:|:--:|---|
| grocery | ✅ | ✅ | — | — | — | — | pcs, kg, g, L, ml, dozen, pack, box, bundle |
| apparel | — | — | ✅ | — | — | — | pcs, pair, set |
| footwear | — | — | ✅ | — | — | — | pair, pcs, set |
| electronics | — | — | ✅ | ✅ | ✅ | — | pcs, set |
| optical | — | — | ✅ | — | ✅ | ✅ | pcs, pair |
| services | — | — | — | — | — | ✅ | pcs, session, hour |
| general | — | — | — | — | — | — | pcs, pack, box, set |

> `variants`, `serial`, `warranty`, `appointments` are flags that **later foundations**
> (F2 variants, F3 tax, the Services module) read. F1 just sets the switch so those land as
> config reads, not rewrites.

---

## Backend changes (`kirana-master-backend`)

1. **Schema + seed** — `kirana/repositories/base.py` (`_ensure_schema`):
   - `CREATE TABLE kirana_oltp.vertical_config (vertical_code PK, features JSONB, unit_set, attribute_set, kpi_set, ml_profile, tax_profile, copy_pack)`.
   - `ALTER TABLE store ADD COLUMN vertical_code` (coarse switch; granular `store_type` untouched).
   - Seeds the **7 verticals** above (`ON CONFLICT DO NOTHING` → idempotent, never clobbers edits).
   - Backfills existing stores → `grocery` (all current data is grocery-family), guarded by `WHERE vertical_code IS NULL` so it's a no-op after the first boot.
2. **Read API** — `repositories/store.py::get_vertical_config(store_id)` joins the store to its
   vertical row, `COALESCE(..., 'grocery')` so a missing code/row can never break a caller.
   Exposed at **`GET /kirana/vertical-config`** (`routers/auth.py`).
3. **Persist at signup** — registration now writes the vertical:
   - `schemas.py`: `RegisterStoreOwnerRequest.vertical_code: Optional[str]`.
   - `service.register_store_owner` → passes it to
   - `repositories/store.register_store_owner_atomic`, whose `store` INSERT writes
     `COALESCE(:vc, 'grocery')`.

## Frontend changes (`kirana_ai`)

1. **Model + provider** — `lib/core/vertical/`:
   - `vertical_config.dart` — `VerticalConfig` (features map, `unitSet`, `copyPack`, `has('flag')`),
     with a `grocery` constant that doubles as the **offline/failure fallback** (UI behaves exactly
     as today if the fetch fails).
   - `vertical_config_provider.dart` — `verticalConfigProvider` (fetches once, caches for the
     session) + `verticalConfigOf(ref)` for synchronous reads in `build`.
2. **Onboarding** — `business_step.dart` now offers the full store-type list;
   `onboarding_provider`:
   - `_mapStoreType` whitelists all the new codes (so `store_type` keeps the granular label),
   - `_mapVertical` collapses them to the 7 verticals,
   - `register(..., verticalCode: ...)` sends it (`auth_repository.register` adds `vertical_code`
     to the payload).
3. **First config reads wired** — `add_product_sheet_new/addproductscreen.dart`:
   - `if (verticalConfigOf(ref).has('expiry')) …` — hides the expiry picker for non-perishable shops.
   - `if (verticalConfigOf(ref).has('loose')) …` — hides loose/by-weight controls.
   - unit dropdown reads `verticalConfigOf(ref).unitSet` instead of the old hardcoded list.

---

## How this fills the gap

- **An apparel/footwear/electronics/optical/services shop can finally *exist*.** Before, every
  store was grocery; now the type chosen at onboarding actually changes app behaviour.
- **Closes (from the backlog):** G-02 onboarding picker, G-03 hide grocery-only UI
  (expiry/loose/weight), G-09 per-vertical units — with **no new logic**, just config reads.
- **Turns future gaps into config, not systems:** G-16/24/29/31/32 (copy/widget/customer fields)
  read `copyPack`; G-19/20/21/25 (AI prompts / Vision / WhatsApp menus) choose by vertical;
  F2/F3/F4 read the `variants` / `tax_profile` / `kpi_set` / `ml_profile` fields already seeded.
- **Safe by construction:** unknown type → grocery, failed fetch → grocery, missing column →
  `COALESCE` grocery. Existing grocery stores are unaffected.

## Not done yet (next)

F2 — **product variants** (`product_variant` + `product_attribute_def`, grocery = one implicit
variant) is the keystone the `variants:true` flag is waiting on, and what makes apparel/footwear/
electronics/optical actually sellable. Then F3 (tax/GST) and F4 (per-vertical KPI/ML/AI packs).
