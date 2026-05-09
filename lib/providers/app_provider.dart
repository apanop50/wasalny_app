import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/booking.dart';
import '../models/route.dart' as app_route;
import '../models/user.dart';
import '../services/api_service.dart';

class AppProvider extends ChangeNotifier {
  final ApiService api = ApiService();

  User? currentUser;
  int currentIndex = 0;
  bool isLoading = false;
  bool useMockData = true;

  List<app_route.Route> routes = List.from(MockData.routes);
  List<app_route.Route> filteredRoutes = List.from(MockData.routes);
  app_route.Route? selectedRoute;
  List<Booking> bookings = List.from(MockData.bookings);
  int walletBalance = 250;

  String from = 'October';
  String to = 'Maadi';
  String selectedTransport = 'ride_share';
  bool femaleOnly = false;
  double maxPrice = 100;

  void setIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<void> loginOrRegister({required String name, required String email, String? phone}) async {
    currentUser = User(id: 'u1', name: name, email: email, phone: phone);
    bookings = MockData.bookings.where((booking) => booking.user_id == currentUser!.id).toList();
    notifyListeners();
  }

  void setTransport(String type) {
    selectedTransport = type;
    notifyListeners();
  }

  void setRideFilters({bool? femaleOnly, double? maxPrice}) {
    this.femaleOnly = femaleOnly ?? this.femaleOnly;
    this.maxPrice = maxPrice ?? this.maxPrice;
    notifyListeners();
  }

  Future<void> searchRoutes({required String from, required String to, String? transport}) async {
    this.from = from;
    this.to = to;
    selectedTransport = transport ?? selectedTransport;
    isLoading = true;
    notifyListeners();

    if (useMockData) {
      final fromQuery = _normalize(from);
      final toQuery = _normalize(to);
      final matches = MockData.routes.where((route) {
        final matchFrom = from.isEmpty || _normalize(route.start).contains(fromQuery) || _nearScore(route.start, from) <= 1;
        final matchTo = to.isEmpty || _normalize(route.end).contains(toQuery) || _nearScore(route.end, to) <= 1;
        final matchType = selectedTransport == 'all' || route.transport_type == selectedTransport;
        final matchFemale = !femaleOnly || route.female_only;
        final matchPrice = route.cost <= maxPrice;
        return matchFrom && matchTo && matchType && matchFemale && matchPrice;
      }).toList()
        ..sort((a, b) {
          final scoreA = _nearScore(a.start, from) + _nearScore(a.end, to) + a.cost / 100;
          final scoreB = _nearScore(b.start, from) + _nearScore(b.end, to) + b.cost / 100;
          return scoreA.compareTo(scoreB);
        });
      filteredRoutes = matches.isEmpty
          ? (List<app_route.Route>.from(MockData.routes)..sort((a, b) => (_nearScore(a.start, from) + _nearScore(a.end, to)).compareTo(_nearScore(b.start, from) + _nearScore(b.end, to))))
          : matches;
    } else {
      filteredRoutes = await api.getRoutes(from: from, to: to);
    }

    isLoading = false;
    notifyListeners();
  }

  void selectRoute(app_route.Route route) {
    selectedRoute = route;
    notifyListeners();
  }

  Future<Booking?> bookSelectedRoute() async {
    if (currentUser == null || selectedRoute == null) return null;
    isLoading = true;
    notifyListeners();

    Booking? booking;
    if (useMockData) {
      booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        user_id: currentUser!.id,
        route_id: selectedRoute!.id,
        status: 'booked',
        payment_status: 'pending',
        start: selectedRoute!.start,
        end: selectedRoute!.end,
        time: selectedRoute!.time,
        cost: selectedRoute!.cost,
        created_at: DateTime.now(),
      );
      bookings.insert(0, booking);
    } else {
      booking = await api.createBooking(currentUser!.id, selectedRoute!.id);
      if (booking != null) bookings.insert(0, booking);
    }

    isLoading = false;
    notifyListeners();
    return booking;
  }

  Future<void> loadBookings() async {
    if (currentUser == null) return;
    isLoading = true;
    notifyListeners();
    bookings = useMockData
        ? MockData.bookings.where((booking) => booking.user_id == currentUser!.id).toList()
        : await api.getUserBookings(currentUser!.id);
    isLoading = false;
    notifyListeners();
  }

  void payBooking(Booking booking) {
    booking.payment_status = 'paid';
    if (booking.cost != null) walletBalance -= booking.cost!.round();
    notifyListeners();
  }

  void cancelBooking(Booking booking) {
    booking.status = 'cancelled';
    notifyListeners();
  }

  void publishRoute(app_route.Route route) {
    MockData.routes.insert(0, route);
    routes = List.from(MockData.routes);
    filteredRoutes = List.from(MockData.routes);
    notifyListeners();
  }

  void topUpWallet(int amount) {
    walletBalance += amount;
    notifyListeners();
  }

  String _normalize(String value) => value.toLowerCase().replaceAll('6 ', '').replaceAll('-', ' ').trim();

  int _nearScore(String routeArea, String queryArea) {
    final a = _normalize(routeArea);
    final b = _normalize(queryArea);
    if (a == b || a.contains(b) || b.contains(a)) return 0;
    const groups = [
      ['october', 'sheikh zayed', 'giza'],
      ['maadi', 'helwan', 'downtown'],
      ['nasr city', 'heliopolis', 'new cairo'],
      ['dokki', 'mohandessin', 'zamalek'],
    ];
    for (final group in groups) {
      if (group.contains(a) && group.contains(b)) return 1;
    }
    return 3;
  }
}