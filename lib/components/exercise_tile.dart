import 'package:flutter/material.dart';

import '../models/exercise.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final Function(bool?)? onCheckboxChanged;

  const ExerciseTile({
    super.key,
    required this.exercise,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[50],
      // color: Colors.grey[200],
      child: ListTile(
        title: Text(exercise.name),
        subtitle: Row(
          children: [
            Chip(label: Text("${exercise.weight} kg")),
            Chip(label: Text("${exercise.reps} reps")),
            Chip(label: Text("${exercise.sets} sets")),
          ],
        ),
        trailing: Checkbox(
          value: exercise.isCompleted,
          onChanged: (value) => onCheckboxChanged!(value),
        ),
      ),
    );
  }
}
