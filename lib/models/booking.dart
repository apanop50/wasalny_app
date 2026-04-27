class Booking {
  String id;
  String user_id;
  String route_id;
  String status; // booked / cancelled
  String payment_status;

  // Optional joined route fields for UI display.
  String? start;
  String? end;
  String? time;
  double? cost;
  DateTime? created_at;

  Booking({
    required this.id,
    required this.user_id,
    required this.route_id,
    this.status = 'booked',
    this.payment_status = 'pending',
    this.start,
    this.end,
    this.time,
    this.cost,
    this.created_at,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'].toString(),
      user_id: json['user_id'].toString(),
      route_id: json['route_id'].toString(),
      status: json['status'] ?? 'booked',
      payment_status: json['payment_status'] ?? 'pending',
      start: json['start'] ?? json['route_start'],
      end: json['end'] ?? json['route_end'],
      time: json['time'] ?? json['route_time'],
      cost: (json['cost'] as num?)?.toDouble() ?? (json['route_cost'] as num?)?.toDouble(),
      created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'route_id': route_id,
      'status': status,
      'payment_status': payment_status,
      if (created_at != null) 'created_at': created_at!.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'user_id': user_id,
      'route_id': route_id,
    };
  }
}