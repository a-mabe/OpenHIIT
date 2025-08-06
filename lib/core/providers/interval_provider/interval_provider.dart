import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/core/db/repositories/interval_repository.dart';
import 'package:openhiit/core/models/timer_type.dart';

class IntervalProvider extends ChangeNotifier {
  List<IntervalType> _intervals = [];
  List<IntervalType> get intervals => _intervals;

  final IntervalRepository _intervalRepository = IntervalRepository();

  Future<List<IntervalType>> loadIntervals(String timerId) async {
    _intervals = await _intervalRepository.getIntervalsByTimerId(timerId);
    notifyListeners();
    return _intervals;
  }

  void setIntervals(List<IntervalType> intervals) {
    _intervals = intervals;
    notifyListeners();
  }

  Future<List<IntervalType>> generateIntervalsFromTimer(TimerType timer) async {
    List<IntervalType> intervals = [];
    int idx = 0;

    void addInterval({
      required String id,
      required String name,
      required int time,
      required String startSound,
      String countdownSound = "",
      String halfwaySound = "",
      String endSound = "",
    }) {
      if (time > 0) {
        intervals.add(IntervalType(
          id: id,
          workoutId: timer.id,
          time: time,
          name: name,
          color: timer.color,
          intervalIndex: idx++,
          startSound: startSound,
          countdownSound: countdownSound,
          halfwaySound: halfwaySound,
          endSound: endSound,
        ));
      }
    }

    addInterval(
      id: "${timer.id}_get_ready",
      name: "Get Ready",
      time: timer.timeSettings.getReadyTime,
      startSound: "",
      countdownSound: timer.soundSettings.countdownSound,
    );

    addInterval(
      id: "${timer.id}_warmup",
      name: "Warmup",
      time: timer.timeSettings.warmupTime,
      startSound: timer.soundSettings.workSound,
      countdownSound: timer.soundSettings.countdownSound,
    );

    if (timer.timeSettings.warmupTime > 0) {
      addInterval(
        id: "${timer.id}_warmup_rest",
        name: "Rest",
        time: timer.timeSettings.restTime,
        startSound: timer.soundSettings.restSound,
        countdownSound: timer.soundSettings.countdownSound,
      );
    }

    int iterations =
        timer.timeSettings.restarts > 0 ? timer.timeSettings.restarts + 1 : 1;

    for (int iteration = 0; iteration < iterations; iteration++) {
      for (int i = 0; i < timer.activeIntervals; i++) {
        addInterval(
          id: "${timer.id}_work_${iteration}_$i",
          name: timer.activities.isEmpty || i >= timer.activities.length
              ? "Work"
              : timer.activities[i],
          time: timer.timeSettings.workTime,
          startSound: timer.soundSettings.workSound,
          countdownSound: timer.soundSettings.countdownSound,
          halfwaySound: timer.soundSettings.halfwaySound,
        );

        if (i < timer.activeIntervals - 1) {
          addInterval(
            id: "${timer.id}_rest_${iteration}_$i",
            name: "Rest",
            time: timer.timeSettings.restTime,
            startSound: timer.soundSettings.restSound,
            countdownSound: timer.soundSettings.countdownSound,
          );
        }
      }

      if (iteration < timer.timeSettings.restarts) {
        addInterval(
          id: "${timer.id}_break_$iteration",
          name: timer.timeSettings.breakTime > 0 ? "Break" : "Rest",
          time: timer.timeSettings.breakTime > 0
              ? timer.timeSettings.breakTime
              : timer.timeSettings.restTime,
          startSound: timer.soundSettings.restSound,
          countdownSound: timer.soundSettings.countdownSound,
        );
      }
    }

    addInterval(
      id: "${timer.id}_cooldown",
      name: "Cooldown",
      time: timer.timeSettings.cooldownTime,
      startSound: timer.soundSettings.restSound,
      countdownSound: timer.soundSettings.countdownSound,
    );

    if (intervals.isNotEmpty) {
      intervals.last.endSound = timer.soundSettings.endSound;
    }

    return intervals;
  }

  Future<void> saveIntervals(List<IntervalType> intervals) async {
    await _intervalRepository.insertIntervals(intervals);
    _intervals = intervals;
    notifyListeners();
  }

  Future<void> deleteIntervals(
      List<IntervalType> intervals, String timerId) async {
    await _intervalRepository.deleteIntervalsByTimerId(timerId);
    _intervals.removeWhere((interval) => intervals.contains(interval));
    notifyListeners();
  }
}
