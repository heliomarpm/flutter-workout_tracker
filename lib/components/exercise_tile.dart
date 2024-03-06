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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),

        // color: Colors.purple[50],
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
      ),
    );
  }
}
