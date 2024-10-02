import 'package:flutter/material.dart';

class FABColumn extends StatelessWidget {
  /// Funtion to execute when the bulk FAB is pressed.
  ///
  final void Function() bulk;

  /// Function to execute when the create timer FAB
  /// is pressed.
  ///
  final void Function() create;

  const FABColumn({super.key, required this.bulk, required this.create});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.small(
          onPressed: bulk,
          tooltip: 'Bulk export',
          heroTag: "export",
          child: const Icon(Icons.share),
        ),
        const SizedBox(
          height: 20,
        ),
        FloatingActionButton(
          onPressed: create,
          tooltip: 'Create a new timer',
          heroTag: "create",
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
