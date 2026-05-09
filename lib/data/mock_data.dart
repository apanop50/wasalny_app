import '../models/booking.dart';
import '../models/route.dart' as app_route;

class MockData {
  static List<app_route.Route> routes = [
    app_route.Route(id: 'rs1', start: 'October', end: 'Maadi', time: '5:00 PM', cost: 40, transfers: 0, transport_type: 'ride_share', driver_name: 'Ahmed', driver_rating: 4.8, car_model: 'Hyundai Elantra', available_seats: 2, total_seats: 4),
    app_route.Route(id: 'rs2', start: 'October', end: 'Maadi', time: '5:30 PM', cost: 35, transfers: 0, transport_type: 'ride_share', driver_name: 'Mona', driver_rating: 4.9, car_model: 'Kia Cerato', available_seats: 3, total_seats: 4, female_only: true),
    app_route.Route(id: 'rs3', start: 'October', end: 'Maadi', time: '6:00 PM', cost: 45, transfers: 0, transport_type: 'ride_share', driver_name: 'Youssef', driver_rating: 4.7, car_model: 'Toyota Corolla', available_seats: 1, total_seats: 4),
    app_route.Route(id: 'r1', start: '6 October', end: 'Maadi', time: '40 min', cost: 20, transfers: 2, transport_type: 'microbus', driver_name: 'Microbus', driver_rating: 4.8, car_model: 'Public microbus', available_seats: 8, total_seats: 14),
    app_route.Route(id: 'r2', start: '6 October', end: 'Maadi', time: '55 min', cost: 10, transfers: 1, transport_type: 'bus', driver_name: 'Bus', driver_rating: 4.5, car_model: 'Public bus', available_seats: 20, total_seats: 40),
    app_route.Route(id: 'r3', start: '6 October', end: 'Maadi', time: '35 min', cost: 60, transfers: 0, transport_type: 'ride_share', driver_name: 'Ahmed', driver_rating: 4.8, car_model: 'Hyundai Elantra', available_seats: 2, total_seats: 4),
    app_route.Route(id: 'r4', start: 'Sheikh Zayed', end: 'Dokki', time: '30 min', cost: 50, transfers: 0, transport_type: 'ride_share', driver_name: 'Omar', driver_rating: 4.6, car_model: 'Nissan Sunny', available_seats: 2, total_seats: 4),
    app_route.Route(id: 'r5', start: 'Nasr City', end: 'Mohandessin', time: '45 min', cost: 30, transfers: 1, transport_type: 'microbus', driver_name: 'Sara', driver_rating: 4.9, car_model: 'Hyundai Accent', available_seats: 3, total_seats: 4, female_only: true),
  ];

  static List<Booking> bookings = [
    Booking(id: 'b1', user_id: 'u1', route_id: 'r1', status: 'booked', payment_status: 'paid', start: '6 October', end: 'Maadi', time: '5:00 PM', cost: 40, created_at: DateTime.now()),
    Booking(id: 'b2', user_id: 'u1', route_id: 'r2', status: 'booked', payment_status: 'pending', start: '6 October', end: 'Maadi', time: '5:30 PM', cost: 35, created_at: DateTime.now()),
  ];

  static List<String> areas = ['October', '6 October', 'Maadi', 'Nasr City', 'Sheikh Zayed', 'Dokki', 'Mohandessin', 'Heliopolis', 'New Cairo', 'Zamalek', 'Downtown', 'Giza'];
}