import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/route.dart' as app_route;
import '../providers/app_provider.dart';
import 'app_colors.dart';
import 'trip_details_screen.dart';

class RidesScreen extends StatefulWidget {
  final bool showBackButton;
  const RidesScreen({super.key, this.showBackButton = true});
  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  bool compare = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final routes = provider.filteredRoutes;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: widget.showBackButton ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)) : null,
        title: const Text('Route Options', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(.7), borderRadius: BorderRadius.circular(14)),
            child: Row(children: [_tab('Compare', compare, () => setState(() => compare = true)), _tab('Details', !compare, () => setState(() => compare = false))]),
          ),
          const SizedBox(height: 28),
          Text('We found ${routes.length} options for you', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
          const SizedBox(height: 22),
          ...routes.map((route) => OptionCard(route: route, onTap: () { provider.selectRoute(route); Navigator.push(context, MaterialPageRoute(builder: (_) => const TripDetailsScreen())); })),
        ],
      ),
    );
  }

  Widget _tab(String text, bool selected, VoidCallback onTap) => Expanded(child: GestureDetector(onTap: onTap, child: Container(alignment: Alignment.center, decoration: BoxDecoration(color: selected ? AppColors.secondary : Colors.transparent, borderRadius: BorderRadius.circular(12)), child: Text(text, style: TextStyle(color: selected ? Colors.white : Colors.grey, fontSize: 18, fontWeight: FontWeight.w900)))));
}

class OptionCard extends StatelessWidget {
  final app_route.Route route;
  final VoidCallback onTap;
  const OptionCard({super.key, required this.route, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final meta = _meta(route.transport_type);
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 10)]),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(children: [
            CircleAvatar(radius: 31, backgroundColor: meta.color, child: Icon(meta.icon, color: Colors.white, size: 34)),
            const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.emoji_events, color: meta.badgeColor, size: 16), const SizedBox(width: 6), Text(meta.badge, style: TextStyle(color: meta.badgeColor, fontWeight: FontWeight.w600))]),
              const SizedBox(height: 4),
              Text(meta.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(route.time, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
              const Text('Arrival 10:20 AM', style: TextStyle(color: Colors.grey, fontSize: 15)),
              const SizedBox(height: 8),
              Text('Leaves in ${route.transport_type == 'ride_share' ? 3 : route.transport_type == 'bus' ? 8 : 5} min', style: TextStyle(color: meta.badgeColor, fontSize: 15)),
            ])),
            Text('${route.cost.toStringAsFixed(0)} EGP', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          ]),
        ),
      ),
    );
  }

  _TransportMeta _meta(String type) {
    if (type == 'bus') return const _TransportMeta('Bus', 'Cheapest', Icons.directions_bus, AppColors.secondary, Colors.orange);
    if (type == 'ride_share') return const _TransportMeta('Ride', 'Comfortable', Icons.directions_car, Color(0xFF7657F6), AppColors.secondary);
    return const _TransportMeta('Microbus', 'Fastest', Icons.directions_bus, Color(0xFF2D9CDB), Colors.green);
  }
}

class _TransportMeta {
  final String title;
  final String badge;
  final IconData icon;
  final Color color;
  final Color badgeColor;
  const _TransportMeta(this.title, this.badge, this.icon, this.color, this.badgeColor);
}