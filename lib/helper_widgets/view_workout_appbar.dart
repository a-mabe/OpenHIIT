import 'package:flutter/material.dart';
import 'package:openhiit/helper_widgets/export_bottom_sheet.dart';

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

  void handleMenuSelection(String value, BuildContext context) {
    switch (value) {
      case 'Copy':
        onCopy!();
        break;
      case 'Export':
        exportWorkout(workout, context);
        break;
      case 'Delete':
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
        break;
    }
  }

  void exportWorkout(Workout workout, BuildContext context) async {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      context: context,
      builder: (BuildContext context) {
        return ExportBottomSheet(
          workout: workout,
        );
      },
    );
  }

  IconData determineIcon(String value) {
    switch (value) {
      case 'Copy':
        return Icons.copy;
      case 'Export':
        return Icons.share;
      case 'Delete':
        return Icons.delete;
      default:
        return Icons.delete;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(workout.colorInt),
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        workout.title,
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        // Defines the edit button.
        IconButton(
          key: const Key("edit-workout"),
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: onEdit,
        ),
        PopupMenuButton<String>(
          key: const Key("popup-menu"),
          onSelected: (String item) {
            handleMenuSelection(item, context);
          },
          itemBuilder: (BuildContext context) {
            return {'Copy', 'Export', 'Delete'}.map((String selection) {
              return PopupMenuItem<String>(
                  key: Key(selection),
                  value: selection,
                  child: Row(children: [
                    Icon(
                      determineIcon(selection),
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(selection),
                    )
                  ]));
            }).toList();
          },
        ),
      ],
    );
  }
}
