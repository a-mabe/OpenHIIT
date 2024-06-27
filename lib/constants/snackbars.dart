import 'package:flutter/material.dart';

const invalidJsonSnackBar = SnackBar(
  content: Text('File contains invalid JSON'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);

const invalidConfigSnackBar = SnackBar(
  content: Text('File contains invalid workout configuration'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);

const invalidJsonMultipleSnackBar = SnackBar(
  content: Text('Not all files imported, found invalid JSON'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);

const invalidConfigMultipleSnackBar = SnackBar(
  content: Text('Not all files imported, found invalid workout configuration'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);

const successfulImportSnackBar = SnackBar(
  content: Text('Import successful!'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);

const successfulShareSnackBar = SnackBar(
  content: Text('Share successful!'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);

const successfulShareMultipleSnackBar = SnackBar(
  content: Text('Files shared successfully!'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);

const successfulSaveMultipleToDeviceSnackBar = SnackBar(
  content: Text('Files successfully saved to device!'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);

const successfulSaveToDeviceSnackBar = SnackBar(
  content: Text('Saved file to device!'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);

const errorTimerExists = SnackBar(
  content: Text('Could not import, timer with same ID exists'),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);

const errorMultipleTimerExists = SnackBar(
  content: Text(
    'Not all files imported, timer with same ID exists',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Color.fromARGB(255, 132, 19, 11),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);

const errorShareMultipleSnackBar = SnackBar(
  content: Text('Share not completed', style: TextStyle(color: Colors.white)),
  backgroundColor: Color.fromARGB(255, 132, 19, 11),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);

const errorSaveMultipleSnackBar = SnackBar(
  content: Text('Save not completed', style: TextStyle(color: Colors.white)),
  backgroundColor: Color.fromARGB(255, 132, 19, 11),
  behavior: SnackBarBehavior.fixed,
  duration: Duration(seconds: 4),
  showCloseIcon: true,
);
