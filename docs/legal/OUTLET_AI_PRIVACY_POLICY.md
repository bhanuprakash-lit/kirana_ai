# Privacy Policy — Outlet AI

> **DRAFT — for internal/legal review.** This is the product-specific privacy
> policy for the **Outlet AI** mobile application, published by
> [COMPANY LEGAL NAME] ("LohiyaAI"). It is grounded in what the app actually
> does today. Replace every `[PLACEHOLDER]`, reconcile it with the company-wide
> policy, and have it reviewed by qualified counsel before publishing. Nothing
> here is legal advice.

**App:** Outlet AI
**Publisher:** [COMPANY LEGAL NAME] (trading as "LohiyaAI")
**Effective date:** [EFFECTIVE DATE]
**Last updated:** [LAST UPDATED DATE]

---

## 1. Introduction

Outlet AI is a mobile application that helps retail and "kirana" store owners run
their business — recording sales (POS), managing inventory, tracking customer
credit ("udhaar"), scanning invoices, taking voice and handwritten orders, and
viewing business insights. This policy explains what personal data the app
collects, why, who we share it with, and the choices and rights you have.

This policy is written primarily for [COUNTRY — e.g. India] under the **Digital
Personal Data Protection Act, 2023 (DPDP Act)** and the **Information Technology
Act, 2000**. For users outside India, we also seek to honour the **EU/UK GDPR**
and **CCPA/CPRA** (see Section 12). It should be read together with our
company-wide Privacy Policy ([COMPANY PRIVACY POLICY URL]) and the Outlet AI
Terms & Conditions ([OUTLET AI TERMS URL]).

## 2. Two important roles

- **About you (the store owner / account holder):** we act as the **data
  fiduciary / controller**. We decide how your account and usage data are
  handled, as described here.
- **About your customers (their names, phone numbers, and udhaar/credit
  details that you enter):** **you** are the controller of that data and we
  process it **on your behalf** as a processor. You are responsible for having a
  lawful basis and any required notice/consent to record your customers' details
  in the app. We provide tools (such as voice consent capture) to help, but the
  obligation is yours.

## 3. What we collect

### 3.1 Account & profile
- Phone number and one-time password (OTP) for sign-in (via **Firebase
  Authentication**).
- Store/business name, owner name, store address, and preferences such as
  language.
- Authentication tokens stored securely on your device.

### 3.2 Business data you create in the app
- Products, inventory, prices, stock levels, and low-stock data.
- Sales and point-of-sale (POS) transactions, bills, and receipts.
- Supplier details and payments.
- Subscription/plan and trial status.

### 3.3 Your customers' data (entered by you)
- Customer names and phone numbers.
- Credit ("udhaar") balances, due dates, and repayment history.
- Optional notes you attach to a customer or transaction.

### 3.4 Contacts (with your permission)
- With your permission, the app can **read your device contacts** to help you
  quickly add a customer to an udhaar entry, and can **add/update a contact**
  when you choose to save one. You can deny or revoke this permission in your
  device settings; the rest of the app continues to work.

### 3.5 Voice recordings
- **Voice orders / voice notes:** when you use voice features, the app records
  audio and sends it to **Google's Gemini AI** to convert speech into items and
  orders.
- **Udhaar voice-consent clips:** when you capture a customer's spoken consent
  for a credit entry, the app records a short audio clip. These clips are
  uploaded to and stored on **Microsoft Azure** (Blob Storage) as a record of
  consent, using a retry queue so the upload completes even on a poor
  connection. These clips may also be used to build and improve our own
  voice/speaker-recognition models that support this feature. [Confirm whether
  consent clips are retained for the life of the udhaar record or for a fixed
  [RETENTION PERIOD].]

### 3.6 Images
- **Invoice scans** and **shelf/Vision photos** captured with your **camera** or
  selected from your **photo library**. These images are processed by **Google's
  Gemini AI** to read items, totals, supplier details, and to recognise products
  on shelves. [Confirm whether original images are stored after processing, and
  for how long.]

### 3.7 Location (with your permission)
- With your permission, we use your device **location** (while the app is in
  use) to help verify store transactions and support delivery tracking. You can
  deny or revoke this permission at any time.

### 3.8 Bluetooth
- We use **Bluetooth** only to discover and connect to your thermal receipt
  printer so the app can print receipts. We do not use Bluetooth to collect data
  about you.

### 3.9 Diagnostics, device & push data
- **Crash and performance diagnostics** via **Firebase Crashlytics** and
  **Firebase Performance** (device model, OS/app version, performance traces,
  and crash logs).
- **Push notification token** via **Firebase Cloud Messaging (FCM)** to send you
  alerts (e.g. udhaar reminders, vision results, important notices).
- **Remote configuration** via **Firebase Remote Config** to enable/disable
  features and deliver important notices.
- General device/technical information such as IP address, identifiers, and
  app/OS version.

### 3.10 Payments
- Subscriptions are purchased through **Google Play Billing** or the **Apple App
  Store** (in-app purchase). Those stores process your payment; **we do not
  receive or store your full card or bank details** — we receive your
  subscription/transaction status.

