import 'package:flutter/material.dart';

import '../workout_data_type/workout_type.dart';

class CopyOrSkipDialog extends StatelessWidget {
  /// Funtion to execute when the bulk FAB is pressed.
  ///
  final void Function() onSkip;

  /// Function to execute when the create timer FAB
  /// is pressed.
  ///
  final void Function() onImportCopy;

  final Workout workout;

  const CopyOrSkipDialog(
      {super.key,
      required this.workout,
      required this.onImportCopy,
      required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Import conflict ${workout.title}'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'Existing timer with same ID, skip ${workout.title} or import copy?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(child: const Text('Skip'), onPressed: onSkip),
        TextButton(
          onPressed: onImportCopy,
          child: const Text('Import Copy'),
        ),
      ],
    );
  }
}
