# Vision AI → Kirana AI Integration Tracker

Living reference for folding the **vision-ai** project into the production app + backend.
If a session hits limits or a task breaks, **resume from here**. Keep statuses current.

- **Last updated:** 2026-06-14
- **Source project:** `C:\Users\Bhanuprakash\Documents\vision-ai` (git: no commits, all untracked)
- **Target app (Flutter):** `C:\Users\Bhanuprakash\Documents\FlutterProjects\kirana_ai`
- **Target backend (FastAPI):** `C:\Users\Bhanuprakash\Documents\kirana-master-backend`
- **Deploy rule:** App points at a **locally running server**. **DO NOT deploy** to Azure without explicit permission.

---

## Goal

Two owner-facing features from vision-ai, integrated natively:
1. **Shelf inventory** — owner shoots morning + evening shelf photos → we detect products → "what sold" via morning−evening delta → push notification → results tab. (Gemini-powered, server-side.)
2. **Counter camera** — phone camera at billing counter → realtime detection → live sales → later feeds POS cart / baskets / price guesses. (On-device, later.)

## Product decisions (confirmed with user 2026-06-14)
- **Placement:** new **4th dashboard tab "Vision"** (beside Overview / Finance / POS).
- **Gating:** **Pro-only** (reuse subscription engine `_ProGateTab` pattern, like Procurement).
- **Counter tech:** **on-device TFLite** later (export trained YOLO); not a backend round-trip.
- **Backend ready?** User says deployed/healthy. Gemini shelf path is portable now; local YOLO stays out.

---

## Key architectural findings (grounded in code)

- ✅ **Backend already has a reusable Gemini vision client** — `ai/routes.py`:
  `get_gemini_client()` (warm-TLS httpx, http2), `_call_gemini(model, parts, api_key, request)`,
  `_gemini_api_key(request)`. Already used for image vision (handwrite/invoice) via
  `{"inline_data": {"mime_type", "data": <b64>}}` parts on `gemini-2.5-flash`, JSON mode, temp 0.
  **→ The shelf analyzer REUSES this. Do NOT add `google.genai` SDK.**
  It also has per-user daily limits + credits (`repo.check_and_record_ai_use`, `get_ai_status`).
- ✅ **Schema bootstrap pattern** — `kirana/repository.py::KiranaRepository._ensure_schema`
  holds `CREATE TABLE IF NOT EXISTS kirana_oltp.*` blocks (basket, customer_product_price,
  ai_usage, …). Add `vision_session` + `vision_item` there; mirror in
  `db_generation/ensure_full_schema.py`. Runs once per worker at boot (main.py lifespan).
- ✅ **Router registration** — `main.py::create_app()` includes routers; lifespan attaches
  `app.state.engine` / `app.state.kirana_service` / settings. Vision router mirrors `ai/routes`.
- ✅ **Catalog already in Postgres** — `kirana_oltp.product` (11,182 `KAI-{blinkitId}` rows) IS
  the same blinkit catalog vision-ai matched against (`catalog.parquet`, 9k). So match Gemini
  names → `kirana_oltp.product` directly → get **`product_id`** (the integration glue) without
  shipping the parquet or torch.
