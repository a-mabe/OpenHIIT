import 'package:flutter/material.dart';
import 'package:openhiit/old/workout_data_type/workout_type.dart';
import 'package:openhiit/pages/home/widgets/custom_list_tile.dart';

class WorkoutCard extends StatefulWidget {
  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onWorkoutTap,
  });

  /// The workout to display in the card.
  ///
  final Workout workout;

  /// Callback function for when the workout is tapped.
  ///
  final Function(Workout) onWorkoutTap;

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  static const double titleSmallTextSize = 18;
  static const double titleLargeTextSize = 22;
  static const double subtitleSmallTextSize = 12;
  static const double subtitleLargeTextSize = 15;

  /// Calculate the total time of a workout.
  /// - [workout]: The workout to calculate the time for.
  /// - Returns: The total time of the workout in minutes.
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

  /// Create a string with information about the workout.
  /// - [workout]: The workout to create the information string for.
  /// - Returns: A string with information about the workout.
  ///
  String infoString(Workout workout) {
    String info = "";

    info += 'Intervals - ${workout.numExercises}\n';

    if (workout.workTime > 0) {
      info += 'Work Time - ${workout.workTime} sec\n';
    }

    if (workout.restTime > 0) {
      info += 'Rest Time - ${workout.restTime} sec\n';
    }

    info += 'Total Time - ${calculateWorkoutTime(workout)} min';

    return info;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(widget.workout.colorInt),
      child: InkWell(
        splashColor: Color(widget.workout.colorInt).withAlpha(80),
        onTap: () => widget.onWorkoutTap(widget.workout),
        child: CustomListTile(
          leading: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.workout.exercises.isNotEmpty
                        ? const Icon(
                            Icons.fitness_center,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.timer,
                            color: Colors.white,
                          ),
                  ])),
          title: widget.workout.title,
          titleStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.shortestSide < 550
                ? titleSmallTextSize
                : titleLargeTextSize,
            color: Colors.white,
          ),
          subtitle: infoString(widget.workout),
          subtitleStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.shortestSide < 550
                  ? subtitleSmallTextSize
                  : subtitleLargeTextSize,
              color: Colors.white),
          trailing: const Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.drag_handle,
                      color: Colors.white,
                    ),
                  ])),
        ),
      ),
    );
  }
}
