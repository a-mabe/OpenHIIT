import 'dart:convert';

import 'package:flutter/material.dart';
import '../helper_functions/functions.dart';
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
    super.key,
    required this.workout,
    required this.onTap,
    required this.index,
  });

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

  String timeString(int showMinutes, int seconds) {
    if (showMinutes == 1) {
      int secondsRemainder = seconds % 60;
      int minutes = ((seconds - secondsRemainder) / 60).round();

      if (minutes == 0) {
        return "${seconds.toString()} seconds";
      }

      String secondsString = secondsRemainder.toString();
      if (secondsRemainder < 10) {
        secondsString = "0$secondsRemainder";
      }

      return "$minutes:$secondsString";
    } else {
      return "${seconds.toString()} seconds";
    }
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
              '''${widget.workout.exercises != "" ? 'Exercises - ${jsonDecode(widget.workout.exercises).length}' : 'Intervals - ${widget.workout.numExercises}'}
Exercise time - ${timeString(widget.workout.showMinutes, widget.workout.exerciseTime)}
Rest time - ${timeString(widget.workout.showMinutes, widget.workout.restTime)}
Total - ${calculateWorkoutTime(widget.workout)} minutes'''),
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
}
