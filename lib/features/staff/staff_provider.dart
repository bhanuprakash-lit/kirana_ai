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
  const StaffTask({
    required this.taskId,
    required this.title,
    this.staffName,
    this.isDone = false,
  });
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
  return l
      .whereType<Map>()
      .map((e) => StaffMember.fromJson(e.cast<String, dynamic>()))
      .toList();
});

final staffTasksProvider = FutureProvider<List<StaffTask>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/staff/tasks');
  final l = (d is Map ? d['tasks'] : null) as List<dynamic>? ?? [];
  return l
      .whereType<Map>()
      .map((e) => StaffTask.fromJson(e.cast<String, dynamic>()))
      .toList();
});

/// {staffId: status} for the given date ("present"/"absent"/"half_day"/null).
final staffAttendanceProvider =
    FutureProvider.family<Map<int, String?>, String>((ref, date) async {
      ref.watch(storeScopeProvider);
      final d = await ref
          .read(apiClientProvider)
          .get('/kirana/staff/attendance?date=$date');
      final l = (d is Map ? d['attendance'] : null) as List<dynamic>? ?? [];
      return {
        for (final e in l.whereType<Map>())
          (e['staff_id'] as num).toInt(): e['status'] as String?,
      };
    });

/// Sales + commission for one staff member over the recent window.
class StaffSales {
  final int staffId;
  final double revenue;
  final int orders;
  final double commission;
  const StaffSales({
    required this.staffId,
    required this.revenue,
    required this.orders,
    required this.commission,
  });
  factory StaffSales.fromJson(Map<String, dynamic> j) => StaffSales(
    staffId: (j['staff_id'] as num).toInt(),
    revenue: (j['revenue'] as num?)?.toDouble() ?? 0,
    orders: (j['orders'] as num?)?.toInt() ?? 0,
    commission: (j['commission'] as num?)?.toDouble() ?? 0,
  );
}

/// {staffId: StaffSales} for the last 30 days.
final staffSalesProvider = FutureProvider<Map<int, StaffSales>>((ref) async {
  ref.watch(storeScopeProvider);
  final d = await ref
      .read(apiClientProvider)
      .get('/kirana/staff/sales?days=30');
  final l = (d is Map ? d['staff'] : null) as List<dynamic>? ?? [];
  return {
    for (final e in l.whereType<Map>())
      (e['staff_id'] as num).toInt(): StaffSales.fromJson(
        e.cast<String, dynamic>(),
      ),
  };
});

class StaffActions {
  StaffActions(this.ref);
  final Ref ref;
  ApiClient get _c => ref.read(apiClientProvider);

  Future<void> addStaff(Map<String, dynamic> body) async {
    await _c.post('/kirana/staff', body);
    ref.invalidate(staffListProvider);
  }

  Future<void> updateStaff(int staffId, Map<String, dynamic> body) async {
    await _c.patch('/kirana/staff/$staffId', body);
    ref.invalidate(staffListProvider);
    ref.invalidate(staffSalesProvider);
  }

  Future<void> deleteTask(int taskId) async {
    await _c.delete('/kirana/staff/tasks/$taskId');
    ref.invalidate(staffTasksProvider);
  }

  Future<void> markAttendance(int staffId, String date, String status) async {
    await _c.post('/kirana/staff/attendance', {
      'staff_id': staffId,
      'date': date,
      'status': status,
    });
    ref.invalidate(staffAttendanceProvider(date));
    ref.invalidate(staffAttendanceHistoryProvider(staffId));
  }

  Future<void> addTask(String title, {int? staffId}) async {
    await _c.post('/kirana/staff/tasks', {
      'title': title,
      'staff_id': ?staffId,
    });
    ref.invalidate(staffTasksProvider);
  }

  Future<void> setTaskDone(int taskId, bool done) async {
    await _c.patch('/kirana/staff/tasks/$taskId', {'is_done': done});
    ref.invalidate(staffTasksProvider);
  }
}

class AttendanceDay {
  final String date;
  final String? status;
  const AttendanceDay({required this.date, this.status});
}

class AttendanceHistory {
  final List<AttendanceDay> days;
  final int present;
  final int absent;
  final int halfDay;
  const AttendanceHistory({
    required this.days,
    this.present = 0,
    this.absent = 0,
    this.halfDay = 0,
  });
}

/// Last [days] days of attendance + counts for a single staff member.
final staffAttendanceHistoryProvider =
    FutureProvider.family<AttendanceHistory, int>((ref, staffId) async {
      ref.watch(storeScopeProvider);
      final d = await ref
          .read(apiClientProvider)
          .get('/kirana/staff/$staffId/attendance/history?days=30');
      final hist = (d is Map ? d['history'] : null) as List<dynamic>? ?? [];
      final counts = (d is Map ? d['counts'] : null) as Map? ?? {};
      return AttendanceHistory(
        days: hist
            .whereType<Map>()
            .map(
              (e) => AttendanceDay(
                date: (e['att_date'] ?? '').toString(),
                status: e['status'] as String?,
              ),
            )
            .toList(),
        present: (counts['present'] as num?)?.toInt() ?? 0,
        absent: (counts['absent'] as num?)?.toInt() ?? 0,
        halfDay: (counts['half_day'] as num?)?.toInt() ?? 0,
      );
    });

final staffActionsProvider = Provider<StaffActions>(StaffActions.new);
