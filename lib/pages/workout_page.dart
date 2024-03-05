import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/components/exercise_tile.dart';

import '../data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  void onCheckboxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  final exerciseNameController = TextEditingController();
  final exerciseWeightController = TextEditingController();
  final exerciseRepsController = TextEditingController();
  final exerciseSetsController = TextEditingController();

  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a new exercise"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: exerciseNameController,
            ),
            TextField(
              controller: exerciseWeightController,
            ),
            TextField(
              controller: exerciseRepsController,
            ),
            TextField(
              controller: exerciseSetsController,
            ),
          ],
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
    exerciseNameController.clear();
    exerciseWeightController.clear();
    exerciseRepsController.clear();
    exerciseSetsController.clear();
  }

  void save() {
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      exerciseNameController.text,
      exerciseWeightController.text,
      exerciseRepsController.text,
      exerciseSetsController.text,
    );

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
          itemBuilder: (context, index) => ExerciseTile(
            exercise:
                value.getRelevantWorkout(widget.workoutName).exercises[index],
            onCheckboxChanged: (check) => onCheckboxChanged(
                widget.workoutName,
                value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name),
          ),
        ),
      ),
    );
  }
}
