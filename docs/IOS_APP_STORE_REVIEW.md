# iOS App Store Review — Rejection Fixes (v1.0 build 6)

First submission was **rejected** on 2026-07-16 (Submission ID
`55b86fba-2f1f-41e3-b27a-996ae34a854a`). All four citations trace back to the
in-app-purchase layer having been built for **Google Play only**, plus missing
legal links. This doc records the root cause, the code fixes made, and the
**App Store Connect steps that only the account holder can do**.

## Apple's four citations → root cause

| Guideline | What Apple said | Root cause |
|-----------|-----------------|------------|
| 2.1(b) App Completeness | IAP products not submitted for review | The subscription products never existed in App Store Connect |
| 2.1(b) App Completeness | "could not start… Product not found in Play Store" | StoreKit query returned empty → app showed a Play Store error |
| 2.3.10 Accurate Metadata | Remove Google Play references | User-facing error strings said "Play Store" / "Play Console" |
| 3.1.2(c) Subscriptions | Missing Terms of Use + Privacy links | No legal links in the purchase flow |

## Code changes (done — committed to this repo)

1. **iOS uses only the two flat products.** `productIdFor()` in
   `lib/features/subscription/services/iap_service.dart` no longer mints
   segment-specific ids on iOS (`defaultTargetPlatform == iOS` guard). Segment
   pricing stays Android-only. iOS uses its own two flat product ids — which
   MUST match the (immutable) App Store Connect Product IDs exactly:
   - `outletaibasic`  → Basic  (App Store Connect: "Basic")
   - `outletaipremium` → Pro   (App Store Connect: "Premium")

   (Android/Play Console keeps `kirana_ai_basic_monthly` / `kirana_ai_pro_monthly`.)
2. **Removed user-visible Google Play references** in
   `lib/features/subscription/providers/iap_provider.dart` (error strings are now
   store-neutral: "In-app purchases are not available on this device." /
   "This subscription is not available right now.").
3. **Added Terms of Use + Privacy Policy links + an auto-renewal disclosure** to
   the purchase page (`subscription_screen.dart`, `_LegalFooter`). Links:
   - Terms: https://lohiyaai.com/outlet/terms-and-conditions.html
   - Privacy: https://lohiyaai.com/outlet/privacy.html

   > These footer strings are hardcoded English (not yet localized). Localize via
   > the ARBs before a wider non-English launch if desired.

## App Store Connect steps (ONLY the account holder can do these)

- [x] **Business → Paid Apps Agreement**: DONE — verified Active 2026-07-18
      (valid 29 Jun 2026 – 29 Jun 2027; bank account + W-8BEN-E tax forms also
      Active). No action needed.
- [x] **Create 2 auto-renewable subscriptions** — DONE (group
      `outletai-subscriptions`, ID 22203447): Basic (`outletaibasic`) and
      Premium (`outletaipremium`), 1 month each. The app was updated to query
      these exact ids. Still ensure each has price (Basic ₹200 / Premium ₹500)
      + a **review screenshot** + at least one English localization before
      submitting.
- [ ] **App metadata**: set the **Privacy Policy URL** field to the privacy link
      above, and add the **Terms of Use (EULA)** — either link the standard Apple
      EULA in the App Description or paste a custom EULA in the EULA field.
- [ ] **Remove any "Google Play" wording** from the App Store description /
      promotional text / screenshots.
- [ ] **Submit the IAP products together with the new binary** (they must be in
      the same submission).
- [ ] In **App Review Information → Notes**, mention the subscription is
      auto-renewable and where the Terms/Privacy links live in-app.
- [ ] Reply to the rejection message with a short screen recording showing the
      purchase flow + the visible Terms/Privacy links.

## Post-launch: iOS Phone Auth "Send OTP" crash

**Symptom:** on a real iPhone, entering a phone number and tapping **Send OTP**
crashes the app instantly. Username/password login works fine.

**Root cause:** iOS Firebase Phone Auth verifies via APNs silent push; if that
fails it falls back to a reCAPTCHA web flow that needs a `REVERSED_CLIENT_ID`
URL scheme. This project has **no iOS OAuth client** (the plist has only
`ANDROID_CLIENT_ID`, no `REVERSED_CLIENT_ID`) — so reCAPTCHA can't work at all.
That's fine *as long as APNs silent push succeeds*, but on the live build it
didn't:
- Firebase had a **Development APNs auth key only — no production key**. The App
  Store build uses the **production** APNs environment, so Firebase couldn't
  deliver the silent verification push.
- `Runner.entitlements` had `aps-environment = development` (wrong for an App
  Store build).
- `FirebaseAppDelegateProxyEnabled = NO` + `AppDelegate` didn't forward APNs/URL
  callbacks to `FirebaseAuth`.
→ Send OTP → production silent push never arrives → reCAPTCHA fallback → no URL
scheme → **crash.**

**Code fixes (done):**
- `ios/Runner/AppDelegate.swift` forwards `setAPNSToken` /
  `canHandleNotification` / `canHandle(url)` to `FirebaseAuth` (needed because
  app-delegate swizzling is disabled).
- `ios/Runner/Runner.entitlements` → `aps-environment = production`.

**Console step (you) — required:**
- [ ] Firebase Console → Cloud Messaging → **upload the `.p8` to the "Production
      APNs auth key" slot** (an auth key is universal — reuse the same file as
      the Development key, Key ID `3MXRWJQB5Y`, Team `B8AYZML67R`).
- [ ] Rebuild + test Send OTP on a real device (via TestFlight, which uses the
      production APNs environment).

> Note: chasing `REVERSED_CLIENT_ID` is a dead end here (no iOS OAuth client) and
> unnecessary once APNs works. The App Store ID (`6786605527`, numbers only) is
> a different thing used only by the auto-updater.

## Crashlytics: missing dSYM (1.0.0 builds 5 & 7)

Uploaded manually via the Firebase `upload-symbols` tool from the local archives
(`~/Library/Developer/Xcode/Archives/…/dSYMs`). Both builds' symbols submitted
(9 dSYMs each, arm64). **Permanent fix pending:** add a Crashlytics run-script
build phase to the Runner target so future builds auto-upload dSYMs (see below).

## Backend (separate repo: kirana-master-backend) — FIXED

Previously `POST /kirana/payment/verify-iap` only knew Google Play: it sent the
`purchase_token` to Google's `androidpublisher` API. An iOS receipt sent there
would fail once Play credentials went live, breaking every iOS purchase
("Payment succeeded but activation failed").

**Now platform-aware** (`kirana/routers/finance.py`):
- The app sends a `platform` field (`ios`/`android`) — added to
  `iap_provider._onPurchase`.
- `android` → existing Google Play Developer API check (unchanged).
- `ios` → new `_verify_apple_receipt()` — Apple `verifyReceipt`, tries
  production then falls back to sandbox on status 21007 (handles App Review's
  sandbox purchases AND live purchases). Verified in isolation: prod-valid,
  sandbox-fallback, and invalid-receipt (→ 402) branches all pass.
- Legacy clients that don't send `platform` default to `android` (unchanged
  behaviour).

**Action for you:** set `APPLE_IAP_SHARED_SECRET` in the backend `.env`
(App Store Connect → your app → Subscriptions → App-Specific Shared Secret).
While it's empty the iOS receipt is *trusted* (fine for review/testing) — set it
before relying on verification in production. Full pytest suite needs the
`kirana-ml` conda env (not on the current Mac); run it there before deploy.
