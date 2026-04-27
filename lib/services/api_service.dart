import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking.dart';
import '../models/route.dart' as app_route;
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://your-api-domain.com/api';
  String? token;

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 200) return null;
    final data = jsonDecode(response.body);
    token = data['token'];
    return User.fromJson(data['user'] ?? data);
  }

  Future<User?> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: headers,
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) return null;
    final data = jsonDecode(response.body);
    token = data['token'];
    return User.fromJson(data['user'] ?? data);
  }

  Future<List<app_route.Route>> getRoutes({String? from, String? to}) async {
    final uri = Uri.parse('$baseUrl/routes').replace(queryParameters: {
      if (from != null && from.isNotEmpty) 'from': from,
      if (to != null && to.isNotEmpty) 'to': to,
    });
    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) return [];
    final data = jsonDecode(response.body);
    final list = data is List ? data : data['routes'] as List;
    return list.map((json) => app_route.Route.fromJson(json)).toList();
  }

  Future<Booking?> createBooking(String userId, String routeId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/booking'),
      headers: headers,
      body: jsonEncode({'user_id': userId, 'route_id': routeId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) return null;
    final data = jsonDecode(response.body);
    return Booking.fromJson(data['booking'] ?? data);
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/booking/$userId'), headers: headers);
    if (response.statusCode != 200) return [];
    final data = jsonDecode(response.body);
    final list = data is List ? data : data['bookings'] as List;
    return list.map((json) => Booking.fromJson(json)).toList();
  }
}