import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/models/lists/timer_list_tile_model.dart';
import '../models/timer/workout_type.dart';

/// Sets the status bar brightness based on the brightness theme of the provided
/// [BuildContext]. This function disables automatic system UI adjustment for
/// the render views and updates the system UI overlay style to match the
/// brightness of the current theme.
///
/// Parameters:
///   - [context]: The BuildContext used to access the current theme brightness.
///
void setStatusBarBrightness(BuildContext context) {
  WidgetsBinding.instance.renderViews.first.automaticSystemUiAdjustment = false;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Theme.of(context).brightness,
  ));
}

/// Generates a list of [ListTileModel] objects representing the workout intervals
/// based on the provided list of [exercises] and the [Workout] argument.
///
/// Parameters:
///   - [exercises]: The list of exercises to be included in the workout intervals.
///   - [workoutArgument]: The 'Workout' object containing workout configuration.
///
/// Returns:
///   - A list of [ListTileModel] objects representing each interval in the workout.
///
List<TimerListTileModel> listItems(
    TimerType timer, List<IntervalType> intervals) {
  List<TimerListTileModel> listItems = [];

  int workIntervalIndex = ["Rest", "Get Ready", "Warmup", "Cooldown", "Break"]
          .contains(intervals.first.name)
      ? 0
      : 1;
  for (var interval in intervals) {
    listItems.add(
      TimerListTileModel(
        action: interval.name,
        showMinutes: timer.showMinutes,
        interval: ["Rest", "Get ready", "Warmup", "Cooldown", "Break"]
                .contains(interval.name)
            ? 0
            : workIntervalIndex++,
        total: timer.activeIntervals,
        seconds: interval.time,
      ),
    );
    if (interval.id.contains("break")) {
      workIntervalIndex = 1;
    }
  }

  return listItems;
}
