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

  String from = '6 October';
  String to = 'Maadi';
  String selectedTransport = 'all';

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

  Future<void> searchRoutes({required String from, required String to, String? transport}) async {
    this.from = from;
    this.to = to;
    selectedTransport = transport ?? selectedTransport;
    isLoading = true;
    notifyListeners();

    if (useMockData) {
      filteredRoutes = MockData.routes.where((route) {
        final matchFrom = from.isEmpty || route.start.toLowerCase().contains(from.toLowerCase());
        final matchTo = to.isEmpty || route.end.toLowerCase().contains(to.toLowerCase());
        final matchType = selectedTransport == 'all' || route.transport_type == selectedTransport;
        return matchFrom && matchTo && matchType;
      }).toList();
      if (filteredRoutes.isEmpty) filteredRoutes = List.from(MockData.routes);
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
}