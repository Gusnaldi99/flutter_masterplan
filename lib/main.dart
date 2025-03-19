import 'package:flutter/material.dart';
import 'package:flutter_masterplan/Provider/plan_provider.dart';
import 'package:flutter_masterplan/views/plan_screen.dart';
import 'package:flutter_masterplan/Models/plan.dart';

void main() => runApp(const MasterPlanApp());

class MasterPlanApp extends StatelessWidget {
  const MasterPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      home: PlanProvider(
        child: const PlanScreen(),
        notifier: ValueNotifier<List<Plan>>([const Plan()]),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
