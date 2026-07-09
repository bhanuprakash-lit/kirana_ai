# Incomplete-Feature Audit & Fix Plan

**Date:** 2026-07-03 · **Scope:** app + backend (vision excluded)

The gap-analysis / module-sweep approach produced features that *exist* but aren't
*usable* — they demo well and die on first real use. This audit names each one, the
exact defect, and the fix. The good news: **in almost every case the backend is ahead
of the frontend** (endpoints/columns already exist), so most fixes are FE work + small
BE glue.

## The disease — 6 recurring patterns

| # | Pattern | Example |
|---|---------|---------|
| 1 | **Raw-ID inputs** — user asked to type internal IDs the app itself knows how to pick | Stock racks "Product ID" field (caused the prod FK-500) |
| 2 | **Split-brain features** — same concept implemented twice, disconnected | POS returns (`/kirana/returns`) vs Returns tab (`/kirana/sales-returns`) |
| 3 | **Write-only data** — you can create records but never see/act on them | Estimates: no detail, no status change, no convert, no share |
| 4 | **Decorative fields** — shown or stored but nothing can set/use them | `commission_pct` on staff cards; `warranty_until` never displayed |
| 5 | **Loop not closed** — the one step that makes the feature valuable is missing | Racks: placement exists but "where is product X?" from inventory doesn't; staff: attendance ✓ but sales can't be attributed → commission is meaningless |
| 6 | **Dumping-ground navigation** — 12 unrelated rows under Profile→"Analytics"; weak vertical gating (Job Cards shown to grocery stores) | Profile screen |

Cross-cutting: the module screens (staff, racks, fulfilment, warranty, jobcards) are
**hardcoded English** in a 7-language app, pop sheets with **no success feedback**, and
render raw exceptions (`Text('$e')`).

---

## A. Stock Racks — P0 (unusable as shipped)

**Today:** search-a-rack box + "Place stock" sheet asking for raw **Product ID**, rack
label, qty. No product picker, no rack browsing (empty screen until you guess a rack
name), no move/remove, no link from inventory, silent success. Typing a wrong ID caused
the production FK-500.

**Fix:**
1. Replace Product ID with the **existing product picker** (posProvider search — same
   pattern as return sheet / wishlist picker) + **barcode scan** option.
2. Default view = **list of racks with item counts** (backend `find_by_rack` with empty
   query, or new `GET /kirana/racks/summary`), tap → rack contents. Search stays.
3. **Integrate with inventory**: product detail/row shows its rack badge; a "Set
   location" action opens the same place-sheet pre-filled. This is the real use case —
   *find the item fast* — and it must live where the product is, not in a side screen.
4. Row actions: change qty, move rack, remove.
5. Success snackbar + list refresh after placing.

**BE:** exists (`GET/POST /products/{id}/locations`, `DELETE /locations/{id}`,
`GET /racks`). Add only a rack-summary aggregate if needed.

## B. Returns — P0 (split-brain, data integrity)

**Today:** two parallel half-features.
- POS order-details → `showReturnSheet` → `POST /kirana/returns`: item-level,
  restocks resaleable stock, logs damaged to `return_to_vendor` — but writes **no
  `sales_return` record**, so the Returns tab never shows it.
