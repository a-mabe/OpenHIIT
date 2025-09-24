import 'package:flutter/material.dart';
import 'package:openhiit/core/models/timer_sound_settings.dart';
import 'package:openhiit/core/models/timer_time_settings.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:uuid/uuid.dart';

class TimerCreationProvider extends ChangeNotifier {
  TimerType _timer = TimerType.empty();
  TimerTimeSettings _timeSettings = TimerTimeSettings.empty();
  TimerSoundSettings _soundSettings = TimerSoundSettings.empty();

  TimerType get timer => _timer;
  TimerTimeSettings get timeSettings => _timeSettings;
  TimerSoundSettings get soundSettings => _soundSettings;

  bool _isEdited = false;
  bool get isEdited => _isEdited;

  bool get breakEnabled => _timeSettings.restarts > 0;

  void markEdited() {
    if (!_isEdited) {
      _isEdited = true;
      notifyListeners();
    }
  }

  void clear() {
    _timer = TimerType.empty();
    _timer.id = Uuid().v4();
    _timeSettings = TimerTimeSettings.empty();
    _soundSettings = TimerSoundSettings.empty();
    _isEdited = false;
    notifyListeners();
  }

  void setTimer(TimerType timer, {bool notify = true}) {
    _timer = timer.copy(); // or TimerType.fromJson(timer.toJson());

    _timeSettings = _timer.timeSettings;
    _soundSettings = _timer.soundSettings;

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

  void setActiveIntervals(int intervals) {
    _timer = _timer.copyWith({
      'activeIntervals': intervals,
    });
    _isEdited = true;
    notifyListeners();
  }

  void setTimerTimeSettingPart({
    int? workTime,
    int? restTime,
    int? breakTime,
    int? warmupTime,
    int? cooldownTime,
    int? getReadyTime,
    int? restarts,
  }) {
    _timeSettings = _timeSettings.copyWith({}, updates: {
      if (workTime != null) 'workTime': workTime,
      if (restTime != null) 'restTime': restTime,
      if (breakTime != null) 'breakTime': breakTime,
      if (warmupTime != null) 'warmupTime': warmupTime,
      if (cooldownTime != null) 'cooldownTime': cooldownTime,
      if (getReadyTime != null) 'getReadyTime': getReadyTime,
      if (restarts != null) 'restarts': restarts,
    });
    _timer = _timer.copyWith({
      'timeSettings': _timeSettings,
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
    _soundSettings = _soundSettings.copyWith({}, updates: {
      if (workSound != null) 'workSound': workSound,
      if (restSound != null) 'restSound': restSound,
      if (halfwaySound != null) 'halfwaySound': halfwaySound,
      if (endSound != null) 'endSound': endSound,
      if (countdownSound != null) 'countdownSound': countdownSound,
    });
    _timer = _timer.copyWith({
      'soundSettings': _soundSettings,
    });
    _isEdited = true;
    notifyListeners();
  }
}
