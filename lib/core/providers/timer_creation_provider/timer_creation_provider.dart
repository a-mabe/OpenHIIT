import 'package:flutter/material.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:uuid/uuid.dart';

class TimerCreationProvider extends ChangeNotifier {
  TimerType _timer = TimerType.empty();

  TimerType get timer => _timer;

  bool _isEdited = false;
  bool get isEdited => _isEdited;

  bool get breakEnabled => _timer.restarts > 0;

  void markEdited() {
    if (!_isEdited) {
      _isEdited = true;
      notifyListeners();
    }
  }

  void clear() {
    final timerId = Uuid().v4();
    _timer = TimerType.empty()..id = timerId;
    _timer.timeSettings.id = Uuid().v4();
    _timer.timeSettings.timerId = timerId;
    _timer.soundSettings.id = Uuid().v4();
    _timer.soundSettings.timerId = timerId;
    _isEdited = false;
    notifyListeners();
  }

  void setTimer(TimerType timer, {bool notify = true}) {
    _timer = timer.copy(); // or TimerType.fromJson(timer.toJson());

    _isEdited = false;

    if (notify) {
      notifyListeners();
    }
  }

  void setTimerName(String name) {
    _timer = _timer.copyWith({
      'name': name,
    });
    _isEdited = true;
    notifyListeners();
  }

  void setTimerColor(int color) {
    _timer = _timer.copyWith({
      'color': color,
    });
    _isEdited = true;
    notifyListeners();
  }

  void setTimerShowMinutes(int showMinutes) {
    _timer = _timer.copyWith({
      'showMinutes': showMinutes,
    });
    _isEdited = true;
    notifyListeners();
  }

  void setActiveIntervals(int intervals) {
    _timer = _timer.copyWith({
      'activeIntervals': intervals,
    });
    _isEdited = true;
    notifyListeners();
  }

  void setRestarts(int restarts) {
    _timer = _timer.copyWith({
      'restarts': restarts,
    });
    _isEdited = true;
    notifyListeners();
  }

  void setTotalTime(int totalTime) {
    _timer = _timer.copyWith({
      'totalTime': totalTime,
    });
    // This happens on save, so no need to mark as edited.
    notifyListeners();
  }

  void setTimerTimeSettingPart({
    int? workTime,
    int? restTime,
    int? breakTime,
    int? warmupTime,
    int? cooldownTime,
    int? getReadyTime,
  }) {
    _timer.timeSettings = _timer.timeSettings.copyWith({}, updates: {
      if (workTime != null) 'workTime': workTime,
      if (restTime != null) 'restTime': restTime,
      if (breakTime != null) 'breakTime': breakTime,
      if (warmupTime != null) 'warmupTime': warmupTime,
      if (cooldownTime != null) 'cooldownTime': cooldownTime,
      if (getReadyTime != null) 'getReadyTime': getReadyTime,
    });
    _timer = _timer.copyWith({
      'timeSettings': _timer.timeSettings,
    });
    _isEdited = true;
    notifyListeners();
  }

  void setTimerSoundSettingPart({
    String? workSound,
    String? restSound,
    String? halfwaySound,
    String? endSound,
    String? countdownSound,
  }) {
    _timer.soundSettings = _timer.soundSettings.copyWith({}, updates: {
      if (workSound != null) 'workSound': workSound,
      if (restSound != null) 'restSound': restSound,
      if (halfwaySound != null) 'halfwaySound': halfwaySound,
      if (endSound != null) 'endSound': endSound,
      if (countdownSound != null) 'countdownSound': countdownSound,
    });
    _timer = _timer.copyWith({
      'soundSettings': _timer.soundSettings,
    });
    _isEdited = true;
    notifyListeners();
  }
}
