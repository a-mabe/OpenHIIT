import 'package:flutter/material.dart';
import 'package:openhiit/shared/globals.dart';

Future<void> showImportDialog(String timerName, VoidCallback onConfirm) async {
  final navigator = navigatorKey.currentState;
  if (navigator == null || !navigator.mounted) {
    // Context is not available — the app may be rebuilding
    return;
  }

  return showDialog<void>(
      context: navigator.context,
      builder: (context) => AlertDialog(
            title: Text(timerName),
            content: Text(
                'Timer with same ID already exists. Do you want to import a copy of $timerName?'),
            actions: <Widget>[
              TextButton(
                child: Text('Skip'),
                onPressed: () {
                  Navigator.of(context).pop(); // dismiss dialog
                },
              ),
              TextButton(
                child: Text('Import Copy'),
                onPressed: () {
                  Navigator.of(context).pop(); // dismiss dialog
                  onConfirm(); // execute callback
                },
              ),
            ],
          ));
}
