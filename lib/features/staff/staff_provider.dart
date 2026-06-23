import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/store/store_scope.dart';

/// Module M5 — Staff Operations providers + lightweight models.

class StaffMember {
  final int staffId;
  final String name;
  final String? phone;
  final String? role;
  final double commissionPct;
  final bool isActive;
  const StaffMember({
    required this.staffId,
    required this.name,
    this.phone,
    this.role,
    this.commissionPct = 0,
    this.isActive = true,
  });
  factory StaffMember.fromJson(Map<String, dynamic> j) => StaffMember(
        staffId: (j['staff_id'] as num).toInt(),
        name: (j['name'] ?? '').toString(),
        phone: j['phone'] as String?,
        role: j['role'] as String?,
        commissionPct: (j['commission_pct'] as num?)?.toDouble() ?? 0,
        isActive: j['is_active'] != false,
      );
}

class StaffTask {
  final int taskId;
  final String title;
  final String? staffName;
  final bool isDone;
  const StaffTask(
      {required this.taskId, required this.title, this.staffName, this.isDone = false});
  factory StaffTask.fromJson(Map<String, dynamic> j) => StaffTask(
        taskId: (j['task_id'] as num).toInt(),
        title: (j['title'] ?? '').toString(),
        staffName: j['staff_name'] as String?,
        isDone: j['is_done'] == true,
      );
}

final staffListProvider = FutureProvider<List<StaffMember>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/staff');
  final l = (d is Map ? d['staff'] : null) as List<dynamic>? ?? [];
  return l.whereType<Map>().map((e) => StaffMember.fromJson(e.cast<String, dynamic>())).toList();
});

final staffTasksProvider = FutureProvider<List<StaffTask>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/staff/tasks');
  final l = (d is Map ? d['tasks'] : null) as List<dynamic>? ?? [];
  return l.whereType<Map>().map((e) => StaffTask.fromJson(e.cast<String, dynamic>())).toList();
});

class StaffActions {
  StaffActions(this.ref);
  final Ref ref;
  ApiClient get _c => ref.read(apiClientProvider);

  Future<void> addStaff(Map<String, dynamic> body) async {
    await _c.post('/kirana/staff', body);
    ref.invalidate(staffListProvider);
  }

  Future<void> markAttendance(int staffId, String date, String status) async {
    await _c.post('/kirana/staff/attendance',
        {'staff_id': staffId, 'date': date, 'status': status});
  }

  Future<void> addTask(String title) async {
    await _c.post('/kirana/staff/tasks', {'title': title});
    ref.invalidate(staffTasksProvider);
  }

  Future<void> setTaskDone(int taskId, bool done) async {
    await _c.patch('/kirana/staff/tasks/$taskId', {'is_done': done});
    ref.invalidate(staffTasksProvider);
  }
}

final staffActionsProvider = Provider<StaffActions>(StaffActions.new);
