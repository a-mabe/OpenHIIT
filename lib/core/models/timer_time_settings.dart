import 'package:uuid/uuid.dart';

class TimerTimeSettings {
  String id;
  String timerId;
  int workTime;
  int restTime;
  int breakTime;
  int warmupTime;
  int cooldownTime;
  int getReadyTime;

  TimerTimeSettings(
      {required this.id,
      required this.timerId,
      required this.workTime,
      required this.restTime,
      required this.breakTime,
      required this.warmupTime,
      required this.cooldownTime,
      required this.getReadyTime});

  TimerTimeSettings.empty()
      : id = "",
        timerId = "",
        workTime = 0,
        restTime = 0,
        breakTime = 0,
        warmupTime = 0,
        cooldownTime = 0,
        getReadyTime = 10;

  TimerTimeSettings copyWith(
    Map<String, int> map, {
    Map<String, dynamic>? updates,
  }) {
    return TimerTimeSettings(
      id: updates?['id'] ?? id,
      timerId: updates?['timerId'] ?? timerId,
      workTime: updates?['workTime'] ?? workTime,
      restTime: updates?['restTime'] ?? restTime,
      breakTime: updates?['breakTime'] ?? breakTime,
      warmupTime: updates?['warmupTime'] ?? warmupTime,
      cooldownTime: updates?['cooldownTime'] ?? cooldownTime,
      getReadyTime: updates?['getReadyTime'] ?? getReadyTime,
    );
  }

  TimerTimeSettings copyWithTimerId(String newTimerId) {
    String newId = Uuid().v1();

    return TimerTimeSettings(
      id: newId,
      timerId: newTimerId,
      workTime: workTime,
      restTime: restTime,
      breakTime: breakTime,
      warmupTime: warmupTime,
      cooldownTime: cooldownTime,
      getReadyTime: getReadyTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timerId': timerId,
      'workTime': workTime,
      'restTime': restTime,
      'breakTime': breakTime,
      'warmupTime': warmupTime,
      'cooldownTime': cooldownTime,
      'getReadyTime': getReadyTime,
    };
  }

  TimerTimeSettings.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? "",
        timerId = map['timerId'] ?? "",
        workTime = map['workTime'] ?? 0,
        restTime = map['restTime'] ?? 0,
        breakTime = map['breakTime'] ?? 0,
        warmupTime = map['warmupTime'] ?? 0,
        cooldownTime = map['cooldownTime'] ?? 0,
        getReadyTime = map['getReadyTime'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timerId': timerId,
      'workTime': workTime,
      'restTime': restTime,
      'breakTime': breakTime,
      'warmupTime': warmupTime,
      'cooldownTime': cooldownTime,
      'getReadyTime': getReadyTime,
    };
  }

  factory TimerTimeSettings.fromJson(Map<String, dynamic> json) {
    return TimerTimeSettings(
      id: json['id'] ?? "",
      timerId: json['timerId'] ?? "",
      workTime: json['workTime'] ?? 0,
      restTime: json['restTime'] ?? 0,
      breakTime: json['breakTime'] ?? 0,
      warmupTime: json['warmupTime'] ?? 0,
      cooldownTime: json['cooldownTime'] ?? 0,
      getReadyTime: json['getReadyTime'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'TimerTimeSettings{id: $id, timerId: $timerId, workTime: $workTime, restTime: $restTime, breakTime: $breakTime, warmupTime: $warmupTime, cooldownTime: $cooldownTime, getReadyTime: $getReadyTime}';
  }
}
