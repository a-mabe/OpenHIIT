import 'package:flutter/material.dart';
import 'package:openhiit/core/models/timer_sound_settings.dart';
import 'package:openhiit/core/models/timer_time_settings.dart';
import 'package:openhiit/core/models/timer_type.dart';

class TimerCreationProvider extends ChangeNotifier {
  TimerType _timer = TimerType.empty();
  TimerTimeSettings _timeSettings = TimerTimeSettings.empty();
  TimerSoundSettings _soundSettings = TimerSoundSettings.empty();

  TimerType get timer => _timer;
  TimerTimeSettings get timeSettings => _timeSettings;
  TimerSoundSettings get soundSettings => _soundSettings;
}
