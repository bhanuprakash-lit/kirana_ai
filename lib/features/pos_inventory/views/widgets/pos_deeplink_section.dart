import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/store/store_scope.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../core/vertical/vertical_config_provider.dart';
import '../../../services/models/service_models.dart';
import '../../../services/providers/service_provider.dart';
import '../../../warranty/warranty.dart' show serialsProvider;
import '../../providers/pos_provider.dart';
import 'barcode_scanner_overlay.dart';

/// What the shopkeeper linked to this sale at checkout (POS deep-links).
/// All optional — the backend best-effort applies whatever is set:
///   M7 serials sold, M4 appointment completed + membership session used,
///   M9 job card billed.
class PosDeepLinks {
  // Tester #4 — serials/IMEIs captured per cart line (keyed by CartItem.lineKey)
  // so each links to the specific phone it was billed against.
  Map<String, List<String>> serialsByLine;
  int? membershipId;
  int? appointmentId;
  int? jobCardId;
  // M4 — when an appointment is billed at checkout, its service price is added
  // to the order total (O2). 0 when none / membership-covered.
  double appointmentCharge;
  PosDeepLinks({
    Map<String, List<String>>? serialsByLine,
    this.membershipId,
    this.appointmentId,
    this.jobCardId,
    this.appointmentCharge = 0,
  }) : serialsByLine = serialsByLine ?? {};

  /// All captured serials across every line (blank entries dropped).
  List<String> get allSerials => serialsByLine.values
      .expand((e) => e)
      .where((s) => s.trim().isNotEmpty)
      .toList();

  bool get isEmpty =>
      allSerials.isEmpty &&
      membershipId == null &&
      appointmentId == null &&
      jobCardId == null;
}

/// Open job cards (ready to bill) for the store.
final _openJobCardsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      ref.watch(storeScopeProvider); // refetch when the active store changes
      final data = await ref
          .read(apiClientProvider)
          .get('/kirana/job-cards?status=ready');
      final list =
          (data is Map ? data['job_cards'] : data) as List<dynamic>? ?? [];
      return list
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
    });

/// Active memberships for a customer (for the "use a session" toggle).
final _membershipsProvider = FutureProvider.autoDispose
    .family<List<Membership>, int>((ref, customerId) async {
      ref.watch(storeScopeProvider); // refetch when the active store changes
      final data = await ref
          .read(apiClientProvider)
          .get('/kirana/memberships?customer_id=$customerId');
      final list =
          (data is Map ? data['memberships'] : null) as List<dynamic>? ?? [];
      return list
          .whereType<Map>()
          .map((e) => Membership.fromJson(e.cast<String, dynamic>()))
          .where((m) => m.isActive)
          .toList();
    });

/// Checkout add-on: link module records (serials / appointment / membership /
/// job card) to the sale. Each block is gated by the store's vertical so a
/// grocery store never sees it.
class PosDeepLinkSection extends ConsumerStatefulWidget {
  final int? customerId;
  final PosDeepLinks links;
  final VoidCallback onChanged;
  const PosDeepLinkSection({
    super.key,
    required this.customerId,
    required this.links,
    required this.onChanged,
  });

  @override
  ConsumerState<PosDeepLinkSection> createState() => _PosDeepLinkSectionState();
}

class _PosDeepLinkSectionState extends ConsumerState<PosDeepLinkSection> {
  // One serial input per cart line (keyed by CartItem.lineKey).
  final Map<String, TextEditingController> _serialCtrls = {};
  String? _serialError;

  TextEditingController _ctrlFor(String lineKey) =>
      _serialCtrls.putIfAbsent(lineKey, () => TextEditingController());

