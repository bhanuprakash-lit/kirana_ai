import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../services/consent_upload_queue.dart';

/// Captures the customer's spoken consent for an udhaar order. Recording is
/// quick and the clip is handed to [ConsentUploadQueue] (persistent, retrying)
/// so the owner is never blocked — upload finishes in the background, even on
/// poor connections or after an app restart. Pro-gated (checked by the caller).
///
/// Returns `true` if a clip was recorded + queued, `false`/null if skipped.
Future<bool?> showConsentRecorderSheet(
  BuildContext context,
  WidgetRef ref, {
  required int? orderId,
  int? customerId,
  String? customerName,
  double? total,
  double? udhaar,
  String? promisedDate,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (_) => _ConsentRecorderSheet(
      orderId: orderId,
      customerId: customerId,
      customerName: customerName,
      total: total,
      udhaar: udhaar,
      promisedDate: promisedDate,
    ),
  );
}

const int _kConsentMaxSeconds = 20;

class _ConsentRecorderSheet extends ConsumerStatefulWidget {
  final int? orderId;
  final int? customerId;
  final String? customerName;
  final double? total;
  final double? udhaar;
  final String? promisedDate;

  const _ConsentRecorderSheet({
    required this.orderId,
    this.customerId,
    this.customerName,
    this.total,
    this.udhaar,
    this.promisedDate,
  });

  @override
  ConsumerState<_ConsentRecorderSheet> createState() =>
      _ConsentRecorderSheetState();
}

enum _RecState { idle, recording, saving }

class _ConsentRecorderSheetState extends ConsumerState<_ConsentRecorderSheet> {
  final AudioRecorder _recorder = AudioRecorder();
  _RecState _state = _RecState.idle;
  String? _error;
  Timer? _timer;
  int _seconds = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  String _fmtMoney(double v) => '₹${v.toStringAsFixed(0)}';

  Future<void> _start() async {
    final l10n = AppLocalizations.of(context);
    final granted = await Permission.microphone.request();
    if (!granted.isGranted) {
      setState(() => _error = l10n.procMicPermissionDenied);
      return;
    }
    if (!await _recorder.hasPermission()) {
      setState(() => _error = l10n.procMicNotAccessible);
      return;
    }
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/consent_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: path,
    );
    setState(() {
      _state = _RecState.recording;
      _error = null;
      _seconds = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _seconds++);
      if (_seconds >= _kConsentMaxSeconds) _stopAndQueue();
    });
  }

  Future<void> _stopAndQueue() async {
    _timer?.cancel();
    // Read locale-dependent values before any await (no context across gaps).
    final lang = Localizations.localeOf(context).languageCode;
    final noClipMsg = AppLocalizations.of(context).procNoItemsDetectedTryAgain;
    setState(() => _state = _RecState.saving);
    final secs = _seconds;
    String? path;
    try {
      path = await _recorder.stop();
    } catch (_) {
      path = null;
    }
    if (path == null || path.isEmpty) {
      if (mounted) {
        setState(() {
          _state = _RecState.idle;
          _error = noClipMsg;
        });
      }
      return;
    }

    await ref
        .read(consentUploadQueueProvider)
        .enqueue(
          sourcePath: path,
          orderId: widget.orderId,
          customerId: widget.customerId,
          agreedTotal: widget.total,
          agreedUdhaar: widget.udhaar,
          promisedDate: widget.promisedDate,
          language: lang,
          durationSec: secs.toDouble(),
        );
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final recording = _state == _RecState.recording;
    final scriptDate = widget.promisedDate ?? '';
    final script = l10n.finConsentScript(
      widget.total != null ? _fmtMoney(widget.total!) : '—',
      widget.udhaar != null ? _fmtMoney(widget.udhaar!) : '—',
      scriptDate,
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
        left: 24,
        right: 24,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BrandColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.record_voice_over_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.finConsentTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: BrandColors.ink,
                      ),
                    ),
                    Text(
                      l10n.finConsentSubtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _state == _RecState.saving
                    ? null
                    : () => Navigator.pop(context, false),
                child: Text(l10n.finConsentSkip),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // The line to read out — localized, with the real amounts/date.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.finConsentScriptIntro,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8B5CF6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '“$script”',
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: BrandColors.ink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (_error != null) ...[
            Text(
              _error!,
              style: const TextStyle(color: BrandColors.error, fontSize: 13),
            ),
            const SizedBox(height: 12),
          ],

          Center(
            child: GestureDetector(
              onTap: _state == _RecState.saving
                  ? null
                  : (recording ? _stopAndQueue : _start),
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: recording
                      ? BrandColors.error
                      : const Color(0xFF8B5CF6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          (recording
                                  ? BrandColors.error
                                  : const Color(0xFF8B5CF6))
                              .withValues(alpha: 0.3),
                      blurRadius: recording ? 18 : 10,
                      spreadRadius: recording ? 3 : 0,
                    ),
                  ],
                ),
                child: _state == _RecState.saving
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        recording ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              recording
                  ? '${l10n.finConsentRecording} · ${_seconds}s / ${_kConsentMaxSeconds}s'
                  : l10n.finConsentTapToRecord,
              style: const TextStyle(fontSize: 12, color: BrandColors.muted),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
