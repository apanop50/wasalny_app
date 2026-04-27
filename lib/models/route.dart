class Route {
  String id;
  String start;
  String end;
  String time;
  double cost;
  int transfers;
  String transport_type; // all / microbus / bus / ride_share

  // UI-only optional fields. Backend can ignore them.
  String? driver_name;
  double? driver_rating;
  String? car_model;
  int? available_seats;
  int? total_seats;
  bool female_only;
  String status;

  Route({
    required this.id,
    required this.start,
    required this.end,
    required this.time,
    required this.cost,
    required this.transfers,
    this.transport_type = 'ride_share',
    this.driver_name,
    this.driver_rating,
    this.car_model,
    this.available_seats,
    this.total_seats,
    this.female_only = false,
    this.status = 'available',
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'].toString(),
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      time: json['time'] ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0,
      transfers: (json['transfers'] as num?)?.toInt() ?? 0,
      transport_type: json['transport_type'] ?? json['type'] ?? 'ride_share',
      driver_name: json['driver_name'],
      driver_rating: (json['driver_rating'] as num?)?.toDouble(),
      car_model: json['car_model'],
      available_seats: (json['available_seats'] as num?)?.toInt(),
      total_seats: (json['total_seats'] as num?)?.toInt(),
      female_only: json['female_only'] ?? json['is_female_only'] ?? false,
      status: json['status'] ?? 'available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start': start,
      'end': end,
      'time': time,
      'cost': cost,
      'transfers': transfers,
      'transport_type': transport_type,
      if (driver_name != null) 'driver_name': driver_name,
      if (driver_rating != null) 'driver_rating': driver_rating,
      if (car_model != null) 'car_model': car_model,
      if (available_seats != null) 'available_seats': available_seats,
      if (total_seats != null) 'total_seats': total_seats,
      'female_only': female_only,
      'status': status,
    };
  }
}