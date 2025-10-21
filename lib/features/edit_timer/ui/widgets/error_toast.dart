import 'package:flutter/material.dart';

/// Shows an error SnackBar. Call from any widget with a valid [BuildContext]:
///   showErrorToast(context, 'Something went wrong');
void showErrorToast(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      duration: duration,
      backgroundColor: Colors.red.shade700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white70,
        onPressed: () => messenger.hideCurrentSnackBar(),
      ),
    ),
  );
}
