import 'dart:async';

import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openhiit/data/timer_type.dart';
import 'package:openhiit/models/lists/timer_list_tile_model.dart';
import 'package:openhiit/pages/import_workout/import_workout.dart';
import 'package:openhiit/utils/log/log.dart';
import '../pages/create_timer/create_timer.dart';
import '../pages/create_workout/create_workout.dart';
import '../data/workout_type.dart';

/// Navigates to the 'ImportWorkout' screen while passing the provided 'Workout' object
/// as an argument.
///
/// Parameters:
///   - [workout]: The 'Workout' object to be passed to the 'ImportWorkout' screen.
///   - [context]: The BuildContext required for navigation within the Flutter app.
///

void pushImportWorkout(Workout workout, BuildContext context,
    FutureOr<dynamic> Function(dynamic) then) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ImportWorkout(),
      settings: RouteSettings(
        arguments: workout,
      ),
    ),
  ).then(then);
}

/// Navigates to the 'CreateWorkout' screen while passing the provided 'Workout' object
/// as an argument.
///
/// Parameters:
///   - [workout]: The 'Workout' object to be passed to the 'CreateWorkout' screen.
///   - [context]: The BuildContext required for navigation within the Flutter app.
///

// void pushCreateWorkout(Workout workout, BuildContext context, bool imported,
//     FutureOr<dynamic> Function(dynamic) then) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => const CreateWorkout(),
//       settings: RouteSettings(
//         arguments: workout,
//       ),
//     ),
//   ).then(then);
// }

/// Navigates to the 'CreateTimer' screen while passing the provided 'Workout' object
/// as an argument.
///
/// Parameters:
///   - [workout]: The 'Workout' object to be passed to the 'CreateTimer' screen.
///   - [context]: The BuildContext required for navigation within the Flutter app.
///
// void pushCreateTimer(Workout workout, BuildContext context, bool imported,
//     FutureOr<dynamic> Function(dynamic) then) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => CreateTimer(timer: timer),
//     ),
//   ).then(then);
// }

/// Calculates the total duration, in minutes, for a given workout based on its
/// exercise time, rest time, half-time, and the number of exercises.
///
/// Parameters:
///   - [workout]: The 'Workout' object containing exercise and timing information.
///
/// Returns:
///   - An integer representing the total workout time rounded to the nearest minute.
///
int calculateWorkoutTime(Workout workout) {
  if (workout.iterations > 0) {
    return (((workout.workTime *
                    workout.numExercises *
                    (workout.iterations + 1)) +
                (workout.restTime *
                    (workout.numExercises - 1) *
                    workout.iterations) +
                (workout.halfTime * workout.numExercises) +
                (workout.breakTime * (workout.iterations + 1)) +
                workout.warmupTime +
                workout.cooldownTime) /
            60)
        .ceil();
  } else {
    return (((workout.workTime * workout.numExercises) +
                (workout.restTime * (workout.numExercises - 1)) +
                (workout.halfTime * workout.numExercises) +
                workout.warmupTime +
                workout.cooldownTime) /
            60)
        .ceil();
  }
}

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

  int workIntervalIndex = 0;
  for (var interval in intervals) {
    listItems.add(
      TimerListTileModel(
        action: interval.name,
        showMinutes: 0,
        interval: ["Rest", "Get ready", "Warmup", "Cooldown", "Break"]
                .contains(interval.name)
            ? 0
            : workIntervalIndex++,
        total: intervals.length,
        seconds: interval.time,
      ),
    );
    if (interval.id.contains("break")) {
      workIntervalIndex = 1;
    }
  }

  return listItems;
}

  // List<TimerListTileModel> listItems = [];

  // if (workoutArg.getReadyTime > 0) {
  //   listItems.add(
  //     TimerListTileModel(
  //       action: "Get ready",
  //       showMinutes: workoutArg.showMinutes,
  //       interval: 0,
  //       total: workoutArg.numExercises,
  //       seconds: workoutArg.getReadyTime,
  //     ),
  //   );
  // }
  // if (workoutArg.warmupTime > 0) {
  //   listItems.add(
  //     TimerListTileModel(
  //       action: "Warmup",
  //       showMinutes: workoutArg.showMinutes,
  //       interval: 0,
  //       total: workoutArg.numExercises,
  //       seconds: workoutArg.warmupTime,
  //     ),
  //   );
  //   listItems.add(
  //     TimerListTileModel(
  //       action: "Rest",
  //       showMinutes: workoutArg.showMinutes,
  //       interval: 0,
  //       total: workoutArg.numExercises,
  //       seconds: workoutArg.restTime,
  //     ),
  //   );
  // }

  // for (var iteration = 0; iteration <= workoutArg.iterations; iteration++) {
  //   for (var interval = 1; interval <= workoutArg.numExercises; interval++) {
  //     if (workoutArg.workTime > 0) {
  //       listItems.add(
  //         TimerListTileModel(
  //           action: exercises.isNotEmpty ? exercises[interval - 1] : "Work",
  //           showMinutes: workoutArg.showMinutes,
  //           interval: interval,
  //           total: workoutArg.numExercises,
  //           seconds: workoutArg.workTime,
  //         ),
  //       );
  //     }

  //     if (workoutArg.restTime > 0 && interval != workoutArg.numExercises) {
  //       listItems.add(
  //         TimerListTileModel(
  //           action: "Rest",
  //           showMinutes: workoutArg.showMinutes,
  //           interval: 0,
  //           total: workoutArg.numExercises,
  //           seconds: workoutArg.restTime,
  //         ),
  //       );
  //     } else if (interval == workoutArg.numExercises &&
  //         workoutArg.iterations > 0 &&
  //         iteration < workoutArg.iterations) {
  //       if (workoutArg.breakTime > 0) {
  //         listItems.add(
  //           TimerListTileModel(
  //             action: "Break",
  //             showMinutes: workoutArg.showMinutes,
  //             interval: 0,
  //             total: workoutArg.numExercises,
  //             seconds: workoutArg.breakTime,
  //           ),
  //         );
  //       } else {
  //         listItems.add(
  //           TimerListTileModel(
  //             action: "Get ready",
  //             showMinutes: workoutArg.showMinutes,
  //             interval: 0,
  //             total: workoutArg.numExercises,
  //             seconds: workoutArg.getReadyTime,
  //           ),
  //         );
  //       }
  //     }
  //   }
  // }

  // if (workoutArg.cooldownTime > 0) {
  //   listItems.add(
  //     TimerListTileModel(
  //       action: "Cooldown",
  //       showMinutes: workoutArg.showMinutes,
  //       interval: 0,
  //       total: workoutArg.numExercises,
  //       seconds: workoutArg.cooldownTime,
  //     ),
  //   );
  // }

  // return listItems;