// Bluetooth ESC/POS receipt printer service for POS orders.
// 58 mm paper → 32 chars per line in normal 12×24 font.
// Uses print_bluetooth_thermal (Classic BT / SPP) — works with Gobbler MPT-II
// and most 58 mm ESC/POS printers.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Device descriptor ──────────────────────────────────────────────────────────

class PrinterDevice {
  final String name;
  final String address;
  const PrinterDevice({required this.name, required this.address});
}

// ── Receipt data ───────────────────────────────────────────────────────────────

class ReceiptData {
  final String storeName;
  final String? storeLocation;
  final String orderId;
  final DateTime orderDateTime;
  final List<ReceiptLineItem> items;
  final double totalAmount;
  final String paymentMethod;

  const ReceiptData({
    required this.storeName,
    this.storeLocation,
    required this.orderId,
    required this.orderDateTime,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
  });
}

class ReceiptLineItem {
  final String name;
  final double qty;
  final String? unit;
  final double unitPrice;

  double get lineTotal => qty * unitPrice;

  const ReceiptLineItem({
    required this.name,
    required this.qty,
    this.unit,
    required this.unitPrice,
  });
}

// ── Service ────────────────────────────────────────────────────────────────────

class PrinterService {
  static const String _kMac = 'pos_printer_mac';
  static const String _kName = 'pos_printer_name';

  // ── Persistence ─────────────────────────────────────────────────────────────

