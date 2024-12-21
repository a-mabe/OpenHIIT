import 'package:flutter/material.dart';
import 'package:openhiit/data/timer_type.dart';

class CopyOrSkipDialog extends StatelessWidget {
  /// Funtion to execute when the bulk FAB is pressed.
  ///
  final void Function() onSkip;

  /// Function to execute when the create timer FAB
  /// is pressed.
  ///
  final void Function() onImportCopy;

  final TimerType timer;

  const CopyOrSkipDialog(
      {super.key,
      required this.timer,
      required this.onImportCopy,
      required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Import conflict ${timer.name}'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'Existing timer with same ID, skip ${timer.name} or import copy?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: onSkip, child: const Text('Skip')),
        TextButton(
          onPressed: onImportCopy,
          child: const Text('Import Copy'),
        ),
      ],
    );
  }
}
