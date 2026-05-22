# Kirana AI — Mobile App

**LohiyaAI** · Smart business intelligence for South Indian kirana (retail) store owners.

---

## Overview

Kirana AI is a cross-platform Flutter mobile app that gives kirana store owners
a complete digital command centre — POS billing, inventory management,
distributor procurement, credit (udhaar) tracking, AI-powered insights, and
WhatsApp intelligence, all backed by a FastAPI + PostgreSQL backend.

---

## Documentation

All documentation lives under [`docs/`](docs/):

| Document | Audience | What it covers |
| --- | --- | --- |
| [`docs/USER_MANUAL.md`](docs/USER_MANUAL.md) | Store owners | Every screen, every button, what tapping it does. Start here if you're using the app. |
| [`docs/FEATURES.md`](docs/FEATURES.md) | Anyone | A shorter, narrative walkthrough of each feature. |
| [`docs/DEVELOPER_GUIDE.md`](docs/DEVELOPER_GUIDE.md) | Engineers | Project layout, naming conventions, state management, the complete API client surface and consumed endpoints, theming, build/run, gotchas. |

---

## Features

| Module | Capabilities |
|---|---|
| **Auth** | Phone OTP (Firebase) · Email/password · 30-day rolling sessions · FCM push |
| **Onboarding** | 5-step guided setup — account, business info, location, consent |
| **Dashboard** | AI recommendations · Today's sales · Store KPI overview · Pro alerts strip |
| **POS** | Barcode scan · Cart · Loose items · Place orders · Voice & handwriting AI entry (Pro) |
| **Inventory** | Product grid by category · Add/edit products · Barcode lookup · Pending optimistic updates |
| **Procurement** *(Pro)* | Supplier management · Purchase orders · Mark received · Invoice OCR |
| **Finance** | Udhaar (customer credit) · Distributor payables · Monthly overview |
| **Customers** | CRUD · Search · Contact sync · Segment chips · WhatsApp re-engagement |
| **Area Associations** | Apartment/hostel/colony tracking · Customer heatmap |
| **Baskets & Campaigns** | Saved bundles · AI-suggested daily basket campaigns |
| **Referrals** *(Pro)* | QR-based referral campaigns with discount/reward tracking |
| **KPI Subscriptions** | 24 production KPIs with tier-based access |
| **Subscription** | Trial → Basic ₹200/mo → Pro ₹500/mo via Google Play Billing |
| **Support** | FAQ · Report issue · Email support |

---

## Tech Stack

### Mobile (Flutter)
- **Flutter** SDK `^3.11.4` — cross-platform (Android + iOS)
- **flutter_riverpod** `^3.3.1` — state management (Notifier API only)
- **go_router** `^17.2.3` — declarative navigation
- **firebase_auth** — phone OTP
- **firebase_messaging** + **flutter_local_notifications** — push notifications
- **firebase_remote_config** — dynamic API base URL, kill switch, trial duration
- **firebase_crashlytics** + **firebase_performance** — runtime monitoring
- **flutter_secure_storage** — JWT token storage
- **mobile_scanner** — barcode + QR scanning
- **in_app_purchase** — Google Play Billing
- **geolocator** + Nominatim OSM — GPS + reverse geocoding

The full and authoritative dependency list lives in [`pubspec.yaml`](pubspec.yaml).

### Backend (FastAPI)

Lives in a separate repo (`kirana-master-backend`). FastAPI + SQLAlchemy +
PostgreSQL. ML stack: XGBoost / Pandas / Scikit-Learn. AI: Mistral for
natural-language KPI queries and WhatsApp.

---

## Project Layout

```
lib/
├── core/           Cross-cutting infrastructure (api_client, config, theme, services)
├── shared/         Reusable widgets, models, providers
└── features/       One folder per business feature
    ├── auth/
    ├── splash/
    ├── onboarding/
    ├── dashboard/
    ├── pos_inventory/
    ├── finance/
    ├── profile/
    ├── associations/
    ├── baskets/
    ├── campaigns/
    ├── referral/
    ├── subscription/
    └── support/

test/               Unit + widget + provider tests
docs/               Project documentation
```

Each feature folder is internally organised into `models/`, `providers/`,
`views/`, and (optionally) `repositories/`, `services/`, `widgets/`. See
[`docs/DEVELOPER_GUIDE.md`](docs/DEVELOPER_GUIDE.md) for the full breakdown.

---

## Getting Started

### Prerequisites

- Flutter SDK `>= 3.11.4`
- Android Studio or Xcode
- A Firebase project (Phone Auth + FCM + Remote Config enabled)

### Setup

```bash
flutter pub get
flutterfire configure          # regenerates lib/core/config/firebase_options.dart
flutter run
```

### Configuring the backend URL

The app reads its API base URL from Firebase Remote Config (`backend_url`
key). When Remote Config is unreachable it falls back to a platform-appropriate
default defined in [`lib/core/config/app_config.dart`](lib/core/config/app_config.dart).

Other Remote Config keys: `trial_days`, `app_blocked`, `blocked_reason`,
`blocked_store_ids`.

---

## Testing

```bash
flutter analyze        # static analysis
flutter test           # all unit, provider, and widget tests
```

The test suite lives in [`test/`](test/) and currently has **65 tests** across:

- Model `fromJson` factories (`AppUser`, `PosProduct`, `StoreInfo`, `FinanceStats`, etc.)
- Pure-function helpers (`PosState` cart maths, referral discount, `AppConfig` URL sanitize)
- Provider behaviour (`FinanceNotifier` against a `FakeApiClient`)
- Shared widgets (`PrimaryButton`, `BrandTextField`)

See [`test/helpers/fake_api_client.dart`](test/helpers/fake_api_client.dart) for
the reusable `ApiClient` test double used by provider tests.

---

## Continuous Integration

Two equivalent pipelines are configured — pick whichever your team uses:

| Provider | Config file | What it runs |
| --- | --- | --- |
| GitHub Actions | [`.github/workflows/ci.yml`](.github/workflows/ci.yml) | `dart format` check (strict), `flutter analyze`, `flutter test --coverage`, debug APK build on `master` push |
| Azure DevOps | [`azure-pipelines.yml`](azure-pipelines.yml) | Same stages, runs on Microsoft-hosted Ubuntu agents |

Both gate every push and PR. The format check is strict — run `dart format .`
locally before committing.

---

## Contributing

1. Branch off `master`.
2. Make changes following the conventions in
   [`docs/DEVELOPER_GUIDE.md`](docs/DEVELOPER_GUIDE.md) (file layout, naming,
   Riverpod patterns).
3. Run locally:
   ```bash
   dart format .
   flutter analyze
   flutter test
   ```
4. Open a pull request — CI will run the same gates.

---

## Built by

**LohiyaAI** — AI-powered tools for Indian retail.
