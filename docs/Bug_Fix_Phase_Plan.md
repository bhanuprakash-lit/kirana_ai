# Phase-wise fix plan — user bugs (PAI-1…19) + outstanding vertical gaps

> **Status 2026-07-23 — P0, P1 and P2 are complete and verified locally**
> (`flutter analyze` clean · 95/95 app tests · 200 backend tests · admin panel builds).
> Not yet committed, and not yet promoted to UAT.
>
> | Phase | Items | State |
> |---|---|---|
> | P0 | PAI-1 switcher sheet · PAI-4 privacy URL · friendly WhatsApp copy | ✅ |
> | P1 | PAI-11/12 quota per store · PAI-14 notification paths · PAI-5 OCR→stock · PAI-16 coupon offers · PAI-17 coupon edit · PAI-19 admin marketing column | ✅ |
> | P2 | PAI-6/13 supplier grouping · PAI-10 KPI strip · PAI-18 estimate purpose + grocery gate · G1 closed · G2 services/staff l10n · G6 verified non-issue | ✅ |
> | — | **PAI-7 QR share** — now sends the QR **image** (was a raw 64-char hash) | ✅ |
> | — | Pharmacy/medical sweep (owner request) | ✅ |
> | P3 | Taxonomy: 4 new verticals · mono_brand follow-up · picker cleanup · 3 stores migrated | ✅ |
> | P4 | PAI-15 via option C — authenticated model download | ✅ code complete, **needs one ops step** |
> | P5 | Feature depth | backlog |
>
> ### P4 cutover — two steps, in this order
>
> The app still ships the bundled `.tflite`, so nothing breaks while the server
> has nothing published. To finish the migration:
>
> 1. **Publish the model** (once, with Azure creds set):
>    ```
>    python scripts/upload_vision_model.py --version 2026.07.1 \
>      --weights ../FlutterProjects/kirana_ai/assets/models/counter_model.tflite \
>      --labels  ../FlutterProjects/kirana_ai/assets/models/counter_labels.txt
>    ```
>    The manifest is written **last**, so clients never see a version pointing at
>    a blob that hasn't finished uploading.
> 2. **Drop the asset from the app** — remove `assets/models/` from `pubspec.yaml`
>    and set `CounterModel.hasBundledAsset = false`. That's when the APK loses
>    38 MB. Do it only after step 1 is verified on a real device.
>
> Needs `VISION_MODEL_CONTAINER` (defaults to `vision-models`) and reuses the
> existing `AZURE_STORAGE_CONNECTION_STRING`.
>
> **One deliberate deviation from the option-C pitch:** the cached model is *not*
> encrypted at rest. TFLite loads from a file path, so we'd have to decrypt to a
> plaintext temp file on every launch — the plaintext lands on disk anyway, and
> we'd pay for it in startup time. App-private storage already keeps it from
> other apps on a non-rooted device; a rooted device defeats either approach.
> The real wins (not in the APK, account required, attributable, revocable,
> smaller download) are all intact.
>
> **Owner still holds:** the WhatsApp access token (PAI-8/9 stay broken until it's
> replaced — the app now fails gracefully instead of showing `API 401`).
>
> **Notes from the build:**
> - **G6 needed no change.** The ML card copy is already vertical-neutral
>   ("SKUs critical", "Top sellers"), and expiry alerts self-gate — they only
>   fire when a product carries an expiry date, which non-expiry verticals never
>   set. Flagging it as a gap was over-cautious.
> - **New dependency:** `share_plus` ^12.0.2, solely for sharing the QR image.
> - **One schema change:** `ai_usage` gains `store_id` and re-keys its unique
>   constraint. Verified idempotent against `lit_db_prod`.

**Date:** 2026-07-22 · **Rev 2** (incorporates owner decisions)
**Inputs:** live user/tester feedback (PAI list), security-engineer findings, `Vertical_Feature_Matrix.md` gaps (G1–G8), production store census from `lit_db_prod`.

**Environment model:** dev env is gone. **This laptop *is* dev** — everything below is built and tested end-to-end locally against `lit_db_prod`, and only promoted to **UAT** once it's verified here. No fix in this plan is "done" until it has run on the laptop.

**Estimates below are my build time, not the team's.** Unit = **block** ≈ one focused working stretch that ends with `flutter analyze` clean + backend tests passing.

---

## 0. Store census — this drives priority

