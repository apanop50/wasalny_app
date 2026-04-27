import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'app_colors.dart';

class MyRidesScreen extends StatelessWidget{ const MyRidesScreen({super.key});
  @override Widget build(BuildContext context){final p=context.watch<AppProvider>(); return Scaffold(appBar:AppBar(title: const Text('My Rides')), body:ListView(padding: const EdgeInsets.all(16), children:[const Row(children:[Text('Upcoming',style:TextStyle(color:AppColors.primary,fontWeight:FontWeight.bold)), SizedBox(width:24), Text('Completed',style:TextStyle(color:AppColors.muted)), SizedBox(width:24), Text('Cancelled',style:TextStyle(color:AppColors.muted))]), const SizedBox(height:16), ...p.bookings.map((b)=>Container(margin: const EdgeInsets.only(bottom:12), padding: const EdgeInsets.all(14), decoration:cardDecoration(), child:Row(children:[const CircleAvatar(child:Icon(Icons.person)), const SizedBox(width:12), Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Text('${b.start??'Route'} → ${b.end??''}', style: const TextStyle(fontWeight:FontWeight.bold)), Text('${b.time??''} • ${b.payment_status}', style: const TextStyle(color:AppColors.muted,fontSize:12))])), Chip(label:Text(b.status), backgroundColor:b.status=='booked'?Colors.green.shade50:Colors.red.shade50)])))]));}
}