- ⚠️ **vision-ai matcher is heavy** — `src/recognize/text_matcher.py` uses
  `sentence-transformers/all-MiniLM-L6-v2` + `torch` + cached embedding index. **Not ported.**
  Default replacement: in-memory `rapidfuzz` token_set_ratio over product names (see Open #1).

---

## OPEN SETUP DECISIONS (flag before they block) 🔶

| # | Decision | Default (proceeding unless told) | Why it matters |
|---|----------|----------------------------------|----------------|
| 1 | **Catalog matcher** | `rapidfuzz` in-memory over `kirana_oltp.product` names → `product_id` | Avoids torch/sentence-transformers (~2GB) in the deployable image. Lexical-only (lower quality than semantic). Semantic remains a future upgrade. |
| 2 | **Shelf image storage** | Local `data/vision_sessions/` dir on the backend host | Container disk is ephemeral → **Azure Blob needed before deploy.** Images are kept for the correction→training-data loop. |
| 3 | **FCM 'vision' channel** | Add a new `vision` channel to the cross-repo taxonomy; push on analysis done, deep-link Vision→Results | Cross-repo contract (see `project_push_notifications`). Needs app-side channel registration too. |
| 4 | **Gemini limits for vision** | Treat shelf scans as their own feature key (e.g. `shelf`) in `ai_usage`/credits, or exempt | Per-scan Gemini cost; align with Pro gating. Decide free-quota vs credits. |
| 5 | **rapidfuzz availability** | Add `rapidfuzz` to backend `requirements.txt` if absent (light C++ lib) | Matcher dependency. Verify before P0-BE matcher. |

---

## Backend contract (planned)

Router `kirana/vision/routes.py` → prefix `/kirana/vision`, JWT auth (store_id from token, **int**).

| Method | Path | Purpose |
|--------|------|---------|
| POST | `/shelf/analyze?session_type=morning\|evening` | multipart image → 202 `{job_id}` (async) |
| GET  | `/sessions?date=YYYY-MM-DD` | today's sessions + summary |
| GET  | `/session/{id}/items` | detected items (for review/correct) |
| GET  | `/sales?date=YYYY-MM-DD` | per-product delta = morning−evening |
| POST | `/correct/{item_id}` | owner fix → `corrected_product_id` (training data) |

### Schema (kirana_oltp, via `_ensure_schema`)
```
vision_session(
  id PK, store_id INT, session_type TEXT, session_date DATE,
  image_url TEXT, status TEXT,            -- pending|done|failed
  total_skus INT, total_units INT, unknown_count INT,
  created_at TIMESTAMP)
vision_item(
  id PK, session_id FK→vision_session, sku_id TEXT,
  product_id INT NULL,                    -- FK→product (matcher result; null=unknown)
  display_name TEXT, gemini_name TEXT, visible_text TEXT,
  count INT, match_score REAL, is_unknown BOOL, bbox_json TEXT,
  corrected_product_id INT NULL, corrected_at TIMESTAMP NULL,
  created_at TIMESTAMP)
```

---

## Frontend plan (kirana_ai house style)

- `lib/features/vision/{models,providers,views,widgets}` — Riverpod 3 Notifier, go_router, ARB l10n.
- `ApiClient.postMultipart(path, file, fields)` — new method (none exists today).
- Dashboard: 4th tab in `dashboard_screen.dart` IndexedStack + bottom nav; sub-tabs
  Shelf / Results / Counter(coming-soon); whole tab `_ProGateTab`-gated.
- **Rewrite, don't copy** vision-ai UI (it's `provider` + raw `http` + `camera`).

---

## Task status (mirror of tracked task list)

| ID | Task | Status |
|----|------|--------|
| 1 | Confirm open setup decisions | 🔶 proceeding on defaults (see flags below) |
| 2 | P0-BE: vision Postgres schema | ✅ done |
| 3 | P0-BE: port Gemini shelf analyzer | ✅ done |
| 4 | P0-BE: catalog matcher → product_id | ✅ done |
| 5 | P0-BE: vision router + endpoints | ✅ done (import-verified) |
| 6 | P0-BE: image storage + FCM push | ✅ done |
| 7 | P1-FE: vision feature module scaffolding | ✅ done |
| 8 | P1-FE: Vision dashboard tab + gating | ✅ done |
| 9 | P1-FE: shelf capture + results + correction | ✅ done |
| 10 | P1-FE: l10n vision strings (7 ARBs) | ✅ done (0 untranslated) |
| 11 | P2: counter on-device TFLite | ⏸ deferred |
| 12 | P3: counter → POS/basket + price guess | ⏸ deferred |
| 13 | Maintain this tracker | 🔁 ongoing |

Legend: ⬜ todo · 🔶 needs input · 🔁 ongoing · ⏸ deferred · ✅ done · ⛔ blocked

---

## P0 backend — DONE (2026-06-14), files written

