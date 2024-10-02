import 'dart:core';

class Workout {
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

  /// List of the exercises, JSON encoded string.
  ///
  /// e.g., ["Burpee", "Push-ups", "Rows"]
  ///
  late String exercises;

  /// Amount of time to count down to the timer start, in seconds.
  ///
  /// e.g., 10
  ///
  late int getReadyTime;

  /// Amount of time for an exercise, in seconds.
  ///
  /// e.g., 30
  ///
  late int workTime;

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

  /// Amount of time for breaks between exercise cycles, in seconds.
  ///
  /// e.g., 60
  ///
  late int breakTime;

  /// Amount of time dedicated to warm-up before the exercise routine starts, in seconds.
  ///
  /// e.g., 120
  ///
  late int warmupTime;

  /// Amount of time dedicated to cooldown after completing the exercise routine, in seconds.
  ///
  /// e.g., 90
  ///
  late int cooldownTime;

  /// The total number of exercise cycles or iterations in the routine.
  ///
  /// e.g., 5
  ///
  late int iterations;

  /// The time mark, in seconds, at which the exercise routine is considered halfway completed.
  ///
  /// e.g., 300
  ///
  late int halfwayMark;

  /// The sound file associated with the work phase of the exercise routine.
  ///
  /// e.g., "work_sound.mp3"
  ///
  late String workSound;

  /// The sound file associated with the rest phase of the exercise routine.
  ///
  /// e.g., "rest_sound.mp3"
  ///
  late String restSound;

  /// The sound file played at the halfway mark of the exercise routine.
  ///
  /// e.g., "halfway_sound.mp3"
  ///
  late String halfwaySound;

  /// The sound file played upon completing the entire exercise routine.
  ///
  /// e.g., "complete_sound.mp3"
  ///
  late String completeSound;

  /// The sound file played during countdowns or preparations.
  ///
  /// e.g., "countdown_sound.mp3"
  ///
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

  Workout(
      this.id,
      this.title,
      this.numExercises,
      this.exercises,
      this.getReadyTime,
      this.workTime,
      this.restTime,
      this.halfTime,
      this.breakTime,
      this.warmupTime,
      this.cooldownTime,
      this.iterations,
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
    getReadyTime = 10;
    workTime = 0;
    restTime = 0;
    halfTime = 0;
    breakTime = 0;
    warmupTime = 0;
    cooldownTime = 0;
    iterations = 0;
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'numExercises': numExercises,
      'exercises': exercises,
      'getReadyTime': getReadyTime,
      'exerciseTime': workTime,
      'restTime': restTime,
      'halfTime': halfTime,
      'breakTime': breakTime,
      'warmupTime': warmupTime,
      'cooldownTime': cooldownTime,
      'iterations': iterations,
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

  Workout.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    numExercises = map['numExercises'];
    exercises = map['exercises'];
    getReadyTime = map['getReadyTime'];
    workTime = map['exerciseTime'];
    restTime = map['restTime'];
    halfTime = map['halfTime'];
    breakTime = map['breakTime'];
    warmupTime = map['warmupTime'];
    cooldownTime = map['cooldownTime'];
    iterations = map['iterations'];
    halfwayMark = map['halfwayMark'];
    workSound = map['workSound'];
    restSound = map['restSound'];
    halfwaySound = map['halfwaySound'];
    completeSound = map['completeSound'];
    countdownSound = map['countdownSound'];
    colorInt = map['colorInt'];
    workoutIndex = map['workoutIndex'];
    showMinutes = map['showMinutes'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'numExercises': numExercises,
      'exercises': exercises,
      'getReadyTime': getReadyTime,
      'exerciseTime': workTime,
      'restTime': restTime,
      'halfTime': halfTime,
      'breakTime': breakTime,
      'warmupTime': warmupTime,
      'cooldownTime': cooldownTime,
      'iterations': iterations,
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

  Workout.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    numExercises = json['numExercises'];
    exercises = json['exercises'];
    getReadyTime = json['getReadyTime'];
    workTime = json['exerciseTime'];
    restTime = json['restTime'];
    halfTime = json['halfTime'];
    breakTime = json['breakTime'];
    warmupTime = json['warmupTime'];
    cooldownTime = json['cooldownTime'];
    iterations = json['iterations'];
    halfwayMark = json['halfwayMark'];
    workSound = json['workSound'];
    restSound = json['restSound'];
    halfwaySound = json['halfwaySound'];
    completeSound = json['completeSound'];
    countdownSound = json['countdownSound'];
    colorInt = json['colorInt'];
    workoutIndex = json['workoutIndex'];
    showMinutes = json['showMinutes'];
  }

  Workout copy() {
    return Workout(
      id,
      title,
      numExercises,
      exercises,
      getReadyTime,
      workTime,
      restTime,
      halfTime,
      breakTime,
      warmupTime,
      cooldownTime,
      iterations,
      halfwayMark,
      workSound,
      restSound,
      halfwaySound,
      completeSound,
      countdownSound,
      colorInt,
      workoutIndex,
      showMinutes,
    );
  }

  Workout copyWith({
    String? id,
    String? title,
    int? numExercises,
    String? exercises,
    int? getReadyTime,
    int? workTime,
    int? restTime,
    int? halfTime,
    int? breakTime,
    int? warmupTime,
    int? cooldownTime,
    int? iterations,
    int? halfwayMark,
    String? workSound,
    String? restSound,
    String? halfwaySound,
    String? completeSound,
    String? countdownSound,
    int? colorInt,
    int? workoutIndex,
    int? showMinutes,
  }) {
    return Workout(
      id ?? this.id,
      title ?? this.title,
      numExercises ?? this.numExercises,
      exercises ?? this.exercises,
      getReadyTime ?? this.getReadyTime,
      workTime ?? this.workTime,
      restTime ?? this.restTime,
      halfTime ?? this.halfTime,
      breakTime ?? this.breakTime,
      warmupTime ?? this.warmupTime,
      cooldownTime ?? this.cooldownTime,
      iterations ?? this.iterations,
      halfwayMark ?? this.halfwayMark,
      workSound ?? this.workSound,
      restSound ?? this.restSound,
      halfwaySound ?? this.halfwaySound,
      completeSound ?? this.completeSound,
      countdownSound ?? this.countdownSound,
      colorInt ?? this.colorInt,
      workoutIndex ?? this.workoutIndex,
      showMinutes ?? this.showMinutes,
    );
  }

  /// Implement toString to print information about
  /// each Workout more easily.
  ///
  @override
  String toString() {
    return 'Workout{id: $id, title: $title, numExercises: $numExercises, exercises: $exercises, getReadyTime: $getReadyTime, workTime: $workTime, restTime: $restTime, halfTime: $halfTime, halfwayMark: $halfwayMark, colorInt: $colorInt, index: $workoutIndex, warmupTime: $warmupTime, cooldownTime: $cooldownTime, breakTime: $breakTime, iterations: $iterations}';
  }

  ///
  /// -------------
  /// END FUNCTIONS
  /// -------------
  ///
}
