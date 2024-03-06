import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/components/heat_map_wrapper.dart';
import 'package:workout_done/pages/workout_page.dart';

import '../data/workout_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newWorkoutNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initialWorkoutList();
  }

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create new workout"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: const Text("save"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text("cancel"),
          )
        ],
      ),
    );
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  void save() {
    Provider.of<WorkoutData>(context, listen: false)
        .addWorkout(newWorkoutNameController.text);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void goToWorkPage(String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(workoutName: workoutName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            title: const Text("Workout Done"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewWorkout,
            backgroundColor: Colors.black87,
            child: const Icon(Icons.add),
          ),
          body: ListView(children: [
            HeatMapWrapper(
              datasets: value.heatMapDataSet,
              startDate: value.getStartDate(),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // itemBuilder: (context, index) => const ListTile(title: Text("test")),
              itemCount: value.getWorkouts().length,
              itemBuilder: (context, index) => Slidable(
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: null,
                      backgroundColor: Colors.grey.shade800,
                      icon: Icons.settings,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    SlidableAction(
                      onPressed: null,
                      backgroundColor: Colors.red.shade800,
                      icon: Icons.delete,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(value.getWorkouts()[index].name),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () =>
                        goToWorkPage(value.getWorkouts()[index].name),
                  ),
                ),
              ),
            ),
          ])),
    );
  }
}
