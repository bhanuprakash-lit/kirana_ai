/// Module M4 — Services & Appointments models.
library;

double _d(dynamic v, [double def = 0]) =>
    v == null ? def : (v is num ? v.toDouble() : double.tryParse('$v') ?? def);
int _i(dynamic v, [int def = 0]) =>
    v == null ? def : (v is num ? v.toInt() : int.tryParse('$v') ?? def);

class ServiceItem {
  final int serviceId;
  final String name;
  final double price;
  final int durationMin;
  final String? category;
  final bool isActive;

  const ServiceItem({
    required this.serviceId,
    required this.name,
    required this.price,
    required this.durationMin,
    this.category,
    this.isActive = true,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> j) => ServiceItem(
        serviceId: _i(j['service_id']),
        name: (j['name'] ?? '').toString(),
        price: _d(j['price']),
        durationMin: _i(j['duration_min'], 30),
        category: j['category'] as String?,
        isActive: j['is_active'] != false,
      );
}

class Appointment {
  final int appointmentId;
  final int? customerId;
  final int? serviceId;
  final String displayName; // customer name (linked or free-text)
  final String? customerPhone;
  final String? serviceName;
  final DateTime startsAt;
  final int durationMin;
  final String status; // booked | completed | cancelled | no_show
  final double? price;
  final String? notes;

  const Appointment({
    required this.appointmentId,
    this.customerId,
    this.serviceId,
    required this.displayName,
    this.customerPhone,
    this.serviceName,
    required this.startsAt,
    required this.durationMin,
    required this.status,
    this.price,
    this.notes,
  });

  factory Appointment.fromJson(Map<String, dynamic> j) => Appointment(
        appointmentId: _i(j['appointment_id']),
        customerId: j['customer_id'] == null ? null : _i(j['customer_id']),
        serviceId: j['service_id'] == null ? null : _i(j['service_id']),
        displayName:
            (j['display_name'] ?? j['customer_name'] ?? 'Walk-in').toString(),
        customerPhone: j['customer_phone'] as String?,
        serviceName: j['service_name'] as String?,
        startsAt: DateTime.tryParse(j['starts_at'].toString())?.toLocal() ??
            DateTime.now(),
        durationMin: _i(j['duration_min'], 30),
        status: (j['status'] ?? 'booked').toString(),
        price: j['price'] == null ? null : _d(j['price']),
        notes: j['notes'] as String?,
      );
}

class Membership {
  final int membershipId;
  final int customerId;
  final String? customerName;
  final String name;
  final int totalSessions;
  final int usedSessions;
  final double price;
  final bool isActive;

  const Membership({
    required this.membershipId,
    required this.customerId,
    this.customerName,
    required this.name,
    required this.totalSessions,
    required this.usedSessions,
    required this.price,
    this.isActive = true,
  });

  int get remaining =>
      totalSessions > 0 ? (totalSessions - usedSessions).clamp(0, totalSessions) : -1;

  factory Membership.fromJson(Map<String, dynamic> j) => Membership(
        membershipId: _i(j['membership_id']),
        customerId: _i(j['customer_id']),
        customerName: j['customer_name'] as String?,
        name: (j['name'] ?? '').toString(),
        totalSessions: _i(j['total_sessions']),
        usedSessions: _i(j['used_sessions']),
        price: _d(j['price']),
        isActive: j['is_active'] != false,
      );
}
