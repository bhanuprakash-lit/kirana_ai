import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/brand_theme.dart';
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
        bottom: TabBar(controller: _tabs, tabs: const [
          Tab(text: 'Team & Attendance'),
          Tab(text: 'Tasks'),
        ]),
      ),
      body: TabBarView(controller: _tabs, children: [_team(), _tasks()]),
    );
  }

  Widget _team() {
    final async = ref.watch(staffListProvider);
    return Stack(children: [
      async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => list.isEmpty
            ? const Center(
                child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No staff yet. Add your team.',
                        style: TextStyle(color: BrandColors.muted))))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _StaffCard(member: list[i], today: _today),
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
    ]);
  }

  Widget _tasks() {
    final async = ref.watch(staffTasksProvider);
    return Stack(children: [
      async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => list.isEmpty
            ? const Center(
                child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No tasks. Add a daily checklist item.',
                        style: TextStyle(color: BrandColors.muted))))
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                children: list
                    .map((t) => CheckboxListTile(
                          value: t.isDone,
                          onChanged: (v) => ref
                              .read(staffActionsProvider)
                              .setTaskDone(t.taskId, v ?? false),
                          title: Text(t.title,
                              style: TextStyle(
                                  decoration: t.isDone
                                      ? TextDecoration.lineThrough
                                      : null)),
                          subtitle:
                              t.staffName != null ? Text(t.staffName!) : null,
                        ))
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
    ]);
  }

  void _addStaff() {
    final name = TextEditingController();
    final phone = TextEditingController();
    final role = TextEditingController();
    _sheet('Add staff', [
      _field(name, 'Name'),
      _field(phone, 'Phone (optional)'),
      _field(role, 'Role (optional)'),
    ], () async {
      if (name.text.trim().isEmpty) return false;
      await ref.read(staffActionsProvider).addStaff({
        'name': name.text.trim(),
        if (phone.text.trim().isNotEmpty) 'phone': phone.text.trim(),
        if (role.text.trim().isNotEmpty) 'role': role.text.trim(),
      });
      return true;
    });
  }

  void _addTask() {
    final title = TextEditingController();
    _sheet('Add task', [_field(title, 'Task')], () async {
      if (title.text.trim().isEmpty) return false;
      await ref.read(staffActionsProvider).addTask(title.text.trim());
      return true;
    });
  }

  Widget _field(TextEditingController c, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
            controller: c, decoration: InputDecoration(labelText: label)),
      );

  void _sheet(String title, List<Widget> fields, Future<bool> Function() onSave) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
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
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            ...fields,
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () async {
                  if (await onSave() && ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _StaffCard extends ConsumerWidget {
  final StaffMember member;
  final String today;
  const _StaffCard({required this.member, required this.today});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(member.name,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              if (member.role != null)
                Text(member.role!,
                    style: const TextStyle(
                        fontSize: 12, color: BrandColors.muted)),
            ]),
          ),
          if (member.commissionPct > 0)
            Text('${member.commissionPct.toStringAsFixed(0)}% comm',
                style: const TextStyle(fontSize: 11, color: BrandColors.muted)),
        ]),
        const Divider(height: 18),
        Row(children: [
          const Text('Today: ',
              style: TextStyle(fontSize: 12, color: BrandColors.muted)),
          ...['present', 'absent', 'half_day'].map((st) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionChip(
                  label: Text(st.replaceAll('_', ' '),
                      style: const TextStyle(fontSize: 11)),
                  onPressed: () async {
                    await ref
                        .read(staffActionsProvider)
                        .markAttendance(member.staffId, today, st);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${member.name}: $st'),
                          duration: const Duration(seconds: 1)));
                    }
                  },
                ),
              )),
        ]),
      ]),
    );
  }
}
