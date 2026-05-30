// Riverpod state management for the Bluetooth thermal printer.
//
// Lifecycle:
//   1. build() calls init() via Future.microtask — requests BT permissions
//      on first load and auto-connects to the saved printer if BT is on.
//   2. onAppResumed() — re-checks BT state when app returns to foreground.
//   3. selectPrinter() — user picks a device; saves it and connects.
//   4. printOrder() — verifies connection, reconnects if needed, prints.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pos_product.dart';
import '../services/printer_service.dart';
import '../../profile/models/store_model.dart';

export '../services/printer_service.dart'
    show PrinterDevice, ReceiptData, ReceiptLineItem;

// ── Status enum ───────────────────────────────────────────────────────────────

enum PrinterStatus {
  noPrinterSaved,
  bluetoothOff,
  disconnected,
  connecting,
  printerNotFound,
  connected,
  printing,
  error,
}

extension PrinterStatusX on PrinterStatus {
  String get label {
    switch (this) {
      case PrinterStatus.noPrinterSaved:
        return 'No printer connected';
      case PrinterStatus.bluetoothOff:
        return 'Device Bluetooth is turned off';
      case PrinterStatus.disconnected:
        return 'Printer disconnected';
      case PrinterStatus.connecting:
        return 'Connecting to printer...';
      case PrinterStatus.printerNotFound:
        return 'Printer not found nearby';
      case PrinterStatus.connected:
        return 'Ready to print receipt';
      case PrinterStatus.printing:
        return 'Printing receipt...';
      case PrinterStatus.error:
        return 'Printer connection failed';
    }
  }

  Color get color {
    switch (this) {
      case PrinterStatus.noPrinterSaved:
        return const Color(0xFF9CA3AF); // grey-400
      case PrinterStatus.bluetoothOff:
        return const Color(0xFFEF4444); // red-500
      case PrinterStatus.disconnected:
        return const Color(0xFF9CA3AF); // grey-400
      case PrinterStatus.connecting:
        return const Color(0xFF3B82F6); // blue-500
      case PrinterStatus.printerNotFound:
        return const Color(0xFFF59E0B); // amber-500
      case PrinterStatus.connected:
        return const Color(0xFF10B981); // emerald-500
      case PrinterStatus.printing:
        return const Color(0xFF3B82F6); // blue-500
      case PrinterStatus.error:
        return const Color(0xFFEF4444); // red-500
    }
  }

  bool get isBusy =>
      this == PrinterStatus.connecting || this == PrinterStatus.printing;

  bool get isReadyOrPrinting =>
      this == PrinterStatus.connected || this == PrinterStatus.printing;
}

// ── State ─────────────────────────────────────────────────────────────────────

class PrinterStateData {
  final PrinterStatus status;
  final bool btEnabled;
  final PrinterDevice? selectedPrinter;
  final List<PrinterDevice> pairedDevices;
  final bool loadingDevices;

  const PrinterStateData({
    this.status = PrinterStatus.noPrinterSaved,
    this.btEnabled = false,
    this.selectedPrinter,
    this.pairedDevices = const [],
    this.loadingDevices = false,
  });

  String get statusLabel => status.label;
  Color get statusColor => status.color;
  bool get isConnected => status.isReadyOrPrinting;
  bool get isBusy => status.isBusy;

  PrinterStateData copyWith({
    PrinterStatus? status,
    bool? btEnabled,
    PrinterDevice? selectedPrinter,
    bool clearPrinter = false,
    List<PrinterDevice>? pairedDevices,
    bool? loadingDevices,
  }) => PrinterStateData(
    status: status ?? this.status,
    btEnabled: btEnabled ?? this.btEnabled,
    selectedPrinter: clearPrinter
        ? null
        : (selectedPrinter ?? this.selectedPrinter),
    pairedDevices: pairedDevices ?? this.pairedDevices,
    loadingDevices: loadingDevices ?? this.loadingDevices,
  );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class PrinterNotifier extends Notifier<PrinterStateData> {
  final _svc = PrinterService();
  // Guards against concurrent connect attempts (e.g. double init() call).
  bool _connecting = false;

  @override
  PrinterStateData build() {
    // Do NOT call init() here — main.dart calls it explicitly via
    // addPostFrameCallback so BT permissions are requested after the first
    // frame. A second microtask-based call would race and both fail.
    return const PrinterStateData();
  }

  // ── Init ───────────────────────────────────────────────────────────────────

  Future<void> init() async {
    await _svc.requestPermissions();

    final saved = await _svc.getSelectedPrinter();
    final btEnabled = await _svc.isBluetoothEnabled;

    if (!btEnabled) {
      state = state.copyWith(
        status: PrinterStatus.bluetoothOff,
        btEnabled: false,
        selectedPrinter: saved,
      );
      return;
    }

    state = state.copyWith(btEnabled: true, selectedPrinter: saved);

    if (saved == null) {
      state = state.copyWith(status: PrinterStatus.noPrinterSaved);
      return;
    }

    _autoConnect();
  }

  Future<void> onAppResumed() async {
    final btEnabled = await _svc.isBluetoothEnabled;
    state = state.copyWith(btEnabled: btEnabled);

    if (!btEnabled) {
      state = state.copyWith(status: PrinterStatus.bluetoothOff);
      return;
    }

    if (!state.isConnected && state.selectedPrinter != null) {
      _autoConnect();
    }
  }

  Future<void> _autoConnect() async {
    // Hard lock — prevents two concurrent connect flows (e.g. double init call).
    if (_connecting || state.isConnected) return;
    _connecting = true;
    state = state.copyWith(status: PrinterStatus.connecting);

    bool ok = false;
    // Retry up to 3 times; BT stack sometimes needs a moment after hot-restart.
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        ok = await _svc.connect();
      } catch (_) {
        ok = false;
      }
      if (ok) break;
      if (attempt < 3) await Future.delayed(const Duration(seconds: 2));
    }

