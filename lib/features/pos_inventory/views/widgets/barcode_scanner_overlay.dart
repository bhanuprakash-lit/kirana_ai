import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Scans a barcode and returns it two ways:
/// 1. Via [onDetected] callback (used by POS tab for async handling)
/// 2. Via `Navigator.pop(context, value)` (used by add-product for await)
class BarcodeScannerOverlay extends StatefulWidget {
  final ValueChanged<String>? onDetected;
  const BarcodeScannerOverlay({super.key, this.onDetected});

  @override
  State<BarcodeScannerOverlay> createState() => _BarcodeScannerOverlayState();
}

class _BarcodeScannerOverlayState extends State<BarcodeScannerOverlay> {
  bool _detected = false;

  /// Returns true only for linear product barcodes (EAN, UPC, Code 128, etc.).
  /// QR codes are rejected entirely — they're used for referrals, not products.
  static bool _isProductBarcode(String value, BarcodeFormat? format) {
    if (value.isEmpty) return false;
    // QR codes are not product barcodes — handled separately as referral codes
    if (format == BarcodeFormat.qrCode) return false;
    // Aztec, DataMatrix, PDF417 — also 2D codes, not product barcodes
    if (format == BarcodeFormat.aztec ||
        format == BarcodeFormat.dataMatrix ||
        format == BarcodeFormat.pdf417) {
      return false;
    }
    // Fallback string checks for unknown format
    if (value.contains('://')) return false;
    if (value.startsWith('KIRANA_REF:')) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(l10n.posScanBarcode),
        elevation: 0,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_detected) return;
              final barcode = capture.barcodes.firstOrNull;
              final raw = barcode?.rawValue;
              if (raw != null && _isProductBarcode(raw, barcode?.format)) {
                _detected = true;
                Navigator.pop(context, raw); // returns value to awaiting push
                widget.onDetected?.call(raw); // callback for POS tab
              }
            },
          ),
          // Targeting reticle
          Center(
            child: Container(
              width: 250,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: BrandColors.accent, width: 2.5),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Text(
              l10n.posAlignBarcode,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
