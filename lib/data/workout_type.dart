class Workout {
  String id;
  String title;
  int numExercises;
  String exercises;
  int getReadyTime;
  int workTime;
  int restTime;
  int halfTime;
  int breakTime;
  int warmupTime;
  int cooldownTime;
  int iterations;
  int halfwayMark;
  String workSound;
  String restSound;
  String halfwaySound;
  String completeSound;
  String countdownSound;
  int colorInt;
  int workoutIndex;
  int showMinutes;

  // Main constructor
  Workout({
    required this.id,
    required this.title,
    required this.numExercises,
    required this.exercises,
    this.getReadyTime = 10,
    this.workTime = 0,
    this.restTime = 0,
    this.halfTime = 0,
    this.breakTime = 0,
    this.warmupTime = 0,
    this.cooldownTime = 0,
    this.iterations = 0,
    this.halfwayMark = 0,
    this.workSound = "short-whistle",
    this.restSound = "short-rest-beep",
    this.halfwaySound = "short-halfway-beep",
    this.completeSound = "long-bell",
    this.countdownSound = "countdown-beep",
    this.colorInt = 4280391411,
    this.workoutIndex = 0,
    this.showMinutes = 0,
  });

  // Named constructor for empty workouts
  Workout.empty()
      : id = "",
        title = "",
        numExercises = 0,
        exercises = "",
        getReadyTime = 10,
        workTime = 0,
        restTime = 0,
        halfTime = 0,
        breakTime = 0,
        warmupTime = 0,
        cooldownTime = 0,
        iterations = 0,
        halfwayMark = 0,
        workSound = "short-whistle",
        restSound = "short-rest-beep",
        halfwaySound = "short-halfway-beep",
        completeSound = "long-bell",
        countdownSound = "countdown-beep",
        colorInt = 4280391411,
        workoutIndex = 0,
        showMinutes = 0;

  // Create a copy
  Workout copy() => Workout(
        id: id,
        title: title,
        numExercises: numExercises,
        exercises: exercises,
        getReadyTime: getReadyTime,
        workTime: workTime,
        restTime: restTime,
        halfTime: halfTime,
        breakTime: breakTime,
        warmupTime: warmupTime,
        cooldownTime: cooldownTime,
        iterations: iterations,
        halfwayMark: halfwayMark,
        workSound: workSound,
        restSound: restSound,
        halfwaySound: halfwaySound,
        completeSound: completeSound,
        countdownSound: countdownSound,
        colorInt: colorInt,
        workoutIndex: workoutIndex,
        showMinutes: showMinutes,
      );

  Map<String, dynamic> toMap() => {
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

  Workout.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? "",
        title = map['title'] ?? "",
        numExercises = map['numExercises'] ?? 0,
        exercises = map['exercises'] ?? "",
        getReadyTime = map['getReadyTime'] ?? 10,
        workTime = map['exerciseTime'] ?? 0,
        restTime = map['restTime'] ?? 0,
        halfTime = map['halfTime'] ?? 0,
        breakTime = map['breakTime'] ?? 0,
        warmupTime = map['warmupTime'] ?? 0,
        cooldownTime = map['cooldownTime'] ?? 0,
        iterations = map['iterations'] ?? 0,
        halfwayMark = map['halfwayMark'] ?? 0,
        workSound = map['workSound'] ?? "short-whistle",
        restSound = map['restSound'] ?? "short-rest-beep",
        halfwaySound = map['halfwaySound'] ?? "short-halfway-beep",
        completeSound = map['completeSound'] ?? "long-bell",
        countdownSound = map['countdownSound'] ?? "countdown-beep",
        colorInt = map['colorInt'] ?? 4280391411,
        workoutIndex = map['workoutIndex'] ?? 0,
        showMinutes = map['showMinutes'] ?? 0;

  // Convert to JSON
  Map<String, dynamic> toJson() => toMap();

  // Create from JSON
  factory Workout.fromJson(Map<String, dynamic> json) => Workout.fromMap(json);

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
      id: id ?? this.id,
      title: title ?? this.title,
      numExercises: numExercises ?? this.numExercises,
      exercises: exercises ?? this.exercises,
      getReadyTime: getReadyTime ?? this.getReadyTime,
      workTime: workTime ?? this.workTime,
      restTime: restTime ?? this.restTime,
      halfTime: halfTime ?? this.halfTime,
      breakTime: breakTime ?? this.breakTime,
      warmupTime: warmupTime ?? this.warmupTime,
      cooldownTime: cooldownTime ?? this.cooldownTime,
      iterations: iterations ?? this.iterations,
      halfwayMark: halfwayMark ?? this.halfwayMark,
      workSound: workSound ?? this.workSound,
      restSound: restSound ?? this.restSound,
      halfwaySound: halfwaySound ?? this.halfwaySound,
      completeSound: completeSound ?? this.completeSound,
      countdownSound: countdownSound ?? this.countdownSound,
      colorInt: colorInt ?? this.colorInt,
      workoutIndex: workoutIndex ?? this.workoutIndex,
      showMinutes: showMinutes ?? this.showMinutes,
    );
  }

  @override
  String toString() {
    return 'Workout{id: $id, title: $title, numExercises: $numExercises, exercises: $exercises, getReadyTime: $getReadyTime, workTime: $workTime, restTime: $restTime, halfTime: $halfTime, halfwayMark: $halfwayMark, colorInt: $colorInt, index: $workoutIndex, warmupTime: $warmupTime, cooldownTime: $cooldownTime, breakTime: $breakTime, iterations: $iterations}';
  }
}
