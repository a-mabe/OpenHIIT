import 'dart:convert';

import 'package:openhiit/models/timer/timer_sound_settings.dart';
import 'package:openhiit/models/timer/timer_time_settings.dart';
import 'package:uuid/uuid.dart';

import '../../utils/log/log.dart';

class TimerType {
  String id;
  String name;
  int timerIndex;
  int totalTime;
  int intervals;
  int activeIntervals;
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
        activities = [],
        showMinutes = 0,
        color = 4280391411;

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
        activities = map['activities'] != null
            ? List<String>.from(jsonDecode(map['activities']))
            : [],
        showMinutes = map['showMinutes'] ?? 0,
        color = map['color'] ?? 4280391411;

  TimerType copyWith(
      {String? id,
      String? name,
      TimerTimeSettings? timeSettings,
      TimerSoundSettings? soundSettings,
      int? totalTime,
      int? intervals,
      int? activeIntervals,
      List<String>? activities,
      int? color,
      int? showMinutes,
      int? timerIndex}) {
    return TimerType(
      id: id ?? this.id,
      name: name ?? this.name,
      timerIndex: timerIndex ?? this.timerIndex,
      timeSettings: timeSettings ?? this.timeSettings,
      soundSettings: soundSettings ?? this.soundSettings,
      totalTime: totalTime ?? this.totalTime,
      intervals: intervals ?? this.intervals,
      activeIntervals: activeIntervals ?? this.activeIntervals,
      activities: activities ?? this.activities,
      showMinutes: showMinutes ?? this.showMinutes,
      color: color ?? this.color,
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

    logger.d("time settings: $timeSettings");
    logger.d("sound settings: $soundSettings");

    return TimerType(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      timerIndex: json['timerIndex'] ?? 0,
      totalTime: json['totalTime'] ?? 0,
      intervals: json['intervals'] ?? 0,
      activeIntervals: json['activeIntervals'] ?? 0,
      activities: json['activities'].length > 0
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
    return 'TimerType{id: $id, name: $name, totalTime: $totalTime, intervals: $intervals, showMinutes: $showMinutes, activeIntervals: $activeIntervals, activities: $activities, color: $color, timerIndex: $timerIndex}';
  }
}
