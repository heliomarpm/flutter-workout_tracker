import 'package:flutter/material.dart';
import 'package:workout_done/data/hive_db.dart';
import 'package:workout_done/datetime/data_time.dart';

import '../models/workout.dart';
import '../models/exercise.dart';

class WorkoutData extends ChangeNotifier {
  final _db = HiveDb();

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

  void initialWorkoutList() {
    if (_db.hasPreviousData()) {
      workouts = _db.read();
    } else {
      _db.save(workouts);
    }

    loadHeatMap();
  }

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
    _db.save(workouts);
  }

  void checkOffExercise(String workoutName, String exerciseName) {
    var exercise = getRelevantExercise(workoutName, exerciseName);
    exercise.isCompleted = !exercise.isCompleted;

    notifyListeners();
    _db.save(workouts);

    loadHeatMap();
  }

  String getStartDate() {
    return _db.getStartDate();
  }

  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = strToDateTime(getStartDate());

    int days = DateTime.now().difference(startDate).inDays;

    for (var i = 0; i < days + 1; i++) {
      DateTime nextDate = startDate.add(Duration(days: i));
      String yyyymmdd = dateTimeToStr(nextDate);

      int completionStatus = _db.getCompletionStatus(yyyymmdd);
      int year = nextDate.year;
      int month = nextDate.month;
      int day = nextDate.day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
