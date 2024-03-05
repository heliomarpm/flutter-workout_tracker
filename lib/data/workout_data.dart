import 'package:flutter/material.dart';

import '../models/workout.dart';
import '../models/exercise.dart';

class WorkoutData extends ChangeNotifier {
  List<Workout> workouts = [
    Workout(name: "Upper Body", exercises: [
      Exercise(
        name: "Biceps Curls",
        weight: "10",
        reps: "10",
        sets: "3",
      )
    ])
  ];

  List<Workout> getWorkouts() {
    return workouts;
  }

  Workout getRelevantWorkout(String name) {
    return workouts.firstWhere((el) => el.name == name);
  }

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    var workout = getRelevantWorkout(workoutName);

    return workout.exercises.firstWhere((el) => el.name == exerciseName);
  }

  int numberOfExercisesInWorkout(String workoutName) {
    var workout = getRelevantWorkout(workoutName);
    return workout.exercises.length;
  }

  void addWorkout(String name) {
    workouts.add(Workout(name: name, exercises: []));

    notifyListeners();
  }

  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    var workout = getRelevantWorkout(workoutName);

    workout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();
  }

  void checkOffExercise(String workoutName, String exerciseName) {
    var exercise = getRelevantExercise(workoutName, exerciseName);
    exercise.isCompleted = !exercise.isCompleted;

    notifyListeners();
  }
}