  Future<PrinterDevice?> getSelectedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final mac = prefs.getString(_kMac);
    final name = prefs.getString(_kName);
    if (mac == null || mac.isEmpty) return null;
    return PrinterDevice(name: name ?? mac, address: mac);
  }

  Future<void> saveSelectedPrinter(PrinterDevice device) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kMac, device.address);
    await prefs.setString(_kName, device.name);
  }

  Future<void> clearSelectedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kMac);
    await prefs.remove(_kName);
  }

  // ── BT state ────────────────────────────────────────────────────────────────

  Future<bool> get isBluetoothEnabled async {
    // On iOS, the plugin might return false if checked too quickly after app start.
    // We don't loop here to avoid blocking, but the notifier handles retries.
    return await PrintBluetoothThermal.bluetoothEnabled;
  }

  Future<bool> get isConnected => PrintBluetoothThermal.connectionStatus;

  // ── Permissions ─────────────────────────────────────────────────────────────

  /// Requests BLUETOOTH_CONNECT + BLUETOOTH_SCAN on Android 12+.
  /// On iOS, requests the general Bluetooth permission.
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final result = await [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();
      return result.values.every((s) => s.isGranted || s.isLimited);
    } else if (Platform.isIOS) {
      final status = await Permission.bluetooth.request();
      // On iOS 13+, we also need to ensure Bluetooth is allowed for the app.
      return status.isGranted || status.isLimited;
    }
    return true;
  }

  // ── Device discovery ────────────────────────────────────────────────────────

  DateTime _lastScan = DateTime(0);

  Future<List<PrinterDevice>> getPairedDevices() async {
    await requestPermissions();

    // Throttle: Ensure at least 3 seconds between scan requests
    final now = DateTime.now();
    if (now.difference(_lastScan) < const Duration(seconds: 3)) {
      await Future.delayed(const Duration(seconds: 3));
    }
    _lastScan = DateTime.now();

    // On iOS, this plugin's pairedBluetooths method actually triggers/returns 
    // discovered BLE peripherals.
    final list = await PrintBluetoothThermal.pairedBluetooths;
    return list
        .map(
          (d) => PrinterDevice(
            name: d.name,
            address: d.macAdress, // intentional typo in package
          ),
        )
        .toList();
  }

  // ── Connection ──────────────────────────────────────────────────────────────

  /// Always closes any open socket first, then re-connects.
  /// This fixes hot-restart ("Printer Not Found") and stale-socket reconnect
  /// failures.
  Future<bool> connect({String? mac}) async {
    final targetMac = mac ?? (await getSelectedPrinter())?.address;
    if (targetMac == null) return false;
    await requestPermissions();

    if (Platform.isIOS) {
      // ── iOS Stability Logic ──────────────────────────────────────────────
      
      // 1. Wait for Bluetooth to be ready.
      bool ready = false;
      for (int i = 0; i < 5; i++) {
        if (await PrintBluetoothThermal.bluetoothEnabled) {
          ready = true;
          break;
        }
        await Future.delayed(const Duration(milliseconds: 600));
      }
      if (!ready) return false;

      // 2. Ensure the device is in the plugin's internal map.
      // The plugin crashes (force-unwraps nil) if we connect to a UUID it hasn't 
      // "discovered" in the current session.
      bool found = false;
      for (int i = 0; i < 8; i++) {
        final devices = await getPairedDevices();
        if (devices.any((d) => d.address.toUpperCase() == targetMac.toUpperCase())) {
          found = true;
          break;
        }
        // Scanning...
        await Future.delayed(const Duration(milliseconds: 1200));
      }
      
      if (!found) return false;

      // 3. DO NOT call disconnect on iOS before connect.
      // In this specific plugin, disconnect can clear the peripheral map, 
      // causing the subsequent connect() to crash.
    } else {
      // ── Android Logic ────────────────────────────────────────────────────
      try {
        await PrintBluetoothThermal.disconnect;
      } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 700));
    }

    try {
      return await PrintBluetoothThermal.connect(macPrinterAddress: targetMac);
    } catch (e) {
      debugPrint('Printer connection error: $e');
      return false;
    }
  }

  Future<bool> disconnect() => PrintBluetoothThermal.disconnect;

  // ── Print ────────────────────────────────────────────────────────────────────

  Future<bool> printOrder(ReceiptData data) async {
    if (!await isConnected) return false;
    final bytes = _buildReceipt(data);
    // Send the entire receipt in ONE write.
    // RFCOMM (SPP) has built-in flow control — the socket OutputStream.write()
    // blocks until all bytes are delivered, so there is no truncation risk.
    // Chunked writes were causing spurious mid-line page-advances because the
    // async method-channel round-trip (~5 ms) between chunks is enough to
    // trigger the printer's internal line-buffer flush timer.
    // The 500 ms pause lets the printer finish processing ESC/POS and
    // advance/cut paper before the caller can disconnect.
    final ok = await PrintBluetoothThermal.writeBytes(bytes);
    if (ok) await Future.delayed(const Duration(milliseconds: 500));
    return ok;
  }

  // ── ESC/POS receipt builder ──────────────────────────────────────────────────

  List<int> _buildReceipt(ReceiptData data) {
    final buf = <int>[];

    void b(List<int> cmd) => buf.addAll(cmd);
    void s(String text) => buf.addAll(_ascii(text));
    void nl([int n = 1]) => buf.addAll(List.filled(n, _lf));
    void sep([String ch = '-']) {
      s(ch * 32);
      nl();
    }

    // Always convert to IST (UTC+5:30) explicitly.
    // Using toLocal() is unreliable — Android devices often stay in UTC.
    final dt = _toIst(data.orderDateTime);
    final dateStr = '${_pad(dt.day)}/${_pad(dt.month)}/${dt.year}';
    final hour = dt.hour;
    final ampm = hour < 12 ? 'AM' : 'PM';
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final timeStr = '${_pad(h)}:${_pad(dt.minute)} $ampm';

    // ── Init ─────────────────────────────────────────────────────────────────
    b(_init);

    // ── App branding (header) ─────────────────────────────────────────────────
    // b(_alignCenter);
    // b(_dblSize);
    // b(_boldOn);
    // s('KIRANA AI');
    // nl();
    // b(_normalSize);
    // b(_boldOff);
    // s(_center('by Lohiya AI'));
    // nl();
    // sep('=');

    // ── Store info ────────────────────────────────────────────────────────────
    b(_boldOn);
    s(data.storeName.toUpperCase());
    nl();
    b(_boldOff);
    if (data.storeLocation != null && data.storeLocation!.isNotEmpty) {
      s(data.storeLocation!);
      nl();
    }
    sep();

    // ── Order meta ────────────────────────────────────────────────────────────
    b(_alignLeft);
    s(_kv('Order', '#${data.orderId}'));
    nl();
    s(_kv('Date', dateStr));
    nl();
    s(_kv('Time', timeStr));
    nl();
    s(_kv('Payment', data.paymentMethod.toUpperCase()));
    nl();
    sep();

    // ── Items ─────────────────────────────────────────────────────────────────
    b(_boldOn);
    s(_itemRow('Item(s)', 'Qty', 'Amount'));
    nl();
    b(_boldOff);
    sep();

    for (final item in data.items) {
      final qtyStr = item.qty % 1 == 0
          ? item.qty.toInt().toString()
          : item.qty.toStringAsFixed(1);
      final amtStr = item.lineTotal.toStringAsFixed(2);

      // ── DMart / Vijetha style: 2 lines per item ───────────────────────────
      // Line 1 — full product name (e.g. "Waterbottles (250 ml)")
      //           truncated at 32 chars only if absolutely necessary
      // Line 2 — qty + amount right-aligned under the header columns
      //           indent(18) + qty(6) + amount(8) = 32 chars
      final nameLine = item.name.length > 32
          ? item.name.substring(0, 32)
          : item.name;
      s(nameLine);
      nl();
      s(''.padRight(18) + qtyStr.padLeft(6) + amtStr.padLeft(8));
      nl();
    }
    sep('=');

    // ── Grand total ───────────────────────────────────────────────────────────
    b(_boldOn);
    s(_totalRow('TOTAL', 'Rs.${data.totalAmount.toStringAsFixed(2)}'));
    nl();
    b(_boldOff);
    sep('=');

    // ── Footer ────────────────────────────────────────────────────────────────
    b(_alignCenter);
    b(_boldOn);
    s('Thank You!  Visit Again.');
    nl();
    b(_boldOff);
    s('Kirana AI by Lohiya AI');
    nl(4);

    // nl(2); // feed before cut
    // b(_cut);

    return buf;
  }

  // ── Timezone helper ───────────────────────────────────────────────────────────

  /// Converts [dt] to IST (UTC+5:30) regardless of device timezone.
  static DateTime _toIst(DateTime dt) =>
      dt.toUtc().add(const Duration(hours: 5, minutes: 30));

  // ── Layout helpers (32-char line width) ─────────────────────────────────────

  static String _pad(int n) => n.toString().padLeft(2, '0');

  String _center(String s, [int width = 32]) {
    if (s.length >= width) return s.substring(0, width);
    final pad = (width - s.length) ~/ 2;
    return ' ' * pad + s;
  }

  String _wrapCenter(String text, [int width = 32]) {
    final lines = _wordWrap(text, width);
    return lines.map((l) => _center(l, width)).join('\n');
  }

  /// Key-value pair: "Key:       Value" (key=10, value=22)
  String _kv(String key, String val) {
    final k = '$key:'.padRight(10);
    final v = val.length > 22 ? val.substring(0, 22) : val;
    return '$k$v';
  }

  /// Item row: name(18) qty(6) amount(8) = 32 chars
  String _itemRow(String name, String qty, String amt) {
    final n = name.length > 18
        ? '${name.substring(0, 17)}.'
        : name.padRight(18);
    final q = qty.padLeft(6);
    final a = amt.padLeft(8);
    return '$n$q$a';
  }

  /// Total row: label(20) amount(12) = 32 chars
  String _totalRow(String label, String amt) {
    final l = label.length > 20 ? label.substring(0, 20) : label.padRight(20);
    final a = amt.padLeft(12);
    return '$l$a';
  }

  List<String> _wordWrap(String text, int width) {
    if (text.length <= width) return [text];
    final words = text.split(' ');
    final lines = <String>[];
    var line = '';
    for (final w in words) {
      if (line.isEmpty) {
        line = w;
      } else if (line.length + 1 + w.length <= width) {
        line += ' $w';
      } else {
        lines.add(line);
        line = w;
      }
    }
    if (line.isNotEmpty) lines.add(line);
    return lines;
  }

  // ── Encoding ─────────────────────────────────────────────────────────────────
  // Printer default codepage is ASCII-compatible. Non-ASCII → '?'.
  static List<int> _ascii(String s) =>
      s.codeUnits.map((c) => c > 0x7F ? 0x3F : c).toList();

  // ── ESC/POS constants ──────────────────────────────────────────────────────────
  static const int _lf = 0x0A;
  static const List<int> _init = [0x1B, 0x40]; // ESC @ — reset
  static const List<int> _alignLeft = [0x1B, 0x61, 0x00]; // ESC a 0
  static const List<int> _alignCenter = [0x1B, 0x61, 0x01]; // ESC a 1
  static const List<int> _boldOn = [0x1B, 0x45, 0x01]; // ESC E 1
  static const List<int> _boldOff = [0x1B, 0x45, 0x00]; // ESC E 0
  static const List<int> _dblSize = [0x1B, 0x21, 0x30]; // double width+height
  static const List<int> _normalSize = [0x1B, 0x21, 0x00]; // normal size
  static const List<int> _cut = [0x1D, 0x56, 0x42, 0x03]; // GS V 66 3 — cut
}
