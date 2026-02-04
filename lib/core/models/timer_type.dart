import 'dart:convert';

import 'package:openhiit/core/models/timer_sound_settings.dart';
import 'package:openhiit/core/models/timer_time_settings.dart';
import 'package:uuid/uuid.dart';

class TimerType {
  String id;
  String name;
  int timerIndex;
  int totalTime;
  int intervals;
  int activeIntervals;
  int restarts;
  List<String> activities;
  int showMinutes;
  int color;
  TimerTimeSettings timeSettings;
  TimerSoundSettings soundSettings;

  TimerType({
    required this.id,
    required this.name,
    required this.timerIndex,
    required this.timeSettings,
    required this.soundSettings,
    this.totalTime = 0,
    this.intervals = 0,
    this.activeIntervals = 0,
    this.restarts = 0,
    this.activities = const [],
    this.showMinutes = 0,
    this.color = 4280391411, // blue
  });

  TimerType.empty()
      : id = "",
        name = "",
        timerIndex = 0,
        timeSettings = TimerTimeSettings.empty(),
        soundSettings = TimerSoundSettings.empty(),
        totalTime = 0,
        intervals = 0,
        activeIntervals = 0,
        restarts = 0,
        activities = [],
        showMinutes = 0,
        color = 4280391411; // blue

  TimerType copy() {
    return TimerType(
      id: id,
      name: name,
      timerIndex: timerIndex,
      timeSettings: timeSettings,
      soundSettings: soundSettings,
      totalTime: totalTime,
      intervals: intervals,
      activeIntervals: activeIntervals,
      restarts: restarts,
      activities: activities,
      showMinutes: showMinutes,
      color: color,
    );
  }

  TimerType copyNew() {
    String newId = Uuid().v1();

    return TimerType(
      id: newId,
      name: name,
      timerIndex: timerIndex,
      timeSettings: timeSettings.copyWithTimerId(newId),
      soundSettings: soundSettings.copyWithTimerId(newId),
      totalTime: totalTime,
      intervals: intervals,
      activeIntervals: activeIntervals,
      restarts: restarts,
      activities: activities,
      showMinutes: showMinutes,
      color: color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'timerIndex': timerIndex,
      'totalTime': totalTime,
      'intervals': intervals,
      'activeIntervals': activeIntervals,
      'restarts': restarts,
      'activities': jsonEncode(activities),
      'showMinutes': showMinutes,
      'color': color,
    };
  }

  TimerType.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? "",
        name = map['name'] ?? "",
        timerIndex = map['timerIndex'] ?? 0,
        timeSettings = TimerTimeSettings.fromMap(map),
        soundSettings = TimerSoundSettings.fromMap(map),
        totalTime = map['totalTime'] ?? 0,
        intervals = map['intervals'] ?? 0,
        activeIntervals = map['activeIntervals'] ?? 0,
        restarts = map['restarts'] ?? 0,
        activities = map['activities'] != null
            ? List<String>.from(jsonDecode(map['activities']))
            : [],
        showMinutes = map['showMinutes'] ?? 0,
        color = map['color'] ?? 4280391411;

  TimerType copyWith(Map<String, dynamic> updates) {
    return TimerType(
      id: updates['id'] ?? id,
      name: updates['name'] ?? name,
      timerIndex: updates['timerIndex'] ?? timerIndex,
      timeSettings: updates['timeSettings'] is TimerTimeSettings
          ? updates['timeSettings']
          : updates['timeSettings'] != null
              ? TimerTimeSettings.fromJson(updates['timeSettings'])
              : timeSettings,
      soundSettings: updates['soundSettings'] is TimerSoundSettings
          ? updates['soundSettings']
          : updates['soundSettings'] != null
              ? TimerSoundSettings.fromJson(updates['soundSettings'])
              : soundSettings,
      totalTime: updates['totalTime'] ?? totalTime,
      intervals: updates['intervals'] ?? intervals,
      activeIntervals: updates['activeIntervals'] ?? activeIntervals,
      restarts: updates['restarts'] ?? restarts,
      activities: updates['activities'] ?? activities,
      showMinutes: updates['showMinutes'] ?? showMinutes,
      color: updates['color'] ?? color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'timerIndex': timerIndex,
      'totalTime': totalTime,
      'intervals': intervals,
      'activeIntervals': activeIntervals,
      'restarts': restarts,
      'activities': activities,
      'showMinutes': showMinutes,
      'color': color,
      'timeSettings': timeSettings.toJson(),
      'soundSettings': soundSettings.toJson(),
    };
  }

  factory TimerType.fromJson(Map<String, dynamic> json) {
    final timeSettings = json['timeSettings'];
    final soundSettings = json['soundSettings'];

    return TimerType(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      timerIndex: json['timerIndex'] ?? 0,
      totalTime: json['totalTime'] ?? 0,
      intervals: json['intervals'] ?? 0,
      activeIntervals: json['activeIntervals'] ?? 0,
      restarts: json['restarts'] ?? 0,
      activities: (json['activities'] != null && json['activities'] is List)
          ? List<String>.from(json['activities'])
          : [],
      showMinutes: json['showMinutes'] ?? 0,
      color: json['color'] ?? 4280391411,
      timeSettings: timeSettings is String
          ? TimerTimeSettings.fromJson(
              jsonDecode(timeSettings) as Map<String, dynamic>)
          : TimerTimeSettings.fromJson(timeSettings),
      soundSettings: soundSettings is String
          ? TimerSoundSettings.fromJson(
              jsonDecode(soundSettings) as Map<String, dynamic>)
          : TimerSoundSettings.fromJson(soundSettings),
    );
  }

  @override
  String toString() {
    return 'TimerType{id: $id, name: $name, totalTime: $totalTime, intervals: $intervals, showMinutes: $showMinutes, activeIntervals: $activeIntervals, restarts: $restarts, activities: $activities, color: $color, timerIndex: $timerIndex}';
  }
}
