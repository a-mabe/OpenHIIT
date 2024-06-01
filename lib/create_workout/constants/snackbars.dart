import 'package:flutter/material.dart';

const invalidJsonSnackBar = SnackBar(
  content: Text('File contains invalid JSON'),
);

const invalidConfigSnackBar = SnackBar(
  content: Text('File contains invalid workout configuration'),
);

const invalidJsonMultipleSnackBar = SnackBar(
  content: Text('Not all files imported, found invalid JSON'),
);

const invalidConfigMultipleSnackBar = SnackBar(
  content: Text('Not all files imported, found invalid workout configuration'),
);

const successfulImportSnackBar = SnackBar(
  content: Text('Import successful!'),
);
