# Vertical UX Audit — where the app stops fitting the store

**Date:** 2026-07-14 · **Scope:** whole app (FE) + vertical config (BE) · **Companion:** `Incomplete_Features_Audit.md` (hollow features — fixed), this doc is about **vertical fit**: features in the wrong place, uncustomized UX, and basics that are hard to find.

---

## 1. The system as built

- **Onboarding offers 16 store types** (`business_step.dart`): kirana, supermarket, mini_supermarket, mono_brand, apparel, boutique, salon, fancy_gift, sports_fitness, electronics, footwear, optical, bakery, stationery, fruits_vegetables, other.
- They collapse into **7 vertical configs** (`_mapVertical` → `vertical_config` table): grocery, apparel, footwear, electronics, optical, services, general.
- A config carries: **7 feature flags** (expiry, loose, variants, serial, warranty, appointments, vision), a **unit set**, ml/tax profile names, and a **copy pack**.
- The app checks the config at ~12 call sites: nav (vision tab), add/edit product sheets, POS bottom-bar swaps, checkout deep-links, variant picker, and 4 profile-menu rows.

That's the whole vertical system. Everything else — navigation, home screen, tab names, marketing modules, ML surfaces, empty states — is identical for a salon, a mobile shop, and a kirana.

## 2. Core diagnosis

**The app is a grocery app; other verticals get "grocery minus a few fields," not "their app."** The flags mostly *remove* grocery-isms (expiry, loose, vision) and *add* form fields (variants, serial, warranty). No vertical gets its **primary workflow promoted**: nav is always Home / Khata / Billing (+Vision for grocery), and every non-grocery differentiator lives 3+ taps deep behind the Profile avatar.

---

## 3. Findings

### F1 — Vertical copy packs are empty; the app never speaks the trade's language
- All 7 seed rows have `copy_pack = '{}'` (`base.py` seed) and the seed **intentionally never overwrites** copy_pack — but nothing ever filled them.
- The entire app has **3** `copy()` hooks total: add-product title, product search hint, empty-inventory title. All fall back to grocery wording.
- Net effect: an optician "Adds Product" to "Inventory"; a salon's services tab is called **Billing**; a boutique reads "items sold" copy written for provisions. The copy customization system exists and is 0% used.

### F2 — The home screen is grocery for everyone
`overview_tab.dart` renders the same list for all verticals:
- `_MorningBriefingRibbon` + `_IntelligenceStrip` — reorder/dead-stock/expiry ML written for grocery velocity.
- `ForecastStrip`, `_TodaySalesCard`, `_KpiSummaryRow` — generic.
- **`_VerticalKpiSection` is commented out** (lines 211/251) — the one component built to make home vertical-aware (F4 KPI packs) is not rendered.
- No per-vertical quick actions. A salon's home has no "Book appointment"; an electronics store has no "New job card / Check warranty"; a boutique has no "New estimate".

### F3 — Primary workflows are buried in the Profile junk drawer
The Profile menu is the de-facto module launcher (20+ rows, 6 sections, behind the small avatar on home):
- **Salon / fitness (services):** appointments — their calendar, the first thing they open every morning — is at *Profile → Sales & marketing → Services & Appointments*. The bottom nav wastes a tab on **Khata** and gives them Billing with **Procurement** as a sub-tab, while appointments get no nav presence at all (only a swapped button inside POS).
- **Electronics:** Warranty and Job Cards (repairs) at *Profile → Operations*. "Customer walks in with a dead phone" — the single most common non-sale interaction — starts from the profile menu.
- **Apparel/boutique:** Estimates (their quotation habit) at *Profile → Operations → Estimates & Returns*.
- **Everyone:** Customers, Staff, Transaction History — basic daily objects — only exist behind Profile.

### F4 — A salon cannot sell a haircut from the sale screen
POS search only searches **products**. The service catalogue (M4) is a separate world; a service can only be billed by first creating an appointment, then linking it at checkout via the deep-link section. For services verticals the **basic act of billing their actual offering** doesn't exist where billing lives. (`searchresults.dart` has zero service awareness.)

### F5 — The 16→7 mapping mis-fits several store types
| Store type | Mapped to | Problem |
|---|---|---|
| `sports_fitness` | services | A sports shop sells shoes/apparel/equipment → needs **variants** (off), gets **appointments** (marginal) |
| `mono_brand` | apparel | A mono-brand mobile/appliance store needs serial+warranty, gets size/colour variants |
| `fancy_gift`, `stationery` | general | "general" = everything off — no vision, no variants, no expiry. It's grocery-minus, nothing tailored (no gift-wrap/occasions, no school-season anything) |
| `bakery` | grocery | Gets full grocery incl. shelf-Vision and reorder ML tuned for packaged goods; production/own-make items don't fit "procure & restock" |
| `fruits_vegetables` | grocery | Loose+expiry fit, but Vision shelf-scan and MRP-centric flows don't |
| *pharmacy* | — | **Not offered** in the picker at all (the mapping comments reference it), despite expiry/batch being built and pharmacies being the natural best-fit vertical |
| `other` | grocery | Unknown trades get the *most* grocery-specific app, not the most neutral one |

