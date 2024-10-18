class IntervalType {
  String id;
  String workoutId;
  int time;
  String name;
  int color;
  int intervalIndex;
  String sound;
  String? halfwaySound;

  IntervalType(
      {required this.id,
      required this.workoutId,
      required this.time,
      required this.name,
      required this.color,
      required this.intervalIndex,
      required this.sound,
      this.halfwaySound});

  // Convert an Interval object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workoutId': workoutId,
      'time': time,
      'name': name,
      'color': color,
      'intervalIndex': intervalIndex,
      'sound': sound,
      'halfwaySound': halfwaySound,
    };
  }

  // Copy an Interval object with optional new values
  IntervalType copy(
      {String? id,
      String? workoutId,
      int? time,
      String? name,
      int? color,
      int? intervalIndex,
      String? sound,
      String? halfwaySound}) {
    return IntervalType(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      time: time ?? this.time,
      name: name ?? this.name,
      color: color ?? this.color,
      intervalIndex: intervalIndex ?? this.intervalIndex,
      sound: sound ?? this.sound,
      halfwaySound: halfwaySound ?? this.halfwaySound,
    );
  }

  // Create an Interval object from a Map
  factory IntervalType.fromMap(Map<String, dynamic> map) {
    return IntervalType(
      id: map['id'],
      workoutId: map['workoutId'],
      time: map['time'],
      name: map['name'],
      color: map['color'],
      intervalIndex: map['intervalIndex'],
      sound: map['sound'],
      halfwaySound: map['halfwaySound'],
    );
  }

  @override
  String toString() {
    return 'IntervalType{id: $id, workoutId: $workoutId, time: $time, name: $name, color: $color, intervalIndex: $intervalIndex, sound: $sound, halfwaySound: $halfwaySound}';
  }
}