Backend repo `kirana-master-backend`:
- `kirana/repository.py` — `vision_session` + `vision_item` in `_ensure_schema` (boot-migrates).
- `db_generation/ensure_full_schema.py` — same two tables mirrored.
- `ai/routes.py` — added public `call_gemini(model, parts, api_key)` (reuses shared client).
- `vision/` (new pkg): `analyzer.py` (prompt+parser, pure), `matcher.py` (rapidfuzz→difflib
  fallback, names→product_id), `storage.py` (local dir + blob seam), `repository.py` (DB ops),
  `schemas.py`, `routes.py` (6 endpoints, async bg task + FCM).
- `main.py` — vision_router registered. `requirements.txt` — added `rapidfuzz>=3.9.0`.
- ✅ `python -m py_compile` + `import main` pass; 6 `/kirana/vision/*` routes register.

### To run locally (user action)
1. `pip install rapidfuzz` in the backend env (else matcher silently uses slower difflib).
2. Ensure `GEMINI_API_KEY` is set in backend `.env` (same key the AI features use).
3. Restart the local server → `_ensure_schema` auto-creates the two vision tables.
4. **Do NOT deploy to Azure** (per user). Before any deploy: Azure Blob for images (storage.py
   seam) + verify the boot-crash trap.

### Still-open backend flags
- 🔶 **Gemini scan limits** (decision #4): shelf scans are NOT metered under `ai_usage`/credits
  yet — only Pro-gated client-side. Decide free-quota vs credits before wide rollout.
- 🔶 **Image endpoint auth**: `GET /image/{path}` requires Bearer → app must load it with a
  header-capable loader (`cached_network_image` `httpHeaders`), not bare `Image.network`.
- 🔶 **No server-side downscale**: image sent to Gemini as-is (app captures ~1920px/q90). Add
  Pillow resize only if token cost/misreads become an issue.

## P1 frontend — DONE (2026-06-14), files written

Flutter repo `kirana_ai`:
- `lib/core/services/api_client.dart` — added `postMultipart(...)` (Bearer multipart; accepts 202).
- `lib/features/vision/models/vision_models.dart` — VisionSession / VisionItem / SalesDeltaItem.
- `lib/features/vision/providers/vision_provider.dart` — `visionProvider` (capture→upload→**poll**
  until done, sessions, items, sales delta, owner correction) + `visionSubTabProvider` (deep-link).
- `lib/features/vision/views/vision_screen.dart` — 4th tab UI: Pro gate, 3 sub-tabs (Shelf capture
  w/ camera+gallery, Results sales-delta, Counter coming-soon), Review screen + correction sheet
  (reuses `posProvider.products` as the catalog picker).
- `lib/features/dashboard/views/dashboard_screen.dart` — 4th `VisionScreen` in IndexedStack + nav
  destination + deep-link (`tab:'vision'`→3, `subtab`→`visionSubTabProvider`, `action:open_vision`).
- `lib/l10n/app_en.arb` + 6 Indic ARBs — 35 `vision*` keys, **0 untranslated**.
- ✅ `flutter gen-l10n` clean; `flutter analyze lib/features/vision lib/features/dashboard` → No issues.

### Behaviour notes / known P1 limitations
- **Polling, not push, drives the foreground UX**: after upload the provider polls `/sessions`
  every 3s up to ~90s. FCM push still fires on completion for backgrounded apps (channel `vision`,
  deep-links to Vision→Results). The app must register a `vision` notification channel (cross-repo).
- **Correction picker uses `posProvider.products`** — if the user never opened the Billing tab, the
  list is empty and the sheet says so. Acceptable for P1; could trigger a load later.
- **Pro gate** keys off `subInfoProvider.canAccessVendorManagement` (same flag as Procurement).
- Shelf image itself isn't displayed in results yet (auth'd image endpoint exists; would need a
  header-capable loader). Detections list is the value.

### To see it run (user action)
1. Restart the **local backend** (picks up `/kirana/vision/*` + auto-migrates the 2 tables). Done ✅.
2. `flutter run` the app on a **Pro** store account → 4th "Vision" tab appears. Non-Pro sees paywall.
3. Take a morning photo, then an evening photo → Results shows what sold.
   (Needs `GEMINI_API_KEY` set on the backend; `rapidfuzz` installed for best matching.)

