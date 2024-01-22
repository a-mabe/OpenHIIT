import 'dart:core';

class Workout {
  ///
  /// -------------
  /// FIELDS
  /// -------------
  ///

  /// The workout ID.
  ///
  late String id;

  /// The name of the to-do item.
  ///
  /// e.g., "Tuesday Workout"
  ///
  late String title;

  /// The number of exercises.
  ///
  /// e.g., "I need to do X but do it in Y way"
  ///
  late int numExercises;

  /// List of the exercises.
  ///
  /// e.g., ["Burpee", "Push-ups", "Rows"]
  ///
  late String exercises;

  /// Amount of time for an exercise, in seconds.
  ///
  /// e.g., 30
  ///
  late int exerciseTime;

  /// Amount of time between exercises, in seconds. (Rest time)
  ///
  /// e.g., 30
  ///
  late int restTime;

  /// Amount of time within an exercise to change sides, in seconds. (Half time)
  ///
  /// e.g., 5
  ///
  late int halfTime;

  late int halfwayMark;

  late String workSound;

  late String restSound;

  late String halfwaySound;

  late String completeSound;

  late String countdownSound;

  /// Color selected for the background of the workout
  ///
  /// e.g., 456787899
  ///
  late int colorInt;

  /// Index of the workout
  ///
  /// e.g., 6
  ///
  late int workoutIndex;

  /// Whether the timer should display minutes.
  ///
  /// e.g., 0 for false
  ///
  late int showMinutes;

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

  Workout(
      this.id,
      this.title,
      this.numExercises,
      this.exercises,
      this.exerciseTime,
      this.restTime,
      this.halfTime,
      this.halfwayMark,
      this.workSound,
      this.restSound,
      this.halfwaySound,
      this.completeSound,
      this.countdownSound,
      this.colorInt,
      this.workoutIndex,
      this.showMinutes);

  Workout.empty() {
    id = "";
    title = "";
    numExercises = 0;
    exercises = "";
    exerciseTime = 0;
    restTime = 0;
    halfTime = 0;
    halfwayMark = 0;
    workSound = "short-whistle";
    restSound = "short-rest-beep";
    halfwaySound = "short-halfway-beep";
    countdownSound = "countdown-beep";
    completeSound = "long-bell";
    colorInt = 4280391411;
    workoutIndex = 0;
    showMinutes = 0;
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
      'id': id,
      'title': title,
      'numExercises': numExercises,
      'exercises': exercises,
      'exerciseTime': exerciseTime,
      'restTime': restTime,
      'halfTime': halfTime,
      'halfwayMark': halfwayMark,
      'workSound': workSound,
      'restSound': restSound,
      'halfwaySound': halfwaySound,
      'completeSound': completeSound,
      'countdownSound': countdownSound,
      'colorInt': colorInt,
      'workoutIndex': workoutIndex,
      'showMinutes': showMinutes,
    };
  }

  /// Implement toString to print information about
  /// each Workout more easily.
  ///
  @override
  String toString() {
    return 'Workout{id: $id,title: $title, numExercises: $numExercises, exercises: $exercises, exerciseTime: $exerciseTime, restTime: $restTime, halfTime: $halfTime, halfwayMark: $halfwayMark, colorInt: $colorInt, index: $workoutIndex}';
  }

  ///
  /// -------------
  /// END FUNCTIONS
  /// -------------
  ///
}
