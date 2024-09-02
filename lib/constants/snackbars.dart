import 'package:flutter/material.dart';

SnackBar createErrorSnackBar(String errorMessage) {
  return SnackBar(
    backgroundColor: Colors.red,
    content: Text(errorMessage, style: const TextStyle(color: Colors.white)),
    behavior: SnackBarBehavior.fixed,
    duration: const Duration(seconds: 4),
    showCloseIcon: true,
  );
}

SnackBar createInfoSnackBar(String message) {
  return SnackBar(
    backgroundColor: Colors.blue,
    content: Text(message, style: const TextStyle(color: Colors.white)),
    behavior: SnackBarBehavior.fixed,
    duration: const Duration(seconds: 4),
    showCloseIcon: true,
  );
}

SnackBar createSuccessSnackBar(String message) {
  return SnackBar(
    backgroundColor: Colors.green,
    content: Text(message, style: const TextStyle(color: Colors.white)),
    behavior: SnackBarBehavior.fixed,
    duration: const Duration(seconds: 4),
    showCloseIcon: true,
  );
}
