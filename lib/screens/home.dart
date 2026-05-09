import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../providers/app_provider.dart';
import 'Ride_screen.dart';
import 'app_colors.dart';
import 'safety_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String from = '6 October';
  String to = 'Maadi';
  String transport = 'ride_share';

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
          children: [
            Row(children: [IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyScreen())), icon: const Icon(Icons.menu, size: 30)), const Spacer(), IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No new notifications'))), icon: const Icon(Icons.notifications_none_rounded)), CircleAvatar(radius: 22, backgroundColor: AppColors.primary.withOpacity(.12), child: Text((user?.name ?? 'S')[0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))]),
            const SizedBox(height: 34),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: RichText(text: TextSpan(style: const TextStyle(fontSize: 34, height: 1.25, color: Colors.black, fontWeight: FontWeight.w900), children: [const TextSpan(text: 'Welcome,\n'), TextSpan(text: '${user?.name ?? 'Sara'} ', style: const TextStyle(color: Color(0xFF241A9B))), const TextSpan(text: '👋')]))),
              Container(width: 140, height: 118, decoration: BoxDecoration(color: const Color(0xFFEAE6FF), borderRadius: BorderRadius.circular(24)), child: const Icon(Icons.directions_bus, color: AppColors.primary, size: 62)),
            ]),
            const SizedBox(height: 12),
            const Text('Where would you like to go?', style: TextStyle(color: AppColors.muted, fontSize: 18)),
            const SizedBox(height: 34),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: cardDecoration(radius: 28),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('From', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                _locationBox(from, (v) => setState(() => from = v!)),
                Center(child: Container(margin: const EdgeInsets.symmetric(vertical: 10), width: 46, height: 46, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)), child: const Icon(Icons.swap_vert, color: AppColors.primary))),
                const Text('To', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                _locationBox(to, (v) => setState(() => to = v!)),
                const SizedBox(height: 26),
                const Text('Choose your transport', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 16),
                SizedBox(height: 128, child: ListView(scrollDirection: Axis.horizontal, children: [_transportCard('all', 'All', Icons.commute), _transportCard('microbus', 'Microbus', Icons.airport_shuttle), _transportCard('bus', 'Bus', Icons.directions_bus), _transportCard('ride_share', 'Ride Share', Icons.directions_car)])),
                const SizedBox(height: 26),
                SizedBox(width: double.infinity, height: 66, child: DecoratedBox(decoration: BoxDecoration(gradient: appGradient(), borderRadius: BorderRadius.circular(18)), child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, foregroundColor: Colors.white), icon: const Icon(Icons.search), label: const Text('Find Route', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), onPressed: () async { final provider = context.read<AppProvider>(); await provider.searchRoutes(from: from, to: to, transport: transport); if (!mounted) return; Navigator.push(context, MaterialPageRoute(builder: (_) => const RidesScreen())); }))),
                const SizedBox(height: 16),
                Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFEFFBF5), borderRadius: BorderRadius.circular(16)), child: Row(children: const [Icon(Icons.eco, color: Colors.green), SizedBox(width: 10), Expanded(child: Text('Save money, save the planet! Share rides and reduce traffic together.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))), Icon(Icons.public, color: Colors.green)])),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationBox(String value, ValueChanged<String?> onChanged) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
        child: DropdownButtonFormField<String>(value: value, decoration: const InputDecoration(border: InputBorder.none, prefixIcon: Icon(Icons.location_on, color: AppColors.primary)), icon: const Icon(Icons.keyboard_arrow_down), items: MockData.areas.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontWeight: FontWeight.w700)))).toList(), onChanged: onChanged),
      );

  Widget _transportCard(String type, String label, IconData icon) {
    final selected = transport == type;
    return GestureDetector(
      onTap: () { setState(() => transport = type); context.read<AppProvider>().setTransport(type); },
      child: Container(
        width: 118,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(color: selected ? const Color(0xFFEFF6FF) : Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: selected ? AppColors.primary : Colors.grey.shade200, width: selected ? 2 : 1)),
        child: Stack(children: [if (selected) const Positioned(top: 14, right: 14, child: CircleAvatar(radius: 12, backgroundColor: AppColors.primary, child: Icon(Icons.check, color: Colors.white, size: 16))), Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: AppColors.primary, size: 38), const SizedBox(height: 12), Text(label, style: const TextStyle(fontWeight: FontWeight.w900))]))]),
      ),
    );
  }
}