  @override
  void dispose() {
    for (final c in _serialCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// Re-validate every line's serials together: drop blanks, reject too-short
  /// junk (e.g. "123"), de-dupe across the whole bill, and block any serial
  /// already sold (uniqueness). Each line's valid set is stored against its
  /// lineKey so it links to that exact product at checkout.
  void _syncSerials() {
    final soldNos = (ref.read(serialsProvider).asData?.value ?? const [])
        .where((s) => s['status'] == 'sold')
        .map((s) => s['serial_no'].toString())
        .toSet();
    final seen = <String>{};
    final byLine = <String, List<String>>{};
    String? err;
    _serialCtrls.forEach((lineKey, ctrl) {
      final parts = ctrl.text
          .split(RegExp(r'[\n,]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty);
      final valid = <String>[];
      for (final p in parts) {
        if (p.length < 6) {
          err = 'Serial / IMEI "$p" looks too short';
          continue;
        }
        if (!seen.add(p)) {
          err = 'Duplicate serial "$p"';
          continue;
        }
        if (soldNos.contains(p)) {
          err = 'Serial "$p" was already sold';
          continue;
        }
        valid.add(p);
      }
      if (valid.isNotEmpty) byLine[lineKey] = valid;
    });
    widget.links.serialsByLine = byLine;
    setState(() => _serialError = err);
    widget.onChanged();
  }

  Future<void> _scanSerial(String lineKey) async {
    final scanned = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerOverlay()),
    );
    if (scanned == null || scanned.trim().isEmpty) return;
    final ctrl = _ctrlFor(lineKey);
    final existing = ctrl.text.trim();
    ctrl.text = existing.isEmpty
        ? scanned.trim()
        : '$existing\n${scanned.trim()}';
    _syncSerials();
  }

  @override
  Widget build(BuildContext context) {
    final vc = verticalConfigOf(ref);
    // Only serial-tracked verticals (e.g. electronics) capture IMEI/serial at
    // checkout. Warranty-only verticals like optical track warranty by purchase
    // date, not a device serial — so they must NOT show this block (tester #10).
    final hasSerial = vc.has('serial');
    final hasAppointments = vc.has('appointments');
    // Job cards apply to alteration/repair/preorder verticals.
    final hasJobs =
        vc.has('warranty') || vc.has('appointments') || vc.has('variants');

    final blocks = <Widget>[];

    if (hasSerial) {
      // Tester #4 — capture IMEI(s) per cart line so each links to its phone.
      final cart = ref.watch(posProvider).cart;
      if (cart.isNotEmpty) {
        blocks.add(
          _block(
            icon: Icons.qr_code_2_rounded,
            title: 'Serial / IMEI per item',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in cart) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 2),
                    child: Text(
                      '${line.product.name}'
                      '${line.variantLabel != null && line.variantLabel!.isNotEmpty ? ' · ${line.variantLabel}' : ''}'
                      '  ·  qty ${line.quantity.toStringAsFixed(line.quantity % 1 == 0 ? 0 : 2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: BrandColors.ink,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ctrlFor(line.lineKey),
                          minLines: 1,
                          maxLines: 3,
                          onChanged: (_) => _syncSerials(),
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: 'Scan or type IMEI(s) — comma / new line',
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Scan',
                        icon: const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: BrandColors.primary,
                        ),
                        onPressed: () => _scanSerial(line.lineKey),
                      ),
                    ],
                  ),
                ],
                if (_serialError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      _serialError!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: BrandColors.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    }

    if (hasAppointments) {
      final today = DateTime.now();
      final day =
          '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final appts = ref.watch(appointmentsProvider(day)).asData?.value ?? [];
      final booked = appts.where((a) => a.status == 'booked').toList();
      if (booked.isNotEmpty) {
        final selectedAppt = booked
            .where((a) => a.appointmentId == widget.links.appointmentId)
            .firstOrNull;
        blocks.add(
          _block(
            icon: Icons.event_available_rounded,
            title: 'Bill an appointment',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<int?>(
                  isExpanded: true,
                  value: widget.links.appointmentId,
                  underline: const SizedBox.shrink(),
                  hint: const Text('Select appointment'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None')),
                    ...booked.map(
                      (a) => DropdownMenuItem(
                        value: a.appointmentId,
                        child: Text(
                          '${a.displayName} · ${a.serviceName ?? 'Service'}'
                          '${a.price != null ? ' · ₹${a.price!.toStringAsFixed(0)}' : ''}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    final appt = booked
                        .where((a) => a.appointmentId == v)
                        .firstOrNull;
                    setState(() {
                      widget.links.appointmentId = v;
                      widget.links.appointmentCharge = appt?.price ?? 0;
                    });
                    widget.onChanged();
                  },
                ),
                if (selectedAppt?.price != null && selectedAppt!.price! > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+ ₹${selectedAppt.price!.toStringAsFixed(0)} added to the bill',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: BrandColors.success,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }

      if (widget.customerId != null) {
        final memberships =
            ref.watch(_membershipsProvider(widget.customerId!)).asData?.value ??
            [];
        final usable = memberships.where((m) => m.remaining != 0).toList();
        if (usable.isNotEmpty) {
          final m = usable.first;
          blocks.add(
            _block(
              icon: Icons.card_membership_rounded,
              title: 'Use a membership session',
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: widget.links.membershipId == m.membershipId,
                onChanged: (v) {
                  setState(
                    () => widget.links.membershipId = v == true
                        ? m.membershipId
                        : null,
                  );
                  widget.onChanged();
                },
                title: Text(
                  m.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  m.remaining < 0
                      ? 'Unlimited'
                      : '${m.remaining} sessions left',
                  style: const TextStyle(
                    fontSize: 11,
                    color: BrandColors.muted,
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

    if (hasJobs) {
      final jobs = ref.watch(_openJobCardsProvider).asData?.value ?? [];
      if (jobs.isNotEmpty) {
        blocks.add(
          _block(
            icon: Icons.build_circle_rounded,
            title: 'Bill a job card',
            child: DropdownButton<int?>(
              isExpanded: true,
              value: widget.links.jobCardId,
              underline: const SizedBox.shrink(),
              hint: const Text('Select job card'),
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                ...jobs.map(
                  (j) => DropdownMenuItem(
                    value: j['job_id'] as int?,
                    child: Text(
                      '${j['item_desc'] ?? j['job_type'] ?? 'Job'} · ${j['customer_name'] ?? ''}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: (v) {
                setState(() => widget.links.jobCardId = v);
                widget.onChanged();
              },
            ),
          ),
        );
      }
    }

    if (blocks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Link to this sale',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: BrandColors.ink,
          ),
        ),
        const SizedBox(height: 10),
        ...blocks,
      ],
    );
  }

  Widget _block({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: BrandColors.surfaceTint,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: BrandColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: BrandColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}
