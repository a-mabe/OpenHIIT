import 'package:flutter/material.dart';

const List<String> timeTitles = [
  'Work',
  'Rest',
  'Get ready',
  'Warm-up',
  'Cool-down',
  'Break',
];

const inputDecoration = InputDecoration(
  hintText: "0",
  errorStyle: TextStyle(fontSize: 0),
  counterText: "",
  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Colors.transparent),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Colors.transparent),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Colors.blue),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Colors.red),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Colors.red),
  ),
);
