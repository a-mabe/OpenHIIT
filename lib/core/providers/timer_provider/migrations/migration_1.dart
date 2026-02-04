import 'dart:convert';

import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:openhiit/core/db/repositories/interval_repository.dart';
import 'package:openhiit/core/db/repositories/timer_repository.dart';
import 'package:openhiit/core/providers/timer_provider/utils/functions.dart';
import 'package:openhiit/core/models/timer_sound_settings.dart';
import 'package:openhiit/core/models/timer_time_settings.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:openhiit/core/models/workout_type.dart';
import 'package:uuid/uuid.dart';

Future<void> workoutsMigration(
    List<Workout> workouts,
    IntervalRepository intervalRepository,
    TimerRepository timerRepository) async {
  for (var workout in workouts) {
    List<IntervalType> intervals = migrateToInterval(workout, false);
    await intervalRepository.insertIntervals(intervals);

    TimerType timer = migrateToTimer(workout, false);
    timer.totalTime = getTotalTime(intervals);
    await timerRepository.insertTimer(timer);
  }
}

TimerType migrateToTimer(Workout workout, bool update) {
  int totalIntervals = workout.iterations > 0
      ? workout.numExercises * workout.iterations
      : workout.numExercises;
  TimerType timer = TimerType(
      id: workout.id,
      name: workout.title,
      timerIndex: workout.workoutIndex,
      timeSettings: TimerTimeSettings(
        id: Uuid().v1(),
        timerId: workout.id,
        workTime: workout.workTime,
        restTime: workout.restTime,
        breakTime: workout.breakTime,
        warmupTime: workout.warmupTime,
        cooldownTime: workout.cooldownTime,
        getReadyTime: workout.getReadyTime,
      ),
      soundSettings: TimerSoundSettings(
        id: Uuid().v1(),
        timerId: workout.id,
        workSound: workout.workSound.contains("none") ? "" : workout.workSound,
        restSound: workout.restSound.contains("none") ? "" : workout.restSound,
        halfwaySound:
            workout.halfwaySound.contains("none") ? "" : workout.halfwaySound,
        endSound:
            workout.completeSound.contains("none") ? "" : workout.completeSound,
        countdownSound: workout.countdownSound.contains("none")
            ? ""
            : workout.countdownSound,
      ),
      color: workout.colorInt,
      intervals: totalIntervals,
      activeIntervals: workout.numExercises,
      restarts: workout.iterations,
      activities: workout.exercises != ""
          ? List<String>.from(jsonDecode(workout.exercises))
          : [],
      totalTime: 0);

  return timer;
}

List<IntervalType> migrateToInterval(Workout workout, bool update) {
  List<IntervalType> intervals = [];
  List<String> exercises = workout.exercises != ""
      ? List<String>.from(jsonDecode(workout.exercises))
      : [];
  int currentIndex = 0; // Track the index of each interval

  // Add get ready interval if time is non-zero
  if (workout.getReadyTime > 0) {
    intervals.add(IntervalType(
      id: "${workout.id}_get_ready",
      workoutId: workout.id,
      time: workout.getReadyTime,
      name: "Get Ready",
      color: workout.colorInt,
      intervalIndex: currentIndex++,
      startSound: "",
      countdownSound:
          workout.countdownSound != "none" ? workout.countdownSound : "",
      halfwaySound: "",
      endSound: "",
    ));
  }

  // Add warmup interval if time is non-zero
  if (workout.warmupTime > 0) {
    intervals.add(IntervalType(
      id: "${workout.id}_warmup",
      workoutId: workout.id,
      time: workout.warmupTime,
      name: "Warmup",
      color: workout.colorInt,
      intervalIndex: currentIndex++,
      startSound: workout.workSound != "none"
          ? workout.workSound
          : "", // Warmup uses work sound
      countdownSound:
          workout.countdownSound != "none" ? workout.countdownSound : "",
      halfwaySound: "",
      endSound: "",
    ));
  }

  // Loop for each iteration
  int iteration = 0;
  do {
    int exerciseIndex = 0;
    for (int i = 0; i < workout.numExercises; i++) {
      // Add work interval
      if (workout.workTime > 0) {
        intervals.add(IntervalType(
          id: "${workout.id}_work_${iteration}_$i",
          workoutId: workout.id,
          time: workout.workTime,
          name: (exercises.isEmpty || exerciseIndex > exercises.length)
              ? "Work"
              : exercises[exerciseIndex++],
          color: workout.colorInt,
          intervalIndex: currentIndex++,
          startSound: workout.workSound != "none" ? workout.workSound : "",
          countdownSound:
              workout.countdownSound != "none" ? workout.countdownSound : "",
          halfwaySound:
              workout.halfwaySound != "none" ? workout.halfwaySound : "",
          endSound:
              workout.completeSound != "none" ? workout.completeSound : "",
        ));
      }

      if (i < workout.numExercises - 1) {
        // Add rest interval
        if (workout.restTime > 0) {
          intervals.add(IntervalType(
            id: "${workout.id}_rest_${iteration}_$i",
            workoutId: workout.id,
            time: workout.restTime,
            name: "Rest",
            color: workout.colorInt,
            intervalIndex: currentIndex++,
            startSound: workout.restSound != "none" ? workout.restSound : "",
            countdownSound:
                workout.countdownSound != "none" ? workout.countdownSound : "",
            halfwaySound: "",
            endSound: "",
          ));
        }
      }
    }

    // Add break interval if time is non-zero, but only between iterations
    if (workout.breakTime > 0 &&
        iteration < (workout.iterations > 0 ? workout.iterations : 1)) {
      intervals.add(IntervalType(
        id: "${workout.id}_break_$iteration",
        workoutId: workout.id,
        time: workout.breakTime,
        name: "Break",
        color: workout.colorInt,
        intervalIndex: currentIndex++,
        startSound: workout.restSound != "none" ? workout.restSound : "",
        countdownSound:
            workout.countdownSound != "none" ? workout.countdownSound : "",
        halfwaySound: "",
        endSound: "",
      ));
    } else if (iteration < workout.iterations) {
      intervals.add(IntervalType(
        id: "${workout.id}_break_$iteration",
        workoutId: workout.id,
        time: workout.restTime,
        name: "Rest",
        color: workout.colorInt,
        intervalIndex: currentIndex++,
        startSound: workout.restSound != "none" ? workout.restSound : "",
        countdownSound:
            workout.countdownSound != "none" ? workout.countdownSound : "",
        halfwaySound: "",
        endSound: "",
      ));
    }

    iteration++;
  } while (iteration < (workout.iterations > 0 ? workout.iterations + 1 : 1));

  // Add cooldown interval if time is non-zero
  if (workout.cooldownTime > 0) {
    intervals.add(IntervalType(
      id: "${workout.id}_cooldown",
      workoutId: workout.id,
      time: workout.cooldownTime,
      name: "Cooldown",
      color: workout.colorInt,
      intervalIndex: currentIndex++,
      startSound: workout.restSound != "none"
          ? workout.restSound
          : "", // Cooldown uses rest sound
      countdownSound:
          workout.countdownSound != "none" ? workout.countdownSound : "",
      halfwaySound: "",
      endSound: workout.completeSound != "none" ? workout.completeSound : "",
    ));
  }

  return intervals;
}
