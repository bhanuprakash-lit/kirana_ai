# Kirana AI — Store-wise Test Plan (Multi-vertical)

A checklist for the tester. Goal: every feature, in every relevant store, verified for
**(a) it works, (b) it's logically correct, (c) the UI is presentable.** Mark each row
Pass / Fail and add a note. Send back the failures + screenshots.

> Pharmacy is **out of scope** (separate app).

---

## Test account & stores

**Login:** account **`qwe`** (the existing owner). It now owns **7 stores — one per vertical.**

| Store | Vertical | What's special |
|---|---|---|
| Ram Electronics | electronics | variants (model/storage), serial/IMEI, warranty, attach-rate, repair job cards, GST |
| Sharma Opticals | optical | variants, appointments, warranty, prescription + renewal, GST |
| Sri Krishna Kirana | grocery | expiry, loose units, **Vision tab**, baskets |
| Trendz Apparel | apparel | variants (size×colour), sell-through/size-curve/markdown/GMROI/outfit, alteration job cards, GST |
| StepUp Footwear | footwear | variants, sell-through/size-curve, GST |
| Glamour Salon | services | appointments + memberships, service catalogue, service-revenue KPIs |
| Daily Needs Store | general | plain retail, loyalty, GST, common KPIs |

**Seeded in every store:** 4 customers (Ravi Kumar, Priya Sharma, Anil Reddy, Sita Devi —
Ravi has a birthday near today), 5 stocked products, 3 sample sales (2 cash + 1 udhaar).

**Switch stores:** Profile → **Switch / add store** → pick a store (the app reloads into it).
On login with multiple stores you also get a **store picker** first.

---

## A. Cross-cutting — test in EVERY store

| # | Feature | Steps | Expected | P/F |
|---|---|---|---|---|
| A1 | Login + store picker | Log in as qwe | Picker lists all 7 stores; selecting opens that store | |
| A2 | Switch store | Profile → Switch/add store → pick another | Whole app reloads for the new store (name, products, KPIs, vertical features all change) | |
| A3 | Add store | Switch sheet → Add a store → name + type + city | New store created, becomes active, opens its (empty-ish) dashboard | |
| A4 | No "request trial" wall | Open each store | Goes straight to dashboard (all stores on trial) — **never stuck on request-trial** | |
| A5 | Home dashboard | Open home | Morning briefing, today's sales (₹ from seeded orders), KPI summary, store overview card all render; numbers are store-specific | |
| A6 | POS billing | Billing tab → add stocked products → checkout (cash) | Order places, stock decrements, receipt/summary shows | |
| A7 | POS udhaar | Checkout → Udhaar → pick customer → place | Finance/Udhaar reflects the credit for that customer | |
| A8 | Inventory/Stock | Stock tab | Shows the 5 stocked products with qty; category filter shows **this vertical's** categories only | |
| A9 | Add product (catalog) | Stock → Add → search | Search returns **this vertical's** catalog (not kirana items in non-grocery); title/hint wording matches vertical | |
| A10 | Add product (manual) | Add → manual entry | Category dropdown shows **this vertical's** categories | |
| A11 | Customers | Customers list | 4 seeded customers; open one → history shows their orders | |
| A12 | Loyalty | Profile → Loyalty → enable; checkout with a customer | Points earn; redeem at checkout; coupon create + apply | |
| A13 | KPIs | Profile → KPI subscriptions / dashboard KPIs | Only this vertical's visible KPIs appear | |
| A14 | Finance | Finance tab | Sales, udhaar, overview reflect seeded orders | |
| A15 | Language | Profile → Language → switch | UI strings translate | |
| A16 | Staff / Estimates / Stock racks / Job cards | Profile entries | Each screen opens and basic create works | |

---

## B. Per-vertical — gated features

### B1. Grocery (Sri Krishna Kirana)
| # | Test | Expected | P/F |
|---|---|---|---|
| G1 | **Vision tab present** in bottom nav | Vision AI tab visible (grocery only) | |
| G2 | Vision shelf scan | Upload photos → detections → results | |
| G3 | Add product shows **expiry + loose** fields | Expiry date + loose-unit toggle present | |
| G4 | Units list | kg/g/L/ml/pcs/dozen… available | |
| G5 | **No** variants / GST / serial fields | Those fields absent | |
| G6 | Baskets | Profile → My Baskets works | |