    _connecting = false;
    state = state.copyWith(
      status: ok ? PrinterStatus.connected : PrinterStatus.printerNotFound,
    );
  }

  // ── Device picker ─────────────────────────────────────────────────────────

  Future<void> loadPairedDevices() async {
    state = state.copyWith(loadingDevices: true);
    try {
      final devices = await _svc.getPairedDevices();
      state = state.copyWith(pairedDevices: devices, loadingDevices: false);
    } catch (_) {
      state = state.copyWith(pairedDevices: [], loadingDevices: false);
    }
  }

  Future<void> selectPrinter(PrinterDevice device) async {
    await _svc.saveSelectedPrinter(device);
    state = state.copyWith(selectedPrinter: device);
    await connect(mac: device.address);
  }

  Future<void> forgetPrinter() async {
    await _svc.clearSelectedPrinter();
    await _svc.disconnect();
    state = state.copyWith(
      status: PrinterStatus.noPrinterSaved,
      clearPrinter: true,
    );
  }

  // ── Connect / disconnect ──────────────────────────────────────────────────

  Future<void> connect({String? mac}) async {
    state = state.copyWith(status: PrinterStatus.connecting);

    bool ok;
    try {
      ok = await _svc.connect(mac: mac);
    } catch (_) {
      ok = false;
    }

    state = state.copyWith(
      status: ok ? PrinterStatus.connected : PrinterStatus.printerNotFound,
    );
  }

  Future<void> reconnect() async {
    // Clear the lock so a manual reconnect always proceeds even if a previous
    // auto-connect attempt left it stuck.
    _connecting = false;
    await _autoConnect();
  }

  // ── Print ─────────────────────────────────────────────────────────────────

  /// Builds a [ReceiptData] from a raw order map (as returned by the POS API).
  static ReceiptData buildReceipt({
    required Map<String, dynamic> order,
    StoreProfile? store,
    List<PosProduct> products = const [],
  }) {
    final orderId = order['order_id']?.toString() ?? '';
    var dateStr = order['order_date'] as String? ?? '';

    // Backend stores UTC datetimes but omits the 'Z' suffix (confirmed via
    // fetchTodayOrders which does the same fix).  Without 'Z', Dart parses the
    // string as *local* time — on an IST device that treats "06:10" as IST,
    // so _toIst() sees IST-local → UTC → +5:30 = identity → still shows 06:10.
    // Appending 'Z' forces Dart to parse it as UTC, and _toIst() correctly
    // produces 06:10 UTC + 5:30 = 11:40 IST.
    if (dateStr.isNotEmpty &&
        !dateStr.endsWith('Z') &&
        !dateStr.contains('+')) {
      dateStr += 'Z';
    }

    final dt = DateTime.tryParse(dateStr) ?? DateTime.now().toUtc();
    final total = (order['total_amount'] as num?)?.toDouble() ?? 0;
    final payment = order['payment_method'] as String? ?? 'Cash';
    final rawItems = (order['items'] as List<dynamic>?) ?? [];

    final items = rawItems.map<ReceiptLineItem>((item) {
      final productId = item['product_id'] as int?;
      final qty = (item['quantity'] as num?)?.toDouble() ?? 0;
      final price = (item['unit_price'] as num?)?.toDouble() ?? 0;
      final product = products
          .where((p) => p.productId == productId)
          .firstOrNull;
      // Build display name: "Waterbottles (250 ml)", "Maida (5 kg)", etc.
      // Matches the weightLabel pattern used in POS search for consistency.
      final label = product?.weightLabel;
      final displayName = product != null
          ? (label != null ? '${product.name} ($label)' : product.name)
          : 'Product #$productId';

      return ReceiptLineItem(
        name: displayName,
        qty: qty,
        unit: product?.unit,
        unitPrice: price,
      );
    }).toList();

    return ReceiptData(
      storeName: store?.name ?? 'My Store',
      storeLocation: store?.location,
      orderId: orderId,
      orderDateTime: dt,
      items: items,
      totalAmount: total,
      paymentMethod: payment,
    );
  }

  Future<bool> printOrder(ReceiptData data) async {
    if (!state.isConnected) {
      await connect();
      if (!state.isConnected) return false;
    }

    state = state.copyWith(status: PrinterStatus.printing);

    bool ok;
    try {
      ok = await _svc.printOrder(data);
    } catch (_) {
      ok = false;
    }

    if (ok) {
      state = state.copyWith(status: PrinterStatus.connected);
    } else {
      state = state.copyWith(status: PrinterStatus.error);
      // Auto-reset after 3s
      Future.delayed(const Duration(seconds: 3), () {
        if (state.status == PrinterStatus.error) {
          state = state.copyWith(status: PrinterStatus.disconnected);
        }
      });
    }
    return ok;
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final printerProvider = NotifierProvider<PrinterNotifier, PrinterStateData>(
  PrinterNotifier.new,
);
