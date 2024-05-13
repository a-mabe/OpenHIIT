import 'package:flutter/material.dart';

const String workTitle = "Work";
const String restTitle = "Rest";
const String additionalConfigTitle = "Additional configuration";
const String getReadyTitle = "Get ready";
const String warmUpTitle = "Warm-up";
const String coolDownTitle = "Cool down";
const String repeatTitle = "Restart";
const String breakTitle = "Break";

const String workMinutesKey = "work-minutes";
const String workSecondsKey = "work-seconds";

const String restMinutesKey = "rest-minutes";
const String restSecondsKey = "rest-seconds";

const String warmupMinutesKey = "warmup-minutes";
const String warmupSecondsKey = "warmup-seconds";

const String cooldownMinutesKey = "cooldown-minutes";
const String cooldownSecondsKey = "cooldown-seconds";

const String iterationsKey = "iterations";

const String breakMinutesKey = "break-minutes";
const String breakSecondsKey = "break-seconds";

const String getReadyMinutesKey = "get-ready-minutes";
const String getReadySecondsKey = "get-ready-seconds";

const List timeMinutesKeys = [
  workMinutesKey,
  restMinutesKey,
];

const List timeSecondsKeys = [
  workSecondsKey,
  restSecondsKey,
];

const List additionalMinutesKeys = [
  getReadyMinutesKey,
  warmupMinutesKey,
  cooldownMinutesKey,
  breakMinutesKey
];

const List additionalSecondsKeys = [
  getReadySecondsKey,
  warmupSecondsKey,
  cooldownSecondsKey,
  breakSecondsKey
];

const List<String> timeTitles = [workTitle, restTitle, additionalConfigTitle];

const List<String> additionalTimeTitles = [
  getReadyTitle,
  warmUpTitle,
  coolDownTitle,
  repeatTitle,
  breakTitle
];

List<String> allTitles = timeTitles + additionalTimeTitles;

const List<String> timeSubTitles = [
  "Required",
  "Required",
  "Warmup, auto restart, and more"
];

const List<String> additionalTimeSubTitles = [
  "Optional, default 10s",
  "Optional",
  "Optional",
  "Auto restart",
  "Optional, between restarts"
];

const List<Widget> timeLeadingIcons = [
  Icon(Icons.fitness_center),
  Icon(Icons.pause),
  Icon(Icons.tune)
];

const List<Widget> additionalTimeLeadingIcons = [
  Icon(Icons.flag),
  Icon(Icons.emoji_people),
  Icon(Icons.ac_unit),
  Icon(Icons.replay),
  Icon(Icons.snooze)
];
