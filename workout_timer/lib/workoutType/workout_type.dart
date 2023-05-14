import 'dart:core';
import 'dart:ffi';

class Workout {
  ///
  /// -------------
  /// FIELDS
  /// -------------
  ///

  /// The workout ID.
  ///
  String id = "";

  /// The name of the to-do item.
  ///
  /// e.g., "Tuesday Workout"
  ///
  String title = "";

  /// The number of exercises.
  ///
  /// e.g., "I need to do X but do it in Y way"
  ///
  int numExercises = 0;

  /// List of the exercises.
  ///
  /// e.g., ["Burpee", "Push-ups", "Rows"]
  ///
  String exercises = "";

  /// Amount of time for an exercise, in seconds.
  ///
  /// e.g., 30
  ///
  int exerciseTime = 0;

  /// Amount of time between exercises, in seconds. (Rest time)
  ///
  /// e.g., 30
  ///
  int restTime = 0;

  /// Amount of time within an exercise to change sides, in seconds. (Half time)
  ///
  /// e.g., 5
  ///
  int halfTime = 0;

  ///
  /// -------------
  /// END FIELDS
  /// -------------
  ///

  ///
  /// -------------
  /// CONSTRUCTORS
  /// -------------
  ///
  // Workout(
  //     {required this.title,
  //     required this.numExercises,
  //     required this.exercises,
  //     required this.exerciseTime,
  //     required this.restTime,
  //     required this.halfTime});

  Workout(this.title, this.numExercises, this.exercises, this.exerciseTime,
      this.halfTime, this.restTime, this.id);

  Workout.empty() {
    title = "";
    numExercises = 0;
    exercises = "";
    exerciseTime = 0;
    restTime = 0;
    halfTime = 0;
    id = "";
  }

  ///
  /// -------------
  /// END CONSTRUCTORS
  /// -------------
  ///
  ///
  /// -------------
  /// FUNCTIONS
  /// -------------
  ///
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'numExercises': numExercises,
      'exercises': exercises,
      'exerciseTime': exerciseTime,
      'restTime': restTime,
      'halfTime': halfTime
    };
  }

  /// Implement toString to print information about
  /// each Workout more easily.
  ///
  @override
  String toString() {
    return 'Workout{title: $title, numExercises: $numExercises, exercises: $exercises, exerciseTime: $exerciseTime, restTime: $restTime, halfTime: $halfTime}';
  }

  ///
  /// -------------
  /// END FUNCTIONS
  /// -------------
  ///
}