### F6 — Features shown where they add noise (weak gating)
- **Vision shelf-scan CTA in the empty-inventory state is NOT gated** (`_EmptyInventory` always shows "photograph your shelves") — apparel/electronics stores are pushed into a flow their vertical has off. Same for the Vision quick-path in `showAddProductSheet`'s surroundings.
- **My Baskets** (grocery combo tiers) and grocery-flavored **Campaigns** show for salons/electronics/opticians.
- **Associations** (apartment/hostel/colony heatmap) — conceived for kirana catchment marketing — shows for every vertical.
- **Procurement** is a top-level sub-tab of Billing for all verticals, incl. services where it's marginal.
- **ML flag chips** (fast-moving / reorder / dead-stock) render for all verticals from grocery-profile inference.
- Conversely **GST report is hidden from grocery entirely** — registered kiranas file GST too. Should be a store-level setting, not vertical gating (already flagged in the previous audit, still unfixed).

### F7 — Where basics hide (discoverability inventory)
| Basic thing an owner looks for | Where it actually is | Taps |
|---|---|---|
| Book/see appointments (salon) | Profile → Sales & marketing → Services | 3 + scroll |
| Check a warranty / register claim | Profile → Operations → Warranty | 3 |
| New job card (repair/alteration) | Profile → Operations → Job Cards | 3 |
| Make an estimate | Profile → Operations → Estimates & Returns | 3 |
| Add/find a customer | Profile → Customers → Customer Relations (or mid-sale) | 3 |
| Staff attendance | Profile → Operations → Staff | 3 |
| Day's transactions | Profile → Analytics → History (also `/pos-history` from a home metric — two entries, different screens) | 3 |
| Printer setup | Inside POS checkout status line only | hidden |
| Expenses / cashflow | Banner card on Profile | 2, unlabeled |
| Switch store / language | Profile → Preferences | fine |

### F8 — Cross-cutting inconsistency on precisely the vertical surfaces
- The vertical-swapped controls are **hardcoded English** in a 7-language app: POS bottom bar (`'Scan'`, `'Appointments'`, `'Prescription'` in `posbottombar.dart`), the customer-price sheet, parts of the deep-link section. The newest (vertical) surfaces are the least localized.
- Terminology drift: nav tab **Billing** contains tabs *Sale / Stock / Suppliers*; nav tab **Khata** contains *Cashflow / Customer udhaar / Distributor*. Sub-tab names don't match their parent.
- Deep-link/tab index contracts assume the grocery tab set (vision last), which works but is fragile the moment nav becomes per-vertical.

---

## 4. Recommended fix plan (vertical-by-vertical ready)

**Phase V0 — foundations (1 pass, benefits all verticals)**
1. Un-comment/rebuild `_VerticalKpiSection`; add a **per-vertical quick-action row** on home (data-driven from config).
2. Fill the 7 **copy packs** (backend seed) + grow `copy()` hooks to the ~15 top surfaces: nav labels, sub-tab titles, add/edit flows, empty states, FAB labels.
3. Gate the vision shelf-scan CTAs with the existing `vision` flag; l10n sweep of the vertical-swapped controls.
4. GST report → store-level toggle (visible for grocery when enabled).
5. Mapping fixes: `sports_fitness` → variants-on profile; add `pharmacy` store type (grocery profile + expiry emphasis); reconsider `mono_brand`; make `other` map to `general`, not grocery.

**Phase V1 — per-vertical nav preset (the big UX unlock)**
Nav becomes config-driven (4 slots):
- grocery: Home / Khata / Billing / Vision *(unchanged)*
- services (salon/fitness): Home / **Appointments** / Billing / Khata
- electronics: Home / Billing / **Repairs & Warranty** (job cards + claims + serials) / Khata
- optical: Home / **Appointments** / Billing / Khata (prescription stays in POS)
- apparel/footwear: Home / Billing / **Orders** (estimates + returns + job cards) / Khata
- general: Home / Billing / Khata / Customers

**Phase V2 — services sellable at POS**
Service catalogue items appear in POS search (chip-tagged), billable without an appointment; appointment deep-link stays for booked work.

**Phase V3 — per-vertical marketing surface**
Baskets/Campaigns/Associations shown or re-skinned per vertical (services → memberships & offers; electronics → exchange/EMI campaigns later; hide grocery combos elsewhere).

Then iterate vertical by vertical (services first — largest gap between what they need and what they see; then electronics, then apparel/footwear/optical, then general).
