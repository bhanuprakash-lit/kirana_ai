# Kirana AI — Mobile App

**LohiyaAI** · Smart business intelligence for South Indian kirana (retail) store owners.

---

## Overview

Kirana AI is a cross-platform Flutter mobile app that gives kirana store owners a complete digital command centre — POS billing, inventory management, distributor procurement, credit (udhaar) tracking, AI-powered insights, and WhatsApp intelligence, all backed by a FastAPI + PostgreSQL backend.

---

## Features

| Module | Capabilities |
|---|---|
| **Auth** | Phone OTP (Firebase) · Email/password · 30-day rolling sessions · FCM push |
| **Onboarding** | 5-step guided setup — account, business info, location, consent |
| **Dashboard** | AI recommendations strip · Today's sales · Store KPI overview |
| **POS** | Barcode scan · Cart · Loose items · Place orders · Transaction history |
| **Inventory** | Product grid by category · Add/edit products · Barcode lookup |
| **Procurement** | Supplier management · Purchase orders · Mark received |
| **Finance** | Udhaar (credit) tracking · Distributor payables · Monthly overview |
| **Profile** | Customer management · KPI subscriptions · Store settings · Configuration |
| **Support** | FAQ · Report issue · Help centre |

---

## Tech Stack

### Mobile (Flutter)
- **Flutter** `^3.x` — cross-platform (Android + iOS)
- **flutter_riverpod** `^3.3.1` — state management (Notifier API)
- **go_router** `^17.2.3` — declarative navigation
- **firebase_auth** — phone OTP + FCM push notifications
- **firebase_remote_config** — dynamic API base URL
- **flutter_secure_storage** — JWT token storage
- **mobile_scanner** — barcode scanning
- **geolocator** + Nominatim OSM — GPS + reverse geocoding
- **flutter_animate** + **google_fonts** — UI polish

### Backend (FastAPI)
- **FastAPI** + **SQLAlchemy** + **PostgreSQL** (`lit_db`)
- **79+ REST endpoints** across 5 modules: `kirana`, `pos`, `oltp`, `whatsapp`, `kpis`
- **ML stack**: XGBoost · Pandas · Scikit-Learn (demand forecasting, stockout risk, price optimisation)
- **AI**: Mistral AI for natural-language KPI queries and WhatsApp intelligence
- **Auth**: Custom Bearer token system + POS JWT (`/pos/token`)

---

## Project Structure

```
lib/
├── core/
│   ├── config/          # AppConfig (Remote Config), Firebase options
│   ├── services/        # ApiClient, ContactService
│   └── theme/           # BrandTheme, BrandColors
├── features/
│   ├── auth/            # Login (phone OTP + email), AuthRepository
│   ├── splash/          # Smart routing on app launch
│   ├── onboarding/      # 5-step registration flow
│   ├── dashboard/       # Overview tab, AI intelligence strip
│   ├── pos_inventory/   # POS, Inventory, Procurement tabs
│   ├── finance/         # Udhaar + distributor finance
│   ├── profile/         # Customer mgmt, KPIs, Store settings
│   └── support/         # FAQ, issue reporting, notifications
├── shared/
│   ├── models/          # Alert model
│   ├── providers/       # Alert provider
│   └── widgets/         # BrandTextField, PrimaryButton, NotificationBell
├── app_router.dart      # go_router route definitions
└── main.dart            # App entry point
```

---

## Getting Started

### Prerequisites
- Flutter `>=3.11.4`
- Dart `>=3.11.4`
- Android Studio / Xcode
- Firebase project (for phone auth + FCM)

### Setup

```bash
# Install dependencies
flutter pub get

# Run on device/emulator
flutter run
```

### Firebase Configuration
- Replace `lib/core/config/firebase_options.dart` with your own generated options (`flutterfire configure`)
- Enable **Phone Authentication** in Firebase Console
- Add SHA-1 / SHA-256 fingerprints for Android

### Backend
The backend is a separate FastAPI service. Point the app at it via **Firebase Remote Config** (`base_url` key) or the fallback in `AppConfig`.

---

## Environment

| Key | Description |
|---|---|
| `base_url` | Remote Config key — API base URL (e.g. `https://api.yourdomain.com`) |

---

## Built by

**LohiyaAI** — AI-powered tools for Indian retail.
