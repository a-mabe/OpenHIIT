import 'dart:convert';

import 'package:flutter/material.dart';
import '../workout_data_type/workout_type.dart';

///
/// Background service countdown interval timer.
///
class TimerListTile extends StatefulWidget {
  final Workout workout;

  final Function? onTap;

  final int index;

  ///
  /// Simple countdown timer
  ///
  const TimerListTile({
    Key? key,
    required this.workout,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  TimerListTileState createState() => TimerListTileState();
}

///
/// State of timer
///
class TimerListTileState extends State<TimerListTile>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        key: Key('$widget.index'),
        color: Color(widget.workout.colorInt),
        child: ListTile(
          // Title of the workout.
          title: Text(widget.workout.title),
          titleTextStyle: const TextStyle(
            fontSize: 20,
          ),
          // Workout metadata.
          subtitle: Text(
              '''${widget.workout.exercises != "" ? 'Exercises: ${jsonDecode(widget.workout.exercises).length}' : 'Intervals: ${widget.workout.numExercises}'}
Exercise time: ${widget.workout.exerciseTime} seconds
Rest time: ${widget.workout.restTime} seconds
Total: ${calculateWorkoutTime(widget.workout)} minutes'''),
          subtitleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          minVerticalPadding: 15.0,
          onTap: () {
            widget.onTap!();
          },
          trailing: ReorderableDragStartListener(
            index: widget.index,
            child: const Icon(Icons.drag_handle),
          ),
        ));
  }

  int calculateWorkoutTime(Workout workout) {
    return (((workout.exerciseTime * workout.numExercises) +
                (workout.restTime * (workout.numExercises - 1)) +
                (workout.halfTime * workout.numExercises)) /
            60)
        .round();
  }
}
