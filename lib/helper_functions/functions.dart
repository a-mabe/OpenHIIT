import 'package:flutter/material.dart';

import '../create_workout/create_timer.dart';
import '../create_workout/create_workout.dart';
import '../models/list_tile_model.dart';
import '../workout_data_type/workout_type.dart';

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

int calculateWorkoutTime(Workout workout) {
  return (((workout.exerciseTime * workout.numExercises) +
              (workout.restTime * (workout.numExercises - 1)) +
              (workout.halfTime * workout.numExercises)) /
          60)
      .round();
}

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
