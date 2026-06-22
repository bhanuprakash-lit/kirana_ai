import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../core/vertical/vertical_config_provider.dart';
import '../../../services/models/service_models.dart';
import '../../../services/providers/service_provider.dart';

/// What the shopkeeper linked to this sale at checkout (POS deep-links).
/// All optional — the backend best-effort applies whatever is set:
///   M7 serials sold, M4 appointment completed + membership session used,
///   M9 job card billed.
class PosDeepLinks {
  List<String> serials;
  int? membershipId;
  int? appointmentId;
  int? jobCardId;
  PosDeepLinks({
    List<String>? serials,
    this.membershipId,
    this.appointmentId,
    this.jobCardId,
  }) : serials = serials ?? [];

  bool get isEmpty =>
      serials.isEmpty &&
      membershipId == null &&
      appointmentId == null &&
      jobCardId == null;
}

/// Open job cards (ready to bill) for the store.
final _openJobCardsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final data = await ref.read(apiClientProvider).get('/kirana/job-cards?status=ready');
  final list = (data is Map ? data['job_cards'] : data) as List<dynamic>? ?? [];
  return list.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
});

/// Active memberships for a customer (for the "use a session" toggle).
final _membershipsProvider =
    FutureProvider.autoDispose.family<List<Membership>, int>((ref, customerId) async {
  final data = await ref
      .read(apiClientProvider)
      .get('/kirana/memberships?customer_id=$customerId');
  final list = (data is Map ? data['memberships'] : null) as List<dynamic>? ?? [];
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
  final _serialCtrl = TextEditingController();

  @override
  void dispose() {
    _serialCtrl.dispose();
    super.dispose();
  }

  void _syncSerials(String raw) {
    widget.links.serials = raw
        .split(RegExp(r'[\n,]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final vc = verticalConfigOf(ref);
    final hasSerial = vc.has('serial') || vc.has('warranty');
    final hasAppointments = vc.has('appointments');
    // Job cards apply to alteration/repair/preorder verticals.
    final hasJobs = vc.has('warranty') || vc.has('appointments') || vc.has('variants');

    final blocks = <Widget>[];

    if (hasSerial) {
      blocks.add(_block(
        icon: Icons.qr_code_2_rounded,
        title: 'Serial / IMEI sold',
        child: TextField(
          controller: _serialCtrl,
          minLines: 1,
          maxLines: 3,
          onChanged: _syncSerials,
          decoration: const InputDecoration(
            isDense: true,
            hintText: 'Scan or type serials (comma / new line)',
          ),
        ),
      ));
    }

    if (hasAppointments) {
      final today = DateTime.now();
      final day =
          '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final appts = ref.watch(appointmentsProvider(day)).asData?.value ?? [];
      final booked = appts.where((a) => a.status == 'booked').toList();
      if (booked.isNotEmpty) {
        blocks.add(_block(
          icon: Icons.event_available_rounded,
          title: 'Bill an appointment',
          child: DropdownButton<int?>(
            isExpanded: true,
            value: widget.links.appointmentId,
            underline: const SizedBox.shrink(),
            hint: const Text('Select appointment'),
            items: [
              const DropdownMenuItem(value: null, child: Text('None')),
              ...booked.map((a) => DropdownMenuItem(
                    value: a.appointmentId,
                    child: Text(
                      '${a.displayName} · ${a.serviceName ?? 'Service'}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
            ],
            onChanged: (v) {
              setState(() => widget.links.appointmentId = v);
              widget.onChanged();
            },
          ),
        ));
      }

      if (widget.customerId != null) {
        final memberships =
            ref.watch(_membershipsProvider(widget.customerId!)).asData?.value ?? [];
        final usable = memberships.where((m) => m.remaining != 0).toList();
        if (usable.isNotEmpty) {
          final m = usable.first;
          blocks.add(_block(
            icon: Icons.card_membership_rounded,
            title: 'Use a membership session',
            child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: widget.links.membershipId == m.membershipId,
              onChanged: (v) {
                setState(() =>
                    widget.links.membershipId = v == true ? m.membershipId : null);
                widget.onChanged();
              },
              title: Text(m.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              subtitle: Text(
                m.remaining < 0 ? 'Unlimited' : '${m.remaining} sessions left',
                style: const TextStyle(fontSize: 11, color: BrandColors.muted),
              ),
            ),
          ));
        }
      }
    }

    if (hasJobs) {
      final jobs = ref.watch(_openJobCardsProvider).asData?.value ?? [];
      if (jobs.isNotEmpty) {
        blocks.add(_block(
          icon: Icons.build_circle_rounded,
          title: 'Bill a job card',
          child: DropdownButton<int?>(
            isExpanded: true,
            value: widget.links.jobCardId,
            underline: const SizedBox.shrink(),
            hint: const Text('Select job card'),
            items: [
              const DropdownMenuItem(value: null, child: Text('None')),
              ...jobs.map((j) => DropdownMenuItem(
                    value: j['job_id'] as int?,
                    child: Text(
                      '${j['item_desc'] ?? j['job_type'] ?? 'Job'} · ${j['customer_name'] ?? ''}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
            ],
            onChanged: (v) {
              setState(() => widget.links.jobCardId = v);
              widget.onChanged();
            },
          ),
        ));
      }
    }

    if (blocks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Link to this sale',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: BrandColors.ink),
        ),
        const SizedBox(height: 10),
        ...blocks,
      ],
    );
  }

  Widget _block({required IconData icon, required String title, required Widget child}) {
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
              Text(title,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700, color: BrandColors.muted)),
            ],
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}