From `kirana_oltp.store` (55 stores):

| Vertical | Stores | Share |
|---|---:|---:|
| **grocery** | 42 | 76% |
| apparel (incl. boutique, mono_brand, sports) | 6 | 11% |
| general (fancy_gift, stationery) | 3 | 5% |
| electronics | 2 | 4% |
| optical | 1 | 2% |
| services | 1 | 2% |

**Consequence:** a bug on a shared surface (POS, khata, WhatsApp, notifications, store switcher) hits ~55 stores; a services-only polish item hits 1. All deep per-vertical work from the feature matrix therefore ranks **below** every PAI item.

**Data cleanup done:** store 28 `Sai_Kirana` carried `store_type='kirana12'` (a typo, not a junk store — it had 65 orders, 33 inventory rows, 6 customers). Corrected in place to `kirana`; all history retained. ✅

---

## 1. Owner decisions folded in (rev 2)

| Topic | Decision |
|---|---|
| **PAI-2 rationale** | It's a **label collision**, not a taxonomy problem: the picker shows both *"Kirana / General Stores"* and *"General Store"*. Keep the kirana one, drop the duplicate. Same for the other three. |
| **PAI-1 fix shape** | Make the switcher a proper **scrollable bottom sheet**, not the default dropdown. |
| **PAI-3 mono_brand** | A mono-brand store can be **apparel, electronics, cosmetics or anything**. So mono_brand must **not** be a fixed vertical — see §3.2. |
| **WhatsApp token** | Owner is handling it. Out of my scope; PAI-8/9/(7) stay blocked on it. |
| **Backend deploy** | Already deployed and running on the new image — no verification needed. **Verified instead:** all feature code is present in both working trees (below). |
| **Credential rotation** | Not now. Dev-only credentials, private repos, no public deployment. Dropped from the plan. |

### Working-tree verification (replaces the old "deploy check")
Nothing was left behind on a branch:

- **Backend `master`** — clean apart from unrelated tutorial-funnel work in progress. V2 service-sale code present (`is_service` ×7 in `repositories/base.py`); bill-breakdown columns present (`coupon_discount` / `redeem_value` / `manual_discount` in `pos/models.py`).
- **App `master`** — clean. `lib/core/vertical/` has all four files (config, provider, copy, nav_preset); `posServiceChip` in ARB; `_BillBreakdownCard` in order details; memberships in `services_screen.dart`.

---

## 2. Verdict on each reported item

Legend: **✔ correct as reported** · **↺ real bug, proposed fix aimed wrong** · **⚠ needs a product decision**

| # | Verdict | Finding |
|---|---|---|
| PAI-1 | **↺** | Real, confirmed: `_StoreSwitcherSheet` builds an unbounded `Column`; past ~4 stores it overflows and "Add a store" is unreachable. Not a side-scroll — **scrollable bottom sheet with the Add button pinned outside the scroll area**. |
| PAI-2 | **✔** | Duplicate/confusing labels. Remove from the **picker only**; the 22 existing stores on those codes (`general` ×18, `provision` ×2, `fruits_vegetables` ×1, `other` ×1) keep resolving — they already map to grocery, so nothing changes for them. |
| PAI-3 | **⚠** | Cheap in code (config is data-driven), but needs the flag table in §3.1 signed off. mono_brand is a different shape of problem — §3.2. |
| PAI-4 | **✔** | Confirmed: `consent_step.dart:13` → `/outlet/privacy` (404); `subscription_screen.dart:16` → `/outlet/privacy.html` (works). One-line fix. |
| PAI-5 | **✔** | OCR extracts invoice lines but never matches them to catalog products. Fuzzy-match + **human confirm step** — never auto-write stock on a fuzzy match. |
| PAI-6 | **✔** | Group by supplier, collapse repeats into an expandable row with remaining payment; "Mark as received" stays on the line item inside. |
| PAI-7 | **✔** | Verify share-intent vs API path; if it sends through the Cloud API it dies on the same 401 as 8/9. |
| PAI-8 | **✔** | **Expired credential, not a code bug.** `WHATSAPP_ACCESS_TOKEN` invalid in the deployed env. Owner handling. Still worth doing on my side: **stop showing raw `WhatsApp API 401` to shopkeepers**. |
| PAI-9 | **✔** | **Same single root cause as PAI-8.** |
| PAI-10 | **✔** | Horizontal-scroll the vertical-KPI section on home. |
| PAI-11 | **↺** | Confirmed in `ai/routes.py` + `ai_prefs.py`: quota is keyed on **`user_id` alone**. Not "same across verticals" — **same across every store one owner has**. Fix: key `ai_usage` on `(user_id, store_id, feature, usage_date)`; `store_id` is already in the token. |
| PAI-12 | **↺** | Identical cause, identical fix — **one change, both tickets**. |
| PAI-13 | **✔** | Same widget as PAI-6; build once, use twice. |
| PAI-14 | **✔** | Business Alerts aren't mapped to routes. Since V1 all tabs resolve via `navPresetFor`, so it's adding the missing cases — but must be tested per vertical, because tab positions differ. |
| PAI-15 | **↺** | Finding is correct (38.6 MB `counter_model.tflite`, plainly unzippable). **AES on the asset doesn't achieve the stated goal** — see §4. |
| PAI-16 | **↺** | Coupon entry **already exists** at checkout (`order_dialog.dart`: code field, validate, apply). What's missing is *offering* the customer's applicable coupons. Chip row, not a feature build. |
| PAI-17 | **✔** | Create/delete only today. Needs PATCH + edit sheet; **editing a redeemed coupon must not rewrite history**. |
| PAI-18 | **✔** | Copy + empty-state explainer, paired with **gating estimates off grocery** — 76% of stores see a feature they'll never use. |
| PAI-19 | **✔** | `allow_social_marketing` already in store config. Admin-panel-only: endpoint + column/filter. |

