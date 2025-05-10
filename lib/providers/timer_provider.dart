import 'dart:async';
import 'dart:convert';

import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/models/timer/timer_sound_settings.dart';
import 'package:openhiit/models/timer/timer_time_settings.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/models/timer/workout_type.dart';
import 'package:openhiit/utils/database/database_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:openhiit/utils/log/log.dart';
import 'package:uuid/uuid.dart';

class TimerProvider extends ChangeNotifier {
  List<Workout> _workouts = [];
  List<TimerType> _timers = [];

  List<Workout> get workouts => _workouts;
  List<TimerType> get timers => _timers;

  Future<List<TimerType>> loadWorkoutData() async {
    logger.d("Loading data");

    var dbManager = DatabaseManager();

    await dbManager.getWorkouts().then((workouts) async {
      _workouts = workouts;

      if (_workouts.isNotEmpty) {
        logger.d("${workouts.length} workouts found, migrating to intervals");
        for (var workout in _workouts) {
          List<IntervalType> intervals = migrateToInterval(workout, false);
          await addIntervals(intervals);
          TimerType timer = migrateToTimer(workout, false);
          timer.totalTime = calculateTotalTimeFromIntervals(intervals);
          logger.d("${timer.totalTime} total time for timer: ${timer.name}");
          await addTimer(timer);
        }
        await dbManager.deleteWorkoutTable();
      }
    });

    final prefs = await SharedPreferences.getInstance();
    bool hasRunWarmupMigration =
        prefs.getBool('hasRunWarmupMigration') ?? false;

    if (!hasRunWarmupMigration) {
      logger.i("Running warmup migration");

      await dbManager.getTimersWithSettings().then((timers) {
        _timers = timers;
      });

      for (var timer in _timers) {
        if (timer.timeSettings.warmupTime > 0) {
          logger.d(
              "Timer ${timer.name} has warmup time, adding warmup rest interval");

          // Retrieve the intervals for the timer
          List<IntervalType> intervals =
              await dbManager.getIntervalsByWorkoutId(timer.id);

          // Find the warmup interval
          final warmupInterval = intervals.firstWhere(
            (interval) => interval.name == "Warmup",
            orElse: () => IntervalType(
                id: "",
                workoutId: "",
                time: 0,
                name: "",
                color: 0,
                intervalIndex: 0,
                startSound: "",
                halfwaySound: "",
                countdownSound: "",
                endSound: ""),
          );

          if (warmupInterval.name == "Warmup") {
            // Create a new rest interval
            final restInterval = IntervalType(
              id: "${timer.id}_warmup_rest",
              workoutId: timer.id,
              time: timer.timeSettings.restTime,
              name: "Rest",
              color: timer.color,
              intervalIndex: warmupInterval.intervalIndex + 1,
              startSound: timer.soundSettings.restSound,
              countdownSound: timer.soundSettings.countdownSound,
              halfwaySound: "",
              endSound: "",
            );

            intervals.insert(warmupInterval.intervalIndex + 1, restInterval);

            // Update indices for subsequent intervals
            for (var interval in intervals) {
              if (interval.intervalIndex >= restInterval.intervalIndex &&
                  interval.id != restInterval.id) {
                interval.intervalIndex += 1;
              }
            }

            await addInterval(restInterval);
            await updateIntervals(intervals);
          }
        }
      }
      logger.i("Warmup migration completed");
      await prefs.setBool('hasRunWarmupMigration', true);
    }

    return dbManager.getTimersWithSettings().then((timers) {
      _timers = timers;
      return _timers;
    }).whenComplete(() {
      notifyListeners();
    });
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
              countdownSound: workout.countdownSound != "none"
                  ? workout.countdownSound
                  : "",
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
          restarts: workout.iterations,
        ),
        soundSettings: TimerSoundSettings(
          id: Uuid().v1(),
          timerId: workout.id,
          workSound:
              workout.workSound.contains("none") ? "" : workout.workSound,
          restSound:
              workout.restSound.contains("none") ? "" : workout.restSound,
          halfwaySound:
              workout.halfwaySound.contains("none") ? "" : workout.halfwaySound,
          endSound: workout.completeSound.contains("none")
              ? ""
              : workout.completeSound,
          countdownSound: workout.countdownSound.contains("none")
              ? ""
              : workout.countdownSound,
        ),
        color: workout.colorInt,
        intervals: totalIntervals,
        activeIntervals: workout.numExercises,
        activities: workout.exercises != ""
            ? List<String>.from(jsonDecode(workout.exercises))
            : [],
        totalTime: 0);

    return timer;
  }

  TimerTimeSettings migrateToTimerTimeSettings(Workout workout) {
    return TimerTimeSettings(
      id: Uuid().v1(),
      timerId: workout.id,
      getReadyTime: workout.getReadyTime,
      warmupTime: workout.warmupTime,
      workTime: workout.workTime,
      restTime: workout.restTime,
      breakTime: workout.breakTime,
      cooldownTime: workout.cooldownTime,
      restarts: workout.iterations,
    );
  }

  TimerSoundSettings migrateToTimerSoundSettings(Workout workout) {
    return TimerSoundSettings(
      id: Uuid().v1(),
      timerId: workout.id,
      workSound: workout.workSound.contains("none") ? "" : workout.workSound,
      restSound: workout.restSound.contains("none") ? "" : workout.restSound,
      halfwaySound:
          workout.halfwaySound.contains("none") ? "" : workout.halfwaySound,
      endSound:
          workout.completeSound.contains("none") ? "" : workout.completeSound,
      countdownSound:
          workout.countdownSound.contains("none") ? "" : workout.countdownSound,
    );
  }

  Future<List<IntervalType>> loadIntervalData() async {
    var dbManager = DatabaseManager();
    return dbManager.getIntervals().then((intervals) {
      // _intervals = intervals;
      intervals.sort((a, b) => a.intervalIndex.compareTo(b.intervalIndex));
      return intervals;
    });
  }

  Future<List<TimerType>> loadTimerData() async {
    var dbManager = DatabaseManager();
    return dbManager.getTimers().then((timers) {
      _timers = timers;
      return _timers;
    }).whenComplete(() {
      notifyListeners();
    });
  }

  Future<TimerTimeSettings> loadTimeSettingsByTimerId(
      String timerId, bool edit) async {
    if (edit) {
      var dbManager = DatabaseManager();
      return dbManager.getTimeSettingsByTimerId(timerId).then((timeSettings) {
        if (timeSettings == null) {
          throw Exception('TimerTimeSettings not found for timerId: $timerId');
        }
        return timeSettings;
      });
    } else {
      return TimerTimeSettings.empty();
    }
  }

  Future<TimerSoundSettings> loadSoundSettingsByTimerId(
      String timerId, bool edit) async {
    if (edit) {
      var dbManager = DatabaseManager();
      return dbManager.getSoundSettingsByTimerId(timerId).then((soundSettings) {
        if (soundSettings == null) {
          throw Exception('TimerSoundSettings not found for timerId: $timerId');
        }
        return soundSettings;
      });
    } else {
      return TimerSoundSettings.empty();
    }
  }

  Future<List<IntervalType>> generateIntervalsFromSettings(
      TimerType timer) async {
    List<IntervalType> intervals = [];
    int currentIndex = 0; // Track the index of each interval

    // Add get ready interval if time is non-zero
    if (timer.timeSettings.getReadyTime > 0) {
      intervals.add(IntervalType(
        id: "${timer.id}_get_ready",
        workoutId: timer.id,
        time: timer.timeSettings.getReadyTime,
        name: "Get Ready",
        color: timer.color,
        intervalIndex: currentIndex++,
        startSound: "",
        countdownSound: timer.soundSettings.countdownSound,
        halfwaySound: "",
        endSound: "",
      ));
    }

    // Add warmup interval if time is non-zero
    if (timer.timeSettings.warmupTime > 0) {
      intervals.add(IntervalType(
        id: "${timer.id}_warmup",
        workoutId: timer.id,
        time: timer.timeSettings.warmupTime,
        name: "Warmup",
        color: timer.color,
        intervalIndex: currentIndex++,
        startSound: timer.soundSettings.workSound, // Warmup uses work sound
        countdownSound: timer.soundSettings.countdownSound,
        halfwaySound: "",
        endSound: "",
      ));
      // Add rest after warmup
      intervals.add(IntervalType(
        id: "${timer.id}_warmup_rest",
        workoutId: timer.id,
        time: timer.timeSettings.restTime,
        name: "Rest",
        color: timer.color,
        intervalIndex: currentIndex++,
        startSound: timer.soundSettings.restSound,
        countdownSound: timer.soundSettings.countdownSound,
        halfwaySound: "",
        endSound: "",
      ));
    }

    // Loop for each iteration
    int iteration = 0;
    do {
      for (int i = 0; i < timer.activeIntervals; i++) {
        // Add work interval
        if (timer.timeSettings.workTime > 0) {
          intervals.add(IntervalType(
            id: "${timer.id}_work_${iteration}_$i",
            workoutId: timer.id,
            time: timer.timeSettings.workTime,
            name: timer.activities.isEmpty || i >= timer.activities.length
                ? "Work"
                : timer.activities[i],
            color: timer.color,
            intervalIndex: currentIndex++,
            startSound: timer.soundSettings.workSound,
            countdownSound: timer.soundSettings.countdownSound,
            halfwaySound: timer.soundSettings.halfwaySound,
            endSound: "",
          ));
        }

        if (i < timer.activeIntervals - 1) {
          // Add rest interval
          if (timer.timeSettings.restTime > 0) {
            intervals.add(IntervalType(
              id: "${timer.id}_rest_${iteration}_$i",
              workoutId: timer.id,
              time: timer.timeSettings.restTime,
              name: "Rest",
              color: timer.color,
              intervalIndex: currentIndex++,
              startSound: timer.soundSettings.restSound,
              countdownSound: timer.soundSettings.countdownSound,
              halfwaySound: "",
              endSound: "",
            ));
          }
        }
      }

      // Add break interval if time is non-zero, but only between iterations
      if (timer.timeSettings.breakTime > 0 &&
          iteration < timer.timeSettings.restarts) {
        intervals.add(IntervalType(
          id: "${timer.id}_break_$iteration",
          workoutId: timer.id,
          time: timer.timeSettings.breakTime,
          name: "Break",
          color: timer.color,
          intervalIndex: currentIndex++,
          startSound: timer.soundSettings.restSound,
          countdownSound: timer.soundSettings.countdownSound,
          halfwaySound: "",
          endSound: "",
        ));
      } else if (iteration < timer.timeSettings.restarts) {
        intervals.add(IntervalType(
          id: "${timer.id}_break_$iteration",
          workoutId: timer.id,
          time: timer.timeSettings.restTime,
          name: "Rest",
          color: timer.color,
          intervalIndex: currentIndex++,
          startSound: timer.soundSettings.restSound,
          countdownSound: timer.soundSettings.countdownSound,
          halfwaySound: "",
          endSound: "",
        ));
      }

      iteration++;
    } while (iteration <
        (timer.timeSettings.restarts > 0
            ? timer.timeSettings.restarts + 1
            : 1));

    // Add cooldown interval if time is non-zero
    if (timer.timeSettings.cooldownTime > 0) {
      intervals.add(IntervalType(
        id: "${timer.id}_cooldown",
        workoutId: timer.id,
        time: timer.timeSettings.cooldownTime,
        name: "Cooldown",
        color: timer.color,
        intervalIndex: currentIndex++,
        startSound: timer.soundSettings.restSound, // Cooldown uses rest sound
        countdownSound: timer.soundSettings.countdownSound,
        halfwaySound: "",
        endSound: "",
      ));
    }

    // Set the end sound for the last interval
    if (intervals.isNotEmpty) {
      intervals[intervals.length - 1].endSound = timer.soundSettings.endSound;
    }

    return intervals;
  }

  Future updateTimer(TimerType timer) async {
    logger.d("Timers: $timers");

    var dbManager = DatabaseManager();
    return dbManager.updateTimer(timer).then((_) async {
      var updated = false;
      for (var i = 0; i < _timers.length; i++) {
        if (_timers[i].id == timer.id) {
          _timers[i] = timer.copy();
          updated = true;
          break;
        }
      }
      if (!updated) {
        throw Exception('Unable to find timer with ID: ${timer.id}');
      }
      await dbManager.updateTimeSettingsByTimerId(
          timer.timeSettings.timerId, timer.timeSettings);
      await dbManager.updateSoundSettingsByTimerId(
          timer.soundSettings.timerId, timer.soundSettings);
    }).whenComplete(() => notifyListeners());
  }

  Future updateTimers(List<TimerType> timers) async {
    var dbManager = DatabaseManager();
    return dbManager.updateTimers(timers).then((_) {
      for (var timer in timers) {
        var updated = false;
        for (var i = 0; i < _timers.length; i++) {
          if (_timers[i].id == timer.id) {
            _timers[i] = timer.copy();
            updated = true;
            break;
          }
        }
        if (!updated) {
          throw Exception('Unable to find timer with ID: ${timer.id}');
        }
      }
    }).whenComplete(() => notifyListeners());
  }

  Future updateIntervals(List<IntervalType> intervals) async {
    var dbManager = DatabaseManager();
    return dbManager.updateIntervals(intervals);
  }

  Future addInterval(IntervalType interval) async {
    var dbManager = DatabaseManager();
    return dbManager.insertInterval(interval);
  }

  Future addIntervals(List<IntervalType> intervals) async {
    var dbManager = DatabaseManager();
    return dbManager.insertIntervals(intervals);
  }

  Future addTimer(TimerType timer) async {
    var dbManager = DatabaseManager();

    updateTimerIndices(1);
    List<TimerType> timers = sortTimers((d) => d.timerIndex, true);
    await updateTimers(timers);

    return dbManager.insertTimer(timer).then((val) async {
      _timers.add(timer);
      await dbManager.insertTimeSettings(timer.timeSettings);
      await dbManager.insertSoundSettings(timer.soundSettings);
    }).whenComplete(() => notifyListeners());
  }

  Future deleteTimer(TimerType timer) async {
    var dbManager = DatabaseManager();
    return dbManager.deleteTimer(timer.id).then((_) {
      _timers.removeWhere((t) => t.id == timer.id);
      updateTimerIndices(0);
      updateTimers(_timers);
    }).whenComplete(() => notifyListeners());
  }

  Future deleteIntervalsByWorkoutId(String workoutId) async {
    var dbManager = DatabaseManager();
    return dbManager.deleteIntervalsByWorkoutId(workoutId);
  }

  Future deleteTimeSettingsByTimerId(String timerId) async {
    var dbManager = DatabaseManager();
    return dbManager.deleteTimeSettingsByTimerId(timerId);
  }

  Future deleteSoundSettingsByTimerId(String timerId) async {
    var dbManager = DatabaseManager();
    return dbManager.deleteSoundSettingsByTimerId(timerId);
  }

  Future delete(TimerType timer) async {
    await deleteTimer(timer);
    await deleteIntervalsByWorkoutId(timer.id);
    await deleteTimeSettingsByTimerId(timer.id);
    await deleteSoundSettingsByTimerId(timer.id);
    updateTimerIndices(0);
    await updateTimers(timers);
  }

  void sort<T>(
    Comparable<T> Function(Workout workout) getField,
    bool ascending,
  ) {
    workouts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  List<TimerType> sortTimers<T>(
    Comparable<T> Function(TimerType timer) getField,
    bool ascending,
  ) {
    timers.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();

    return timers;
  }

  void updateTimerIndices(int start) {
    logger.d("Updating indices for ${_timers.length} timers");
    for (var i = 0; i < _timers.length; i++) {
      _timers[i] = _timers[i].copyWith({"timerIndex": start + i});
    }
    notifyListeners();
  }

  int calculateTotalTimeFromWorkout(Workout workout) {
    int totalTime = 0;

    // Add get ready time
    totalTime += workout.getReadyTime;

    // Add warmup time
    totalTime += workout.warmupTime;

    // Add work and rest time for each iteration
    int iteration = 0;
    do {
      for (int i = 0; i < workout.numExercises; i++) {
        totalTime += workout.workTime;
        totalTime += workout.restTime;
      }

      // Add break time if not last iteration
      if (iteration < workout.iterations - 1) {
        totalTime += workout.breakTime;
      }

      iteration++;
    } while (iteration < workout.iterations);

    // Add cooldown time
    totalTime += workout.cooldownTime;

    return totalTime;
  }

  int calculateTotalTimeFromTimer(TimerType timer) {
    int totalTime = 0;

    // Add get ready time
    totalTime += timer.timeSettings.getReadyTime;

    // Add warmup time
    totalTime += timer.timeSettings.warmupTime;

    // Add work and rest time for each iteration
    int iteration = 0;
    do {
      for (int i = 0; i < timer.activeIntervals; i++) {
        totalTime += timer.timeSettings.workTime;
        totalTime += timer.timeSettings.restTime;
      }

      // Add break time if not last iteration
      if (iteration < timer.timeSettings.restarts) {
        totalTime += timer.timeSettings.breakTime;
      }

      iteration++;
    } while (iteration < timer.timeSettings.restarts);

    // Add cooldown time
    totalTime += timer.timeSettings.cooldownTime;

    return totalTime;
  }

  int calculateTotalTimeFromIntervals(List<IntervalType> intervals) {
    int totalTime = 0;

    for (var interval in intervals) {
      totalTime += interval.time;
    }

    return totalTime;
  }

  Future submitNewWorkout(TimerType newTimer) async {
    if (newTimer.id == "") {
      newTimer.id = const Uuid().v4();
      newTimer.timeSettings.id = const Uuid().v4();
      newTimer.soundSettings.id = const Uuid().v4();
      newTimer.timeSettings.timerId = newTimer.id;
      newTimer.soundSettings.timerId = newTimer.id;

      List<IntervalType> newIntervals =
          await generateIntervalsFromSettings(newTimer);

      newTimer.totalTime = calculateTotalTimeFromIntervals(newIntervals);

      await addIntervals(newIntervals);
      await addTimer(newTimer);
    } else {
      await deleteIntervalsByWorkoutId(newTimer.id);
      await addIntervals(await generateIntervalsFromSettings(newTimer));
      await updateTimer(newTimer);
    }
  }
}
