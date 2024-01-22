import 'package:flutter/material.dart';

import '../workout_data_type/workout_type.dart';

class ViewWorkoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Called on delete button tap.
  ///
  final VoidCallback? onDelete;

  /// Called on edit button tap.
  ///
  final VoidCallback? onEdit;

  /// Called on copy button tap.
  ///
  final VoidCallback? onCopy;

  /// Workout object - needed for values such as the workout
  /// title and colorInt.
  ///
  final Workout workout;

  /// Height of the appbar.
  ///
  final double height;

  const ViewWorkoutAppBar(
      {super.key,
      required this.onDelete,
      required this.onEdit,
      required this.onCopy,
      required this.workout,
      required this.height});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        workout.title,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(workout.colorInt),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: <Widget>[
        // Defines the delete button.
        IconButton(
          key: const Key("delete-workout"),
          icon: const Icon(Icons.delete, color: Colors.white),
          tooltip: 'Delete timer',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete ${workout.title}'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                            'Are you sure you would like to delete ${workout.title}?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      onPressed: onDelete,
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        // Defines the edit button.
        IconButton(
          key: const Key("edit-workout"),
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: onEdit,
        ),
        IconButton(
          key: const Key("copy-workout"),
          icon: const Icon(Icons.copy, color: Colors.white),
          onPressed: onCopy,
        ),
      ],
    );
  }
}
