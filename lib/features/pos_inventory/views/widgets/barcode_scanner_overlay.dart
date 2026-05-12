import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/theme/brand_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan Barcode'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_detected) return;
              final raw = capture.barcodes.firstOrNull?.rawValue;
              if (raw != null) {
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
              'Align barcode within the frame',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