- Profile → Estimates & Returns → "Log return" → `POST /kirana/sales-returns`: writes a
  bare `sales_return` (manual order #, free-typed refund) — touches **no items, no
  stock**.

**Fix:**
1. **One write path**: `record_return` also inserts the `sales_return` row (same txn:
   order_id, refund, is_exchange, per-item detail). Deprecate the free-form POST.
2. Returns tab becomes **read-only unified history**: item names, order link,
   refund, restocked/RTV badges, date.
3. "Log return" FAB → **order picker** (recent orders, search by customer/phone) →
   opens the *same* POS return sheet. No more typed order numbers or invented refunds.
4. Refund amount defaults to sum of selected items' paid price (editable).
5. Order-details screen shows a "returned" badge/section once a return exists.

## C. Estimates — P1 (write-only)

**Today:** create sheet takes **one** free-text item (backend accepts a list), list
shows name/status/total. No detail view, no status transitions, no convert-to-sale, no
share — but an estimate's whole job is to be **handed to a customer** and later
**become a sale**. Backend already has `GET /estimates/{id}` and
`PATCH /estimates/{id}` (status + order_id link) — FE uses neither.

**Fix:**
1. Multi-line items: product picker with price prefill + free-text fallback row.
2. Detail sheet: items, totals, status chips (draft → sent → accepted/rejected).
3. **Convert to sale**: accepted estimate → prefill the POS cart with its items →
   normal checkout → PATCH estimate with the order_id. (Cart-prefill hook in
   posProvider; same bridge campaigns→basket used.)
4. **Share**: render estimate as text/PDF → WhatsApp share (reuse receipt formatting).
5. Optional validity date.

## D. Staff — P1 (loop not closed)

**Today:** roster + attendance + tasks work. But: no edit/deactivate UI (backend PATCH
supports name/phone/role/commission/is_active — FE never calls it); `commission_pct`
is displayed yet nothing can set it and no sale is ever attributed to a staff member,
so commission and "sales by staff" are fiction; tasks are one-shot ("daily checklist"
copy is wrong — they never reset) and can't be deleted.

**Fix:**
1. Edit-staff sheet (all PATCH fields incl. commission % and active toggle).
2. **"Billed by" (optional) on POS checkout** → `orders.staff_id` column (small BE
   migration) → staff screen gains a "Sales this month" per member + commission ₹
   computed = sales × pct. This single link makes the whole module real.
3. Tasks: swipe-to-delete; done tasks auto-clear at day start (or a Today/All filter);
   fix the copy.

## E. Warranty & Serials — P1 (half-good)

**Today:** claim flow is fine (serial picker, status chips). Serials tab is a dead list:
serial + status only — **no product name** (the API already returns it), no
`warranty_until`, no sold date, no search/filter, no way to register a serial outside
checkout. Claims show no customer or dates.

**Fix:**
1. Serials list: product name + variant, sold date, **warranty-until badge**
   (active / expiring / expired), search + status filter.
2. Add-serial sheet: product picker + **scan serial barcode** (stock-in path;
   backend `add_serial` exists).
3. Claim cards: customer name, created date, days-open.
4. (Phase 2) "warranty expiring this month" notification for sold serials.

## F. Navigation & gating — P2

1. Split Profile→"Analytics" (12 rows) into: **Operations** (Staff, Stock Racks,
   Estimates & Returns, Job Cards, Warranty), **Analytics** (KPIs, History, Store
   Comparison), **Marketing/Customers** (Loyalty, Baskets, Referral, Associations).
2. Vertical-gate Job Cards (services/apparel/footwear/optical/electronics — not
   grocery). Racks stay universal.
3. Re-check GST report gating: currently hidden for grocery — registered kirana stores
   file GST too; likely should be a store-level setting, not vertical.

## G. Cross-cutting polish — P2 (do alongside each module touch)

- Localize the module screens (staff/racks/fulfilment/warranty/jobcards are hardcoded
  English; every other surface ships in 7 languages).
- Success snackbars on every sheet-save; friendly error states instead of `Text('$e')`.
- Consistent empty states with a "what is this / first action" hint (racks and
  fulfilment currently show one grey line).

## Not broken (checked, no action)

- **Job Cards** — customer picker, promised date+time, status flow; content-complete.
  Only needs gating (F2) + l10n (G).
- **Associations** — self-contained marketing planner (areas + customer heatmap);
  usable as-is, low value but harmless.
- **Services/Appointments, Loyalty, Referral, Baskets** — richer builds from their own
  passes; not in this audit's disease pool.

---

## ✅ Status — all P0–P2 implemented (2026-07-06)

- **P0-B Returns** — DONE. `record_return` now writes `sales_return` + `sales_return_item` in the same txn (new table); Returns tab is unified read-only history with items/restock/RTV badges; Log-return → order picker → the POS return sheet (now with refund + exchange fields); order-details shows a "returns on this bill" card.
- **P0-A Stock racks** — DONE. Rebuilt: browse-by-rack with counts, shared product picker (+barcode) instead of raw Product ID, move/remove/change-qty, inventory long-press → per-product rack sheet + "Set location". New `GET /kirana/racks/all`.
- **P1-C Estimates** — DONE. Multi-line editor (catalog picker + free-text), detail sheet with status chips, **convert-to-sale** (prefills POS cart → billing tab), WhatsApp share.
- **P1-D Staff** — DONE. Edit sheet (name/phone/role/commission/active), task delete + copy fix, **`orders.staff_id`** + "Billed by" at checkout → per-member sales + commission on the staff card (`GET /kirana/staff/sales`).
- **P1-E Serials** — DONE. Rich rows (product name, sold date, warranty-until urgency badge), search + status filter, add-serial sheet (product picker), tab-aware FAB; claim cards show customer + date.
- **P2-F Nav** — DONE. Profile "Analytics" dump split into Operations / Sales & marketing / Analytics; Job Cards gated to non-grocery.
- **P2-G l10n** — DONE for the visible chrome (titles, tabs, FABs, empty states, segments, primary sheets) across staff/warranty/jobcards/racks/fulfilment, all 7 locales. Remaining (lower-visibility): deep sheet field-labels/validation messages in the staff add-sheets, attendance chip words, and the serial-picker search/status strings — safe to finish incrementally.

Verified: `flutter analyze lib` clean; backend 163 tests pass + boots (327 routes).

## Suggested order of work

| Phase | Items | Why first |
|-------|-------|-----------|
| **P0** | B (returns unification), A (stock racks) | B is a data-integrity bug users already hit; A is the named unusable screen + prod-500 source |
| **P1** | C (estimates lifecycle), D (staff loop), E (serials) | Turns three "exists" features into usable ones; all FE-heavy, BE mostly ready |
| **P2** | F (nav + gating), G (l10n + polish) | Perception of quality; G folds into whichever screens P0/P1 touches anyway |
