import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'Ride_screen.dart';
import 'app_colors.dart';
import 'home.dart';
import 'profile.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [HomeScreen(), RidesScreen(showBackButton: false), ProfileScreen()];
    return Consumer<AppProvider>(
      builder: (_, provider, __) => Scaffold(
        body: IndexedStack(index: provider.currentIndex.clamp(0, 2), children: pages),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(color: Color(0xFFFFF7FF)),
          child: SafeArea(
            top: false,
            child: BottomNavigationBar(
              currentIndex: provider.currentIndex.clamp(0, 2),
              onTap: provider.setIndex,
              backgroundColor: const Color(0xFFFFF7FF),
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Ride'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}