## Post-P1 changes (2026-06-14)

**(a) Vision notification channel** — added a `vision` Android channel in
`features/support/providers/notification_provider.dart` (`_channels` list). Backend pushes on
`channel:"vision"` now display on Android 8+ (previously fell back to default).

**(b) Multi-image shelf scan (3–10 photos per session)** — a session is now a SET of photos
(owner covers different store sections; counts are **summed** across photos — overlapping photos
would double-count, so cover distinct shelves).
- Backend `vision/routes.py`: `POST /shelf/analyze` takes `files: list[UploadFile]` (validates
  3–10), saves all, stores `image_url` as a **JSON array** of URLs, runs Gemini on every image
  **concurrently** (`asyncio.gather`, partial-failure tolerant), accumulates+matches+saves all
  detections. ✅ compiles + `import main` OK.
- App `core/services/api_client.dart`: `postMultipart` now takes `List<String> filePaths` (same
  field name `files`, 120s timeout).
- App `features/vision/`: `capture(type, List<String>)`; new `_CaptureSheet` (camera/gallery,
  thumbnails, remove, count-gated "Analyze (N)" button, min 3 / max 10).
- l10n: +5 keys (visionAddPhotosTitle/Hint, visionMinPhotosHint, visionMaxReached, visionAnalyze)
  in all 7 languages; `visionTakePhoto` reworded to "Add Photos" (en). ✅ 0 untranslated.
- ✅ `flutter analyze lib/features/vision` → No issues.

> Note: ~10 concurrent Gemini calls per session. If per-user metering is added later (open
> decision #4), meter per *session*, not per image.

**Test double updated** — `test/helpers/fake_api_client.dart` implements the `ApiClient` interface,
so it gained a `postMultipart` override. ✅ full-project `flutter analyze .` → No issues found.

## Tests + CI (2026-06-14)

**Both repos' CI must pass on next push — verified locally.**

### Backend (`pytest --cov=. -ra`, Postgres service in CI)
New vision tests:
- `tests/unit/test_vision_analyzer.py` — parser/anti-hallucination filters (14).
- `tests/unit/test_vision_matcher.py` — fuzzy match + rapidfuzz→difflib fallback (7).
- `tests/unit/test_vision_storage.py` — save + path-traversal guard (7).
- `tests/routes/test_vision_routes.py` — auth + image-count/session-type validation (~8).
- `tests/db/test_vision_repository.py` (`@pytest.mark.db`) — full lifecycle + store-scoping (6).
Pre-existing CI breakages FIXED along the way (CI was already red):
- `tests/conftest.py` — `Settings(cors_origins=...)` was missing (23 errors) + `user_sessions`
  fixture DDL missing telemetry columns (4 DB failures).
- `tests/routes/test_kirana_auth.py` — `fake_login` didn't accept the `telemetry` kwarg (2).
- `tests/unit/test_pos_auth.py::test_tampered_token_raises_401` — flaky (flipped last base64
  char = sometimes a no-op); now corrupts the signature's first char.
- ✅ `python -m pytest` → 149 passed / 21 skipped (no-DB); **169 passed with a throwaway DB**
  (validated on a temp `kirana_vision_test` DB, then dropped — `lit_db` untouched). Stable over 3 runs.

### Flutter (`dart format --set-exit-if-changed` + `flutter analyze --no-fatal-infos` + `flutter test`)
- `test/helpers/fake_api_client.dart` — added `postMultipart` override (interface parity).
- `test/features/vision/vision_models_test.dart` — model parsing/label/needsReview (5).
- ✅ format clean (170 files, 0 changed) · analyze No issues · **70 tests pass**.

## Resume notes (read first after a break)
- P0 is backend; P1 depends on P0 endpoints existing.
- Subagents: good fit for **l10n (task 10)** and isolated Flutter widgets; keep tightly-coupled
  backend integration on the main thread to avoid loopholes.
- Never deploy without permission; verify `import main` locally + watch for the silent
  old-image-on-boot-crash trap (`project_backend_deploy`).