---

## 3. Taxonomy work (P3) in detail

### 3.1 Three new verticals — proposed flags *(needs sign-off)*

| New vertical | expiry | loose | variants | serial | warranty | appts | Rationale |
|---|:--:|:--:|:--:|:--:|:--:|:--:|---|
| **bakery** | ✅ | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | Enable **job cards** for custom-cake pre-orders (hidden today because bakery reads as grocery); own ML profile — production, not procure-and-restock |
| **boutique** | ⬜ | ⬜ | ✅ | ⬜ | ⬜ | ⬜ | Apparel + alteration job cards promoted, estimates emphasised |
| **sports_fitness** | ⬜ | ⬜ | ✅ | ⬜ | ⬜ | ⬜ | Same behaviour as apparel today; a separate code lets equipment serials be added later without touching clothing stores |

Only **3 live stores** move (1 bakery, 1 boutique, 1 sports).

### 3.2 mono_brand — a sub-choice, not a vertical

A mono-brand store can sell clothing, phones, cosmetics, anything. Hard-coding it to one vertical is wrong in every direction. **The existing two-level model already solves this** — granular `store_type` for the label, coarse `vertical_code` for behaviour:

> Owner picks **"Mono Brand Store"** → one follow-up question, *"What do you mainly sell?"* → **Clothing → apparel · Footwear → footwear · Mobile & electronics → electronics · Cosmetics & beauty → cosmetics · Other → general**.
>
> `store_type` stays `mono_brand` (so we always know it's a single-brand outlet); `vertical_code` carries behaviour.

**Cosmetics is worth adding as a real vertical while we're here** — it needs `expiry` ✅ (cosmetics do expire) and `variants` ✅ (shade/size — `shade` is already an example attribute in the F1 design), which is a combination **no existing vertical provides**. A cosmetics mono-brand mapped to apparel today gets neither.

The same follow-up pattern would fix `other`/`general` cleanly if you ever want it back.

---

## 4. PAI-15 explained properly

**The finding:** anyone can rename the APK to `.zip`, unzip it, and walk away with `assets/models/counter_model.tflite` (38.6 MB) — your trained YOLO counter model.

**Why the proposed fix doesn't work.** "AES-encrypt the model" means shipping the model encrypted *and* shipping the key that decrypts it, because the app has to decrypt it at runtime with no server involved. The key is in the same APK. So the attacker's job changes from *"unzip a file"* to *"find the key in the binary, or let the app decrypt and dump it from memory"* — an afternoon with Frida. **It's obfuscation, not encryption.** That may still be worth doing if the goal is "stop casual copying", but it should be called what it is.

**Three real options:**

| Option | What it actually buys | My build time |
|---|---|---|
| **A. AES the asset** (as proposed) | Stops casual unzip. Stops nobody with a debugger. Model still ships in the APK. | ~1 block |
| **B. Server-side inference** | Genuine protection — the model never leaves your server. But it **kills offline counter-scan and adds network latency to a live camera feature**, plus GPU cost. | ~4–5 blocks + infra |
| **C. Authenticated download + encrypted-at-rest cache** ← **recommended** | Model is **not in the APK at all**. First run: app authenticates, gets a short-lived signed URL, downloads the model, caches it encrypted. An attacker now needs a **valid account**, and every download is **attributable to a user**. Offline use still works after first fetch. **Bonus: 38 MB off your download size.** | ~2 blocks |

**C beats A at similar cost** — same "raises the bar" benefit, plus attribution, plus revocation (a leaked account can be cut off), plus a materially smaller app. Only **B** makes the model truly unobtainable, and it costs the offline experience that makes counter-scan usable at a busy counter.

---

## 5. The phases — with my build time

Every phase ends with: `flutter analyze` clean, backend tests green, and **manual end-to-end on this laptop** against `lit_db_prod` before anything goes to UAT.

### P0 — Hotfix · **~1 block**
1. **PAI-1** — switcher becomes a scrollable bottom sheet, Add-store pinned.
2. **PAI-4** — privacy URL constant.
3. **Friendly WhatsApp failure copy** — no raw `API 401` in front of a shopkeeper (works regardless of when the token lands).
- *Not mine:* WhatsApp token (owner). *Already done:* backend deploy, store-28 cleanup.

### P1 — Correctness & data integrity · **~3–4 blocks**
4. **PAI-11 + PAI-12** — re-key `ai_usage` to `(user_id, store_id, …)`, guarded migration + repo + `/ai/status` + FE refresh. *(1 block)*
5. **PAI-14** — Business Alerts → routes, tested per vertical preset. *(0.5)*
6. **PAI-5** — OCR→catalog fuzzy match + confirm-before-commit UI. *(1–1.5 — the biggest item in P1)*
7. **PAI-16 + PAI-17** — offer applicable coupons at checkout; coupon edit guarding redeemed ones. *(1)*
8. **PAI-19** — admin marketing-toggle view. *(0.5)*

### P2 — UI/UX polish · **~2–3 blocks**
9. **PAI-6 + PAI-13** — one shared supplier-grouping widget, two screens. *(1)*
10. **PAI-10** — horizontal KPI row. *(0.25)*
11. **PAI-18** — estimate explainer + gate estimates off grocery. *(0.5)*
12. **Carry-overs:** module l10n (G2), grocery-worded ML cards (G6), written decision on `copy_pack` (G1). *(1)*

### P3 — Taxonomy · **~2 blocks** *(blocked on §3.1 + §3.2 sign-off)*
13. Seed bakery / boutique / sports_fitness configs + nav presets + KPI tags; migrate the 3 stores. *(1)*
14. mono_brand follow-up question at onboarding + add-store; optional **cosmetics** vertical. *(0.5)*
15. Remove the 4 duplicate picker options, keep old codes resolvable. *(0.25)*

### P4 — Model protection · **~2 blocks** *(blocked on choosing A/B/C)*
16. PAI-15 via option C. Credential rotation dropped per owner decision.

### P5 — Feature depth · backlog, census order
Grocery-affecting first, then apparel, then the tail: warranty-expiry alerts + serial-first search (2 stores), size×colour matrix (6), structured Rx (1), attach-rate/outfit KPIs, per-store catalog scoping (G7), M10 AI.

---

## 6. Total and sequence

**P0 → P3 ≈ 8–10 blocks**, plus 2 for P4. Suggested order:

```
P0  (1)      →  laptop verify  →  UAT promote
P1  (3–4)    →  laptop verify  →  UAT promote
P2  (2–3)    →  laptop verify  →  UAT promote
P3  (2)      ← needs §3.1 / §3.2 sign-off first
P4  (2)      ← needs A/B/C decision first
P5  backlog
```

P0 and P1 are unblocked and can start immediately. P3 and P4 are the only things waiting on you.

---

## 7. Not recommended

- **Gift-wrap / bakery-production / stationery-season modules now** — 3 general + 1 bakery store. This is the exact pattern `Incomplete_Features_Audit.md` was written about: features that demo well and die on first real use.
- **Removing the 4 store types from the resolver** (as opposed to the picker) — 22 live stores depend on those codes.
