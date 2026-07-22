import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/brand_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/action_widgets.dart';
import 'staff_provider.dart';

class StaffScreen extends ConsumerStatefulWidget {
  const StaffScreen({super.key});
  @override
  ConsumerState<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends ConsumerState<StaffScreen>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 2, vsync: this);
  String get _today {
    final d = DateTime.now();
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(l10n.staffTitle),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.staffTeamTab),
            Tab(text: l10n.staffTasksTab),
          ],
        ),
      ),
      body: TabBarView(controller: _tabs, children: [_team(), _tasks()]),
    );
  }

  Widget _team() {
    final async = ref.watch(staffListProvider);
    final attendanceToday = ref
        .watch(staffAttendanceProvider(_today))
        .asData
        ?.value;
    return Stack(
      children: [
        async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => list.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      AppLocalizations.of(context).staffNoStaff,
                      style: const TextStyle(color: BrandColors.muted),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                  itemCount: list.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    if (i == 0) {
                      return _AttendanceSummaryBar(
                        statuses: attendanceToday?.values.toList() ?? const [],
                      );
                    }
                    return _StaffCard(member: list[i - 1], today: _today);
                  },
                ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'addStaff',
            onPressed: _addStaff,
            icon: const Icon(Icons.person_add_alt_1),
            label: Text(AppLocalizations.of(context).staffAddStaff),
          ),
        ),
      ],
    );
  }

  Widget _tasks() {
    final async = ref.watch(staffTasksProvider);
    return Stack(
      children: [
        async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => list.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      AppLocalizations.of(context).staffNoTasks,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: BrandColors.muted),
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                  children: list
                      .map(
                        (t) => Dismissible(
                          key: ValueKey('task_${t.taskId}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: BrandColors.error.withValues(alpha: 0.12),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: BrandColors.error,
                            ),
                          ),
                          onDismissed: (_) => ref
                              .read(staffActionsProvider)
                              .deleteTask(t.taskId),
                          child: CheckboxListTile(
                            value: t.isDone,
                            onChanged: (v) => ref
                                .read(staffActionsProvider)
                                .setTaskDone(t.taskId, v ?? false),
                            title: Text(
                              t.title,
                              style: TextStyle(
                                decoration: t.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: t.staffName != null
                                ? Text(
                                    '${AppLocalizations.of(context).staffAssignedTo} ${t.staffName}',
                                  )
                                : null,
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'addTask',
            onPressed: _addTask,
            icon: const Icon(Icons.add_task),
            label: Text(AppLocalizations.of(context).staffAddTask),
          ),
        ),
      ],
    );
  }

  void _addStaff() {
    final name = TextEditingController();
    final phone = TextEditingController();
    final role = TextEditingController();
    _sheet(
      'Add staff',
      [
        _field(name, 'Name'),
        _field(
          phone,
          'Phone (optional)',
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 10,
        ),
        _field(role, 'Role (optional)'),
      ],
      () async {
        if (name.text.trim().isEmpty) return 'Name is required';
        final ph = phone.text.trim();
        if (ph.isNotEmpty && ph.length != 10) {
          return 'Phone number must be 10 digits';
        }
        try {
          await ref.read(staffActionsProvider).addStaff({
            'name': name.text.trim(),
            if (ph.isNotEmpty) 'phone': ph,
            if (role.text.trim().isNotEmpty) 'role': role.text.trim(),
          });
          return null;
        } catch (e) {
          return e.toString();
        }
      },
    );
  }

  void _addTask() {
    final title = TextEditingController();
    final staff = ref.read(staffListProvider).asData?.value ?? [];
    int? selectedStaffId;
    _sheet(
      'Add task',
      [
        _field(title, 'Task'),
        if (staff.isNotEmpty)
          StatefulBuilder(
            builder: (ctx, setState) => DropdownButtonFormField<int?>(
              initialValue: selectedStaffId,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).stfAssignTo,
              ),
              items: [
                DropdownMenuItem<int?>(
                  value: null,
                  child: Text(AppLocalizations.of(context).stfUnassigned),
                ),
                ...staff.map(
                  (m) => DropdownMenuItem<int?>(
                    value: m.staffId,
                    child: Text(m.name),
                  ),
                ),
              ],
              onChanged: (v) => setState(() => selectedStaffId = v),
            ),
          ),
      ],
      () async {
        if (title.text.trim().isEmpty) return 'Task title is required';
        try {
          await ref
              .read(staffActionsProvider)
              .addTask(title.text.trim(), staffId: selectedStaffId);
          return null;
        } catch (e) {
          return e.toString();
        }
      },
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      decoration: InputDecoration(labelText: label, counterText: ''),
    ),
  );

  /// [onSave] returns an error message on failure, or null on success.
  void _sheet(
    String title,
    List<Widget> fields,
    Future<String?> Function() onSave,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        bool saving = false;
        String? error;
        return StatefulBuilder(
          builder: (ctx, setState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              left: 20,
              right: 20,
              top: 16,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...fields,
                  if (error != null) ...[
                    ActionStatusOverlay(error: error),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: LoadingButton(
                      label: 'Save',
                      isLoading: saving,
                      onPressed: () async {
                        setState(() {
                          saving = true;
                          error = null;
                        });
                        final err = await onSave();
                        if (!ctx.mounted) return;
                        if (err == null) {
                          Navigator.pop(ctx);
                        } else {
                          setState(() {
                            saving = false;
                            error = err;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StaffCard extends ConsumerWidget {
  final StaffMember member;
  final String today;
  const _StaffCard({required this.member, required this.today});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendance = ref.watch(staffAttendanceProvider(today)).asData?.value;
    final currentStatus = attendance?[member.staffId];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    if (member.role != null)
                      Text(
                        member.role!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: BrandColors.muted,
                        ),
                      ),
                  ],
                ),
              ),
              if (member.commissionPct > 0)
                Text(
                  '${member.commissionPct.toStringAsFixed(0)}% ${AppLocalizations.of(context).staffComm}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: BrandColors.muted,
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                visualDensity: VisualDensity.compact,
                tooltip: AppLocalizations.of(context).staffEdit,
                onPressed: () => showStaffEditor(context, ref, member),
              ),
            ],
          ),
          _SalesLine(staffId: member.staffId),
          const Divider(height: 18),
          Row(
            children: [
              const Text(
                'Today: ',
                style: TextStyle(fontSize: 12, color: BrandColors.muted),
              ),
              ...['present', 'absent', 'half_day'].map((st) {
                final selected = currentStatus == st;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ActionChip(
                    label: Text(
                      st.replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 11,
                        color: selected ? Colors.white : null,
                        fontWeight: selected ? FontWeight.w700 : null,
                      ),
                    ),
                    backgroundColor: selected ? BrandColors.primary : null,
                    onPressed: () async {
                      await ref
                          .read(staffActionsProvider)
                          .markAttendance(member.staffId, today, st);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${member.name}: $st'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                );
              }),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.history, size: 18),
                tooltip: 'Attendance history',
                onPressed: () => _showHistory(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showHistory(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        expand: false,
        builder: (ctx, scrollController) => Consumer(
          builder: (ctx, ref, _) {
            final async = ref.watch(
              staffAttendanceHistoryProvider(member.staffId),
            );
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (h) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${member.name} — last 30 days',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _countChip('Present', h.present, Colors.green),
                        const SizedBox(width: 8),
                        _countChip('Absent', h.absent, Colors.red),
                        const SizedBox(width: 8),
                        _countChip('Half-day', h.halfDay, Colors.orange),
                      ],
                    ),
                    const Divider(height: 20),
                    Expanded(
                      child: h.days.isEmpty
                          ? Center(
                              child: Text(
                                AppLocalizations.of(context).stfNoAttendance,
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: h.days.length,
                              itemBuilder: (_, i) {
                                final d = h.days[i];
                                return ListTile(
                                  dense: true,
                                  title: Text(d.date),
                                  trailing: Text(
                                    (d.status ?? 'not marked').replaceAll(
                                      '_',
                                      ' ',
                                    ),
                                    style: TextStyle(
                                      color: d.status == null
                                          ? BrandColors.muted
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _countChip(String label, int count, Color color) => Chip(
    label: Text('$label: $count'),
    backgroundColor: color.withValues(alpha: 0.12),
    labelStyle: TextStyle(color: color, fontWeight: FontWeight.w700),
  );
}

class _AttendanceSummaryBar extends StatelessWidget {
  final List<String?> statuses;
  const _AttendanceSummaryBar({required this.statuses});

  @override
  Widget build(BuildContext context) {
    final present = statuses.where((s) => s == 'present').length;
    final absent = statuses.where((s) => s == 'absent').length;
    final halfDay = statuses.where((s) => s == 'half_day').length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: BrandColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text(
            'Today',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          _stat('Present', present, Colors.green),
          const SizedBox(width: 14),
          _stat('Absent', absent, Colors.red),
          const SizedBox(width: 14),
          _stat('Half-day', halfDay, Colors.orange),
        ],
      ),
    );
  }

  Widget _stat(String label, int count, Color color) => Row(
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      Text(
        '$count $label',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ],
  );
}

/// Per-member sales + commission over the last 30 days (from orders billed to
/// them). Renders nothing until there's at least one attributed sale.
class _SalesLine extends ConsumerWidget {
  final int staffId;
  const _SalesLine({required this.staffId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final s = ref.watch(staffSalesProvider).asData?.value[staffId];
    if (s == null || s.orders == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Icon(
            Icons.trending_up_rounded,
            size: 16,
            color: BrandColors.success,
          ),
          const SizedBox(width: 6),
          Text(
            '₹${s.revenue.toStringAsFixed(0)} · ${s.orders} ${l10n.staffOrders30d}',
            style: const TextStyle(fontSize: 12, color: BrandColors.ink),
          ),
          if (s.commission > 0) ...[
            const Spacer(),
            Text(
              '₹${s.commission.toStringAsFixed(0)} ${l10n.staffCommEarned}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: BrandColors.success,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Edit an existing staff member: name, phone, role, commission %, active.
void showStaffEditor(BuildContext context, WidgetRef ref, StaffMember member) {
  final name = TextEditingController(text: member.name);
  final phone = TextEditingController(text: member.phone ?? '');
  final role = TextEditingController(text: member.role ?? '');
  final commission = TextEditingController(
    text: member.commissionPct > 0
        ? member.commissionPct.toStringAsFixed(
            member.commissionPct.truncateToDouble() == member.commissionPct
                ? 0
                : 1,
          )
        : '',
  );
  bool active = member.isActive;
  bool saving = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx);
      return StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            left: 20,
            right: 20,
            top: 16,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.staffEditMember,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: name,
                  decoration: InputDecoration(labelText: l10n.staffName),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: l10n.staffPhoneOptional,
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: role,
                        decoration: InputDecoration(
                          labelText: l10n.staffRoleOptional,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: commission,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.staffCommissionField,
                          suffixText: '%',
                        ),
                      ),
                    ),
                  ],
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: active,
                  onChanged: (v) => setState(() => active = v),
                  title: Text(l10n.staffActive),
                  subtitle: Text(
                    l10n.staffActiveHint,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: saving
                        ? null
                        : () async {
                            if (name.text.trim().isEmpty) return;
                            setState(() => saving = true);
                            try {
                              await ref.read(staffActionsProvider).updateStaff(
                                member.staffId,
                                {
                                  'name': name.text.trim(),
                                  'phone': phone.text.trim().isEmpty
                                      ? null
                                      : phone.text.trim(),
                                  'role': role.text.trim().isEmpty
                                      ? null
                                      : role.text.trim(),
                                  'commission_pct':
                                      double.tryParse(commission.text.trim()) ??
                                      0,
                                  'is_active': active,
                                },
                              );
                              if (ctx.mounted) Navigator.pop(ctx);
                            } catch (_) {
                              setState(() => saving = false);
                            }
                          },
                    child: saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(l10n.staffSaveChanges),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
