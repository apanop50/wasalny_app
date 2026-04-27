import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/login.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const WasalnyApp(),
    ),
  );
}

class WasalnyApp extends StatelessWidget {
  const WasalnyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF3158F6);
    return MaterialApp(
      title: 'Wasalny',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        primaryColor: primary,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        colorScheme: ColorScheme.fromSeed(seedColor: primary, primary: primary),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F7FB),
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}