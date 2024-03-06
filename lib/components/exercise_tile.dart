import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
      child: Slidable(
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
        child: Container(
          padding: const EdgeInsets.all(24),
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
      ),
    );
  }
}
