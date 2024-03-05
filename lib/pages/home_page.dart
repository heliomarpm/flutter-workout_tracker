import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        appBar: AppBar(
          title: const Text("Workout Done"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          // itemBuilder: (context, index) => const ListTile(title: Text("test")),
          itemCount: value.getWorkouts().length,
          itemBuilder: (context, index) => ListTile(
            title: Text(value.getWorkouts()[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () => goToWorkPage(value.getWorkouts()[index].name),
            ),
          ),
        ),
      ),
    );
  }
}
