import 'package:flutter/material.dart';

const invalidJsonSnackBar = SnackBar(
  content: Text('File contains invalid JSON'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 3),
  showCloseIcon: true,
);

const invalidConfigSnackBar = SnackBar(
  content: Text('File contains invalid workout configuration'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 3),
  showCloseIcon: true,
);

const invalidJsonMultipleSnackBar = SnackBar(
  content: Text('Not all files imported, found invalid JSON'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 3),
  showCloseIcon: true,
);

const invalidConfigMultipleSnackBar = SnackBar(
  content: Text('Not all files imported, found invalid workout configuration'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 3),
  showCloseIcon: true,
);

const successfulImportSnackBar = SnackBar(
  content: Text('Import successful!'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 3),
  showCloseIcon: true,
);

const successfulShareSnackBar = SnackBar(
  content: Text('Share successful!'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 3),
  showCloseIcon: true,
);

const successfulSaveToDeviceSnackBar = SnackBar(
  content: Text('Saved file to device!'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 3),
  showCloseIcon: true,
);
