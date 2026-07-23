# Vision AI → Kirana AI Integration (Reference)

Record of folding the **vision-ai** R&D project into the production app + backend.
**Integration is complete and live** (shelf scan, sale counter, bulk stock-in). This
doc is now a reference for the architecture and a running list of what's done vs pending.
The blow-by-blow lives in the `project-vision-ai` memory.

- **Last updated:** 2026-07-03
- **Status:** ✅ LIVE — deployed to the **dev** Azure backend; app builds with `--dart-define=ENV=dev`.
- **Repos:** `vision-ai` (R&D/training, intentionally uncommitted) · `kirana_ai` (Flutter) · `kirana-master-backend` (FastAPI)
- **Deploy note:** The original "do not deploy to Azure" rule is retired — vision is on the dev revision. Before any deploy, verify `import main` locally + confirm the revision is Running/Healthy (see `project_backend_deploy` — the silent old-image-on-boot-crash trap).

---

## What shipped

### 1. Shelf inventory — LIVE
Owner shoots morning + evening shelf photos → detect products → `morning − evening` delta = "what sold" → FCM push + Results tab.
- **Detection = custom YOLO (v7, 442 classes, ONNX Runtime) as PRIMARY + Gemini 2.5-flash as FALLBACK.** A Gemini failure (quota/MIME/timeout) is **non-fatal** — YOLO alone carries the scan; Gemini only adds coverage for products YOLO doesn't know yet (those become the next training labels).
- Upload MIME is **magic-byte sniffed** (Android's `application/octet-stream` no longer 400s Gemini). Per-image analysis is **concurrency-bounded** (semaphore, default 4).
- **Review screen shows a cropped thumbnail of each detected item** (bbox cropped from its source photo) so the owner can see what each row is; unknowns are corrected → training data.
- Photos stored in **Azure Blob** (durable) so thumbnails survive container restarts; local-disk fallback when Azure isn't configured (dev).
- Pro-gated + grocery-vertical-gated.

### 2. Sale-area counter — LIVE (on-device)
Live camera at the billing counter → **on-device YOLO (v7 `.tflite`)** + pure-Dart line-crossing tally → syncs a daily per-product summary. No server round-trip (real-time can't afford one).
- **Nothing is bundled** (PAI-15): the model is downloaded per platform by an authenticated
  user and cached in app-private storage. Android gets the `.tflite` from the `counter`
  blob prefix; iOS gets a CoreML `.mlpackage` (zipped, since it's a directory) from
  `counter-ios`. Both are exported from the same `kirana_v7` weights at 640px.

### 3. Bulk stock-in / onboarding — LIVE
New or existing stores photograph shelves → detect → confirm quantities → write to inventory (SET for empty stores, ADD-on for restock). Ungated but rate-limited (5 scans/store/day).

---

## Architecture (current)

- **Reusable Gemini client** — all AI (vision/audio/handwrite/invoice) routes through `ai/routes.call_gemini(model, parts, api_key)` (warm-TLS httpx, JSON mode, response cache). No `google.genai` SDK.
- **On-server detector** — `vision/detector.py` = ONNX Runtime session over `vision/models/kirana_v7.onnx` (+ `kirana_v7_labels.txt`, optional `kirana_v7_class_map.json`). Lazy, optional, env-gated (`VISION_YOLO_ENABLED`); absent model/onnxruntime ⇒ Gemini-only, boot never crashes.
- **Catalog matcher** — `vision/matcher.py` rapidfuzz→difflib over `kirana_oltp.product` names → `product_id`. YOLO matched at a strict 0.82 (terse labels collide) so weak matches → owner review, never wrong stock.
- **Schema** (`kirana/repositories/base.py::_ensure_schema` + `db_generation/ensure_full_schema.py`, boot-migrated): `vision_session` (+`finished_at` = analysis latency stamp), `vision_item` (+`bbox_json`, `image_index`, `detector_source` = 'yolo'|'gemini'), `counter_session`, `counter_item`.
- **Blob storage** — `vision/onboarding_storage.py` (Azure Blob; used by both onboarding and daily shelf) with local-disk fallback (`vision/storage.py`). Needs `AZURE_STORAGE_CONNECTION_STRING`.
- **Endpoints** (`/kirana/vision`): `shelf/analyze`, `sessions`, `session/{id}/items`, `sales`, `correct/{id}`, **`item/{id}/crop`**, `image/{path}`, `onboarding/{analyze,commit/{id}}`, `counter/{sync,summary}`, **`analytics?days=`** (usage/accuracy/detector-split/daily-trend + top unknowns).

---

## Task status

| Area | Status |
|------|--------|
| Shelf: schema, Gemini analyzer, matcher, router, storage, FCM | ✅ done |
| Shelf FE: Vision tab (Pro-gated), capture/results/correction | ✅ done |
| l10n (7 ARBs) | ✅ done (0 untranslated) |
| Custom YOLO detector serving in backend (v6 → **v7**) | ✅ done |
| Sale counter (on-device tflite, line-crossing, sync) | ✅ done |
| Bulk stock-in / onboarding (+ restock add-on) | ✅ done |
| Review-screen crop thumbnails | ✅ done |
| Durable Blob storage for shelf photos | ✅ done |
| iOS counter: Dart platform-aware wiring (CoreML path + availability gate) | ✅ done |
| iOS CoreML export for counter (the `.mlpackage` binary) | ✅ done (exported in a Linux container, published to blob) |
| Model delivery: download + resume + checksum, both platforms | ✅ done |
| Counter verified on a physical iPhone | ⏸ **pending — never run on iOS hardware** |
| v7 class-map curation (397 need_review rows) | ⏸ pending (optional) |
| Counter → POS/basket + price guess | ⏸ deferred |

---

## Pending / follow-ups

1. **Run the counter on a real iPhone.** Everything below it is built and the
   model is published, but no part of the iOS path has ever executed on Apple
   hardware — it can't be built from Windows. Two things are unverified and both
   fail loudly rather than silently: (a) the CoreML conversion is numerically
   untested, because `coremltools` can convert on Linux but only *predict* on
   macOS, and the `nms=True` pipeline rewires the output heads; (b) the extracted
   `.mlpackage` path handed to `YOLOView` is exercised only by unit tests.

   The export itself does **not** need a Mac. `coremltools` ships no Windows
   wheels (hence `assert not WINDOWS` in the ultralytics exporter), but Linux is
   fine — a container is enough:

       yolo export model=runs/kirana_v7/weights/best.pt format=coreml \
                   nms=True imgsz=640 half=True

   `nms=True` because this is yolo11s; YOLO26 would want `nms=False end2end=True`.
   Publish with `--model counter-ios`, which zips to `.mlpackage.zip`.
   A Mac (or macOS CI) is still required to *build and sign* the IPA.
2. **v7 class-map curation** — `kirana_v7_class_map.json` is generated (11 confirmed / 431 need_review). The 431 fall through to safe fuzzy matching; a human curating them (set `product_id` + `confirmed:true`) makes YOLO mapping deterministic. Optional.
3. **Look-alike products (v8 retrain)** — text-first matching shipped (see below); the deeper fix (65–90%) needs labelled per-variant crops + a retrain. Plan: `vision-ai/LOOKALIKE_PLAN.md`.
4. **Gemini billing** — the free-tier key hits the 20-req quota; YOLO covers scans regardless. For a paid Gemini fallback funded by GCP free-trial credits, switch `call_gemini` to **Vertex AI** (the free-trial credit reliably covers Vertex, not the AI-Studio key). Optional.
5. **Commit** the working-tree changes across backend + `kirana_ai`. The user has been self-deploying/rebuilding.

> Env note: use the **`kirana-ml`** conda env for the backend (complete deps: fastapi/jose/rapidfuzz/pytest), not `kirana` (partial). Full suite there: 163 passed, 21 skipped (DB-only).

## Done since (2026-07-03)
- **Vision analytics (2026-07-06)**: `vision_item.detector_source` ('yolo'|'gemini', backfilled default 'gemini' — YOLO shipped later), `vision_session.finished_at` (stamped on finalize AND fail → processing latency), and `GET /kirana/vision/analytics?days=1..365` (store-scoped: session volume/status/type + avg processing seconds, unknown & correction rates, own-YOLO vs Gemini split, per-day series, top-10 uncorrected unknowns = next training labels). Semantics: an owner-corrected item leaves `unknown` and counts as `corrected`. Verified against real Postgres (docker) incl. the legacy ALTER path.
- **Admin panel Vision AI tab (2026-07-07)**: fleet-wide view of the above. `repo.get_analytics(store_id=None)` = all stores; new `repo.get_store_breakdown(days)` = per-store rows (sessions, unknown/correction rate, yolo_share, last_scan). Admin endpoint `GET /kirana/admin/vision/analytics?days=&store_id=` (X-API-Key; fleet by default, `store_id` scopes + drops the per-store table). Admin-panel page `admin-panel/src/pages/Vision.jsx` (route `/vision`, sidebar 👁️): KPI cards, chart.js daily line + detector-split doughnut, usage-by-store table, top-unknowns list, 7/30/90-day selector. `npm run build` clean; endpoint verified end-to-end (auth/validation/fleet/store-scope/breakdown) against docker Postgres.
- **Look-alike text-first matching** (`vision/matcher.py`): matches on Gemini's `visible_text` (printed variant/weight words) + unit normalization (`500 g`→`500g`), so variants disambiguate (Sandal vs Neem, 500g vs 200g) without a retrain. rapidfuzz-only.
- **Onboarding review thumbnails**: shared `VisionItemThumb` widget now used on both the shelf and onboarding review screens.
- **Global `IntegrityError` handler** (`main.py`): FK/unique/not-null violations → clean 4xx instead of 500 (fixed a `/products/{id}/locations` FK 500). See `project-integrity-errors` memory.

---

## Historical note

This started (2026-06-14) as a Gemini-only, server-side shelf-scan integration with the
custom YOLO explicitly out of scope and "do not deploy" in force. It has since grown to a
custom-YOLO-primary pipeline (v6→v7), an on-device counter, bulk stock-in, crop thumbnails,
and durable Blob storage, all deployed to dev.