## 4. Why we use your data

- To provide core features: POS, inventory, udhaar, invoice scanning, voice and
  handwriting orders, vision scans, receipts, and insights.
- To authenticate you and keep your account and data secure.
- To process subscriptions and manage trials.
- To send you service notifications and reminders you have enabled.
- To convert your voice and images into structured data using AI.
- To maintain a verifiable record of customer consent for credit entries.
- To diagnose crashes, improve reliability, and improve our features (including
  our AI models).
- To comply with law and enforce our Terms.

**Lawful bases (GDPR) / grounds (DPDP):** performance of our contract with you;
your consent (e.g. for permissions such as camera, microphone, contacts,
location, and for marketing); our legitimate interests (security, product
improvement); and legal obligations.

## 5. AI processing — what you should know

Outlet AI uses third-party AI to make features work:

- **Google Gemini** processes audio (voice orders), invoice images, handwriting,
  and shelf images to extract structured information. Data sent for AI
  processing is subject to Google's applicable terms and privacy commitments.
- **Microsoft Azure** stores udhaar voice-consent clips securely.

We aim to send only what is needed for the feature you requested, and we do not
use AI to make legally significant decisions about you by purely automated means
without human involvement.

## 6. Permissions we request (and why)

| Permission | Why we ask |
|---|---|
| **Camera** | Scan invoices and barcodes; capture shelf photos for Vision |
| **Photos / media** | Upload invoice or shelf images from your gallery |
| **Microphone** | Voice orders/notes and udhaar voice-consent capture |
| **Contacts** | Add a customer to an udhaar entry; save a customer as a contact |
| **Location (while in use)** | Verify store transactions and support delivery tracking |
| **Bluetooth** | Connect to your thermal receipt printer |
| **Notifications** | Send alerts and reminders you have enabled |

Each permission is optional and requested in context. You can deny or later
revoke any permission in your device settings; affected features will be
limited, but the rest of the app keeps working.

## 7. Who we share data with

We do **not sell** your data. We share it only with:

- **Google / Firebase / Google Cloud** — authentication, hosting, crash and
  performance diagnostics, push notifications, and Gemini AI processing.
- **Microsoft Azure** — secure storage of voice-consent clips.
- **Apple App Store / Google Play** — app distribution and in-app purchase
  processing.
- [BACKEND HOSTING PROVIDER — e.g. Google Cloud Run] — our backend that powers
  your account and data sync.
- **Authorities** where required by law.
- A **successor** in a merger, acquisition, or asset sale, subject to this
  policy.

## 8. Where your data is processed

Your data is processed on our cloud infrastructure and by the providers above,
which may operate servers in [REGION(S) — e.g. India / other countries]. Where
data is transferred across borders, we use safeguards appropriate to the law
(see the company-wide policy, Section 9).

## 9. How long we keep it

- **Account and business data** — while your account is active and for
  [RETENTION PERIOD] after closure, unless a longer period is required by law.
- **Udhaar / customer data** — retained while you keep the record; deleted or
  anonymised on your request or [RETENTION PERIOD] after account closure.
- **Voice-consent clips** — [RETENTION PERIOD / for the life of the related
  credit record].
- **Invoice / shelf images** — [RETENTION PERIOD / deleted after processing].
- **Diagnostics and logs** — [RETENTION PERIOD].

You can ask us to delete your account and associated data at any time
(Section 11).

## 10. How we protect your data

We use encryption in transit, secure authentication tokens kept in your device's
secure storage, access controls on our backend, and reputable cloud providers.
No method is perfectly secure, but we work to protect your data and to notify you
and the relevant authority of a breach where the law requires.

## 11. Your choices and rights

- **Manage permissions** in your device settings at any time.
- **Access, correct, or delete** your data, and **withdraw consent**, by
  contacting us or using in-app options where available.
- **Delete your account:** [describe in-app path or] email [PRIVACY EMAIL] and we
  will delete your account and associated personal data, subject to legal
  retention requirements. (A public account-deletion route is required by the
  app stores — link: [ACCOUNT DELETION URL].)
- **Notifications:** turn off push notifications in your device settings.

Regional rights (GDPR portability/restriction/objection; CCPA non-discrimination
and opt-out of "sale"/"sharing" — note we do not sell data; DPDP nomination) are
described in the company-wide policy, Section 11, and apply here.

## 12. Children

Outlet AI is for business owners and is **not intended for anyone under 18**. We
do not knowingly collect data from children.

## 13. Changes

We may update this policy. We will update the "Last updated" date and, for
material changes, notify you in the app or by other reasonable means.

## 14. Contact & Grievance Officer

- **Publisher:** [COMPANY LEGAL NAME], [REGISTERED ADDRESS]
- **Privacy contact / support:** [PRIVACY EMAIL] / [SUPPORT EMAIL]
- **Grievance Officer (India — DPDP Act / IT Rules):** [GRIEVANCE OFFICER NAME],
  [DESIGNATION], [GRIEVANCE OFFICER EMAIL]
- [DPO, if appointed: [DPO NAME / EMAIL]]

You may also complain to the **Data Protection Board of India** or your local
data protection authority.
