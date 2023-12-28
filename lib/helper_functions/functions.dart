import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../create_workout/create_timer.dart';
import '../create_workout/create_workout.dart';
import '../models/list_tile_model.dart';
import '../workout_data_type/workout_type.dart';

/// Navigates to the 'CreateWorkout' screen while passing the provided 'Workout' object
/// as an argument.
///
/// Parameters:
///   - [workout]: The 'Workout' object to be passed to the 'CreateWorkout' screen.
///   - [context]: The BuildContext required for navigation within the Flutter app.
///
void pushCreateWorkout(Workout workout, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const CreateWorkout(),
      settings: RouteSettings(
        arguments: workout,
      ),
    ),
  );
}

/// Navigates to the 'CreateTimer' screen while passing the provided 'Workout' object
/// as an argument.
///
/// Parameters:
///   - [workout]: The 'Workout' object to be passed to the 'CreateTimer' screen.
///   - [context]: The BuildContext required for navigation within the Flutter app.
///
void pushCreateTimer(Workout workout, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const CreateTimer(),
      settings: RouteSettings(
        arguments: workout,
      ),
    ),
  );
}

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
  return (((workout.exerciseTime * workout.numExercises) +
              (workout.restTime * (workout.numExercises - 1)) +
              (workout.halfTime * workout.numExercises)) /
          60)
      .round();
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
List<ListTileModel> listItems(List exercises, Workout workoutArgument) {
  List<ListTileModel> listItems = [];

  for (var i = 0; i < workoutArgument.numExercises + 1; i++) {
    if (i == 0) {
      listItems.add(
        ListTileModel(
          action: "Prepare",
          showMinutes: workoutArgument.showMinutes,
          interval: 0,
          total: workoutArgument.numExercises,
          seconds: 10,
        ),
      );
    } else {
      if (exercises.length < workoutArgument.numExercises) {
        listItems.add(
          ListTileModel(
            action: "Work",
            showMinutes: workoutArgument.showMinutes,
            interval: i,
            total: workoutArgument.numExercises,
            seconds: workoutArgument.exerciseTime,
          ),
        );
        if (i < workoutArgument.numExercises) {
          listItems.add(
            ListTileModel(
              action: "Rest",
              showMinutes: workoutArgument.showMinutes,
              interval: 0,
              total: workoutArgument.numExercises,
              seconds: workoutArgument.restTime,
            ),
          );
        }
      } else {
        listItems.add(
          ListTileModel(
            action: exercises[i - 1],
            showMinutes: workoutArgument.showMinutes,
            interval: i,
            total: workoutArgument.numExercises,
            seconds: workoutArgument.exerciseTime,
          ),
        );
        if (i < workoutArgument.numExercises) {
          listItems.add(
            ListTileModel(
              action: "Rest",
              showMinutes: workoutArgument.showMinutes,
              interval: 0,
              total: workoutArgument.numExercises,
              seconds: workoutArgument.restTime,
            ),
          );
        }
      }
    }
  }

  return listItems;
}
