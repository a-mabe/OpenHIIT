import 'package:flutter/material.dart';

SnackBar errorSnackbar(String message) {
  return SnackBar(
    content:
        Text('Error: $message', style: const TextStyle(color: Colors.white)),
    backgroundColor: Colors.red,
    closeIconColor: Colors.white,
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    duration: const Duration(seconds: 3),
  );
}

SnackBar infoSnackbar(String message) {
  return SnackBar(
    content: Text(message, style: const TextStyle(color: Colors.white)),
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    duration: const Duration(seconds: 3),
  );
}

SnackBar importSuccessSnackbar(String message) {
  return SnackBar(
    content: Text(message, style: const TextStyle(color: Colors.white)),
    backgroundColor: Colors.green,
    closeIconColor: Colors.white,
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    duration: const Duration(seconds: 3),
  );
}
