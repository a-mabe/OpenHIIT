import 'package:flutter/material.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/models/timer/timer_time_settings.dart';
import 'package:openhiit/models/timer/timer_sound_settings.dart';
import 'package:openhiit/utils/functions.dart';

// For the in-progress timer creation
class TimerCreationNotifier extends ChangeNotifier {
  TimerType _timerDraft = TimerType.empty(); // A fresh timer draft
  TimerTimeSettings _timeSettings = TimerTimeSettings.empty();
  TimerSoundSettings _soundSettings = TimerSoundSettings.empty();

  TimerType get timerDraft => _timerDraft;

  void setTimerDraft(TimerType timer) {
    _timerDraft = timer.copy();
    notifyListeners();
  }

  void updateProperty(String key, dynamic value) {
    _timerDraft = _timerDraft.copyWith({key: value});
    notifyListeners();
  }

  void updateTimeSetting(String key, int value) {
    _timeSettings = _timeSettings.copyWith({key: value});
    _timerDraft = _timerDraft.copyWith({"timeSettings": _timeSettings});
    notifyListeners();
  }

  void updateSoundSetting(String key, String value) {
    _soundSettings = _soundSettings.copyWith({key: value});
    _timerDraft = _timerDraft.copyWith({"soundSettings": _soundSettings});
    notifyListeners();
  }

  void reset() {
    _timerDraft = TimerType.empty();
    _timeSettings = TimerTimeSettings.empty();
    _soundSettings = TimerSoundSettings.empty();
    notifyListeners();
  }
}
