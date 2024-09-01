import 'package:flutter/material.dart';

const errorDeletingWorkoutSnackBar = SnackBar(
  content: Text('Error deleting workout'),
);

SnackBar createErrorSnackbar({required String errorMessage}) {
  return SnackBar(
    content: Text(errorMessage),
    backgroundColor: Colors.red[900],
  );
}
