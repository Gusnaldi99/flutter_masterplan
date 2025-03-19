import 'package:flutter/material.dart';
import 'package:flutter_masterplan/Models/data_layer.dart';
import 'package:flutter_masterplan/Provider/plan_provider.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController =
        ScrollController()..addListener(() {
          FocusScope.of(context).requestFocus(FocusNode());
        });
  }

  Widget _buildAddTaskButton(BuildContext context) {
    // Ubah tipe data sesuai dengan yang dikembalikan oleh PlanProvider.of
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        // Asumsikan kita bekerja dengan plan pertama dalam list
        List<Plan> currentPlans = plansNotifier.value;
        if (currentPlans.isNotEmpty) {
          Plan currentPlan = currentPlans[0];
          List<Plan> newPlans = List<Plan>.from(currentPlans);
          newPlans[0] = Plan(
            name: currentPlan.name,
            tasks: List<Task>.from(currentPlan.tasks)..add(const Task()),
          );
          plansNotifier.value = newPlans;
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget _buildList(Plan plan) {
    return ListView.builder(
      controller: scrollController,
      itemCount: plan.tasks.length,
      itemBuilder:
          (context, index) => _buildTaskTile(plan.tasks[index], index, context),
    );
  }

  Widget _buildTaskTile(Task task, int index, BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);
    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          List<Plan> currentPlans = plansNotifier.value;
          if (currentPlans.isNotEmpty) {
            Plan currentPlan = currentPlans[0];
            List<Plan> newPlans = List<Plan>.from(currentPlans);
            newPlans[0] = Plan(
              name: currentPlan.name,
              tasks: List<Task>.from(currentPlan.tasks)
                ..[index] = Task(
                  description: task.description,
                  complete: selected ?? false,
                ),
            );
            plansNotifier.value = newPlans;
          }
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          List<Plan> currentPlans = plansNotifier.value;
          if (currentPlans.isNotEmpty) {
            Plan currentPlan = currentPlans[0];
            List<Plan> newPlans = List<Plan>.from(currentPlans);
            newPlans[0] = Plan(
              name: currentPlan.name,
              tasks: List<Task>.from(currentPlan.tasks)
                ..[index] = Task(description: text, complete: task.complete),
            );
            plansNotifier.value = newPlans;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Master Plan')),
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: PlanProvider.of(context),
        builder: (context, plans, child) {
          if (plans.isEmpty) {
            return const Center(child: Text('No plans available'));
          }

          Plan plan = plans[0]; // Asumsikan kita bekerja dengan plan pertama
          int completedCount = plan.tasks.where((task) => task.complete).length;
          String completenessMessage =
              '$completedCount out of ${plan.tasks.length} tasks';

          return Column(
            children: [
              Expanded(child: _buildList(plan)),
              SafeArea(child: Text(completenessMessage)),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(context),
    );
  }
}
