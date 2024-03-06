// import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../datetime/data_time.dart';
import '../models/exercise.dart';
import '../models/workout.dart';

const START_DATE = "START_DATE";

class HiveDb {
  final _hiveBox = Hive.box("workout_dbase");

  bool hasPreviousData() {
    final isEmpty = _hiveBox.isEmpty;
    print(isEmpty
        ? "👉 Previous data does NOT exist"
        : "👉 Previous data does exist");
    if (isEmpty) {
      _hiveBox.put(START_DATE, dateTimeToStr(null));
    }
    return !isEmpty;
  }

  // return start date as yyyymmdd
  String getStartDate() {
    return _hiveBox.get(START_DATE);
  }

  // write data
  void save(List<Workout> workouts) {
    _hiveBox.put("COMPLETION_STATUS_${dateTimeToStr(null)}",
        exerciseCompleted(workouts) ? 1 : 0);

    _hiveBox.put("WORKOUTS", convertWorkoutsToList(workouts));
    _hiveBox.put("EXERCISES", convertExercisesToList(workouts));
  }

  // read data, and return a list of workouts
  List<Workout> read() {
    var workoutNames = _hiveBox.get("WORKOUTS");
    final exerciseDetails = _hiveBox.get("EXERCISES");

    return List.generate(workoutNames.length, (index) {
      final exercises = List.generate(exerciseDetails[index].length, (i) {
        final exerciseData = exerciseDetails[index][i];
        return Exercise(
          name: exerciseData[0],
          weight: exerciseData[1],
          reps: exerciseData[2],
          sets: exerciseData[3],
          isCompleted: exerciseData[4] == "true",
        );
      });
      return Workout(name: workoutNames[index], exercises: exercises);
    });
    // List<Workout> resultDb = [];
    // var workoutNames = _hiveBox.get("WORKOUTS") ?? [];
    // final exerciceDetails = _hiveBox.get("EXERCISES");

    // for (var i = 0; i < workoutNames.length; i++) {
    //   List<Exercise> exercises = [];

    //   for (var j = 0; j < exerciceDetails[i].length; j++) {
    //     exercises.add(Exercise(
    //       name: exerciceDetails[i][j][0],
    //       weight: exerciceDetails[i][j][1],
    //       reps: exerciceDetails[i][j][2],
    //       sets: exerciceDetails[i][j][3],
    //       isCompleted: exerciceDetails[i][j][4] == "true",
    //     ));
    //   }

    //   Workout workout = Workout(name: workoutNames[i], exercises: exercises);
    //   resultDb.add(workout);
    // }

    // return resultDb;
  }

  // chek if any exercises have been done
  bool exerciseCompleted(List<Workout> workouts) {
    return workouts.any((workout) =>
            workout.exercises.any((exercise) => exercise.isCompleted))
        ? true
        : false;
  }

  // return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _hiveBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }

  // converts workout objects into a list of workout names
  List<String> convertWorkoutsToList(List<Workout> workouts) {
    return workouts.map((workout) => workout.name).toList();
  }

  // converts  the exercises in a workout object into a list of strings
  List<List<List<String>>> convertExercisesToList(List<Workout> workouts) {
    return workouts.map((workout) => workoutToExerciseList(workout)).toList();

    // List<List<List<String>>> exerciseList = [];

    // for (var i = 0; i < workouts.length; i++) {
    //   List<Exercise> exercises = workouts[i].exercises;
    //   List<List<String>> workout = [];

    //   for (var j = 0; j < exercises.length; j++) {
    //     List<String> exercise = [];
    //     exercise.addAll([
    //       exercises[j].name,
    //       exercises[j].weight,
    //       exercises[j].reps,
    //       exercises[j].sets,
    //       exercises[j].isCompleted.toString(),
    //     ]);
    //     workout.add(exercise);
    //   }
    //   exerciseList.add(workout);
    // }
    // return exerciseList;
  }

  // convert workout object to a list of exercises
  List<List<String>> workoutToExerciseList(Workout workout) {
    return workout.exercises.map((exercise) {
      return [
        exercise.name,
        exercise.weight,
        exercise.reps,
        exercise.sets,
        exercise.isCompleted.toString(),
      ];
    }).toList();
  }
}
