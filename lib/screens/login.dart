import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'app_colors.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final name = TextEditingController(text: 'name');
  final email = TextEditingController(text: 'name@email.com');
  final phone = TextEditingController(text: '01000000000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: appGradient()),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: cardDecoration(radius: 28),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 82, height: 82, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary])), child: const Icon(Icons.directions_car, color: Colors.white, size: 42)),
                  const SizedBox(height: 14),
                  const Text('Wasalny', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                  const Text('Register / Login', style: TextStyle(color: AppColors.muted)),
                  const SizedBox(height: 22),
                  _field(name, 'Name', Icons.person),
                  _field(email, 'Email', Icons.email),
                  _field(phone, 'Phone', Icons.phone),
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, height: 54, child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    onPressed: () async {
                      await context.read<AppProvider>().loginOrRegister(name: name.text, email: email.text, phone: phone.text);
                      if (!mounted) return;
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
                    },
                    child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  )),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(controller: c, decoration: InputDecoration(prefixIcon: Icon(icon, color: AppColors.primary), hintText: hint, filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
  );
}