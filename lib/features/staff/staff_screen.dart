import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/brand_theme.dart';
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
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text('Staff'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Team & Attendance'),
            Tab(text: 'Tasks'),
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
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No staff yet. Add your team.',
                      style: TextStyle(color: BrandColors.muted),
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
            label: const Text('Add staff'),
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
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No tasks. Add a daily checklist item.',
                      style: TextStyle(color: BrandColors.muted),
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                  children: list
                      .map(
                        (t) => CheckboxListTile(
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
                              ? Text(t.staffName!)
                              : null,
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
            label: const Text('Add task'),
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
              decoration: const InputDecoration(
                labelText: 'Assign to (optional)',
              ),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Unassigned'),
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
                  '${member.commissionPct.toStringAsFixed(0)}% comm',
                  style: const TextStyle(
                    fontSize: 11,
                    color: BrandColors.muted,
                  ),
                ),
            ],
          ),
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
                          ? const Center(
                              child: Text('No attendance recorded yet.'),
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