### B2. Apparel (Trendz Apparel)
| # | Test | Expected | P/F |
|---|---|---|---|
| AP1 | **No Vision tab** | Vision absent | |
| AP2 | Variants | Add/edit product → size × colour grid; POS asks variant before add-to-cart | |
| AP3 | Per-variant stock | Each variant tracks its own stock; sale decrements the right variant | |
| AP4 | GST/HSN fields | Present in add/edit product; "Incl. GST" on cart; receipt breakup | |
| AP5 | Apparel KPIs | sell-through, size-curve, markdown, GMROI, outfit/bundle uptake visible | |
| AP6 | Job cards (alteration) | Profile → Job Cards → create alteration | |
| AP7 | GST Report | Profile → GST Report → month summary with CGST/SGST | |

### B3. Footwear (StepUp Footwear)
| # | Test | Expected | P/F |
|---|---|---|---|
| F1 | Variants (size/colour) | grid + POS picker | |
| F2 | Footwear KPIs | sell-through, size-curve, markdown, GMROI | |
| F3 | GST fields + report | as apparel | |
| F4 | No Vision tab | absent | |

### B4. Electronics (Ram Electronics)
| # | Test | Expected | P/F |
|---|---|---|---|
| E1 | Variants (model/storage) | grid + POS picker | |
| E2 | **Serial/IMEI at sale** | Checkout shows "Serial / IMEI sold" field; serials recorded against the order | |
| E3 | Warranty | Profile → Warranty → serials + claims; create a claim | |
| E4 | Attach-rate KPI | accessory attach-rate visible | |
| E5 | Warranty-claim-rate KPI | visible | |
| E6 | Repair job card | Job Cards → create repair | |
| E7 | GST fields + report | present | |
| E8 | No Vision tab | absent | |

### B5. Optical (Sharma Opticals)
| # | Test | Expected | P/F |
|---|---|---|---|
| O1 | Appointments | Profile → Services → book appointment, complete/cancel/no-show | |
| O2 | **Bill appointment at checkout** | Checkout shows "Bill an appointment" (today's booked) → links + completes | |
| O3 | Membership at checkout | If a membership exists, "Use a membership session" appears | |
| O4 | Warranty | Warranty screen works | |
| O5 | Prescription | Customer detail → Profile & Wishlist → prescription | |
| O6 | Rx-renewal KPI | prescription-renewal-due visible (needs a prescription_date to populate) | |
| O7 | Variants + GST + report | present; no Vision tab | |

### B6. Services / Salon (Glamour Salon)
| # | Test | Expected | P/F |
|---|---|---|---|
| S1 | Service catalogue | Profile → Services → Services tab → add a service | |
| S2 | Appointments | Appointments tab → book → complete | |
| S3 | service-revenue KPI | visible after completing an appointment | |
| S4 | appointment-utilisation KPI | visible | |
| S5 | No variants / no Vision | absent | |
| S6 | GST fields + report | present | |

### B7. General (Daily Needs Store)
| # | Test | Expected | P/F |
|---|---|---|---|
| GN1 | Plain POS + inventory | works; general categories | |
| GN2 | Loyalty + coupons | works | |
| GN3 | Common KPIs | the 46 common KPIs only (no vertical packs) | |
| GN4 | No variants / expiry / vision | absent | |
| GN5 | GST fields + report | present (non-grocery) | |

---

## C. Multi-store specific
| # | Test | Expected | P/F |
|---|---|---|---|
| M1 | Each store shows **its own** products, customers, sales, KPIs | No data bleed between stores | |
| M2 | Switching store updates the vertical UI live | e.g. grocery shows Vision, electronics doesn't | |
| M3 | POS after switch | Billing/stock show the switched store's catalog (no 403, no stale store) | |
| M4 | Store Comparison (if grouped by admin) | Profile → Store Comparison (only when admin links stores into a group) | |

---

## How to report
For each failed row: store + row id (e.g. "E2"), what you saw vs expected, screenshot,
and whether it's a **bug** (broken), **logic** (wrong result), or **UI** (looks off).
