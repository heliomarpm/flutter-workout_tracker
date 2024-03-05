// import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../datetime/data_time.dart';
import '../models/exercise.dart';
import '../models/workout.dart';

class HiveDb {
  final _hiveBox = Hive.box("workout_database");

  bool hasPreviousData() {
    final isEmpty = _hiveBox.isEmpty;
    print(isEmpty ? "👉 Previous data does NOT exist" : "👉 Previous data does exist");
    return !isEmpty;
  }

  // return start date as yyyymmdd
  String getStartDate() {
    return _hiveBox.get("START_DATE");
  }

  // write data
  void save(List<Workout> workouts) {
    _hiveBox.put("COMPLETION_STATUS_${dateTimeToStr(null)}",
        exerciseCompleted(workouts) ? 1 : 0);

    _hiveBox.put("WORKOUTS", convertWorkouts(workouts));
    _hiveBox.put("EXERCISES", convertExercises(workouts));
  }

  // read data, and return a list of workouts
  List<Workout> read() {
    List<String> workoutNames = _hiveBox.get("WORKOUTS");
    List<List<List<String>>> exerciseDetails = _hiveBox.get("EXERCISES");

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

  }

  // chek if any exercises have been done
  bool exerciseCompleted(List<Workout> workouts) {
    return workouts.any((workout) => workout.exercises.any((exercise) => exercise.isCompleted)) ? true : false;
  }

  // return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _hiveBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }

  // converts workout objects into a list of workout names
  List<String> convertWorkouts(List<Workout> workouts) {
    return workouts.map((workout) => workout.name).toList();
  }

  // converts  the exercises in a workout object into a list of strings
  List<List<List<String>>> convertExercises(List<Workout> workouts) {
    return workouts.map((workout) => workoutToExerciseList(workout)).toList();
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
