class IntervalType {
  int time;
  String name;
  int color;
  int index;
  String sound;
  String? halfwaySound;

  IntervalType(
      {required this.time,
      required this.name,
      required this.color,
      required this.index,
      required this.sound,
      this.halfwaySound});

  // Convert an Interval object to a Map
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'name': name,
      'color': color,
    };
  }

  // Copy an Interval object with optional new values
  IntervalType copy(
      {int? time,
      String? name,
      int? color,
      int? index,
      String? sound,
      String? halfwaySound}) {
    return IntervalType(
      time: time ?? this.time,
      name: name ?? this.name,
      color: color ?? this.color,
      index: index ?? this.index,
      sound: sound ?? this.sound,
      halfwaySound: halfwaySound ?? this.halfwaySound,
    );
  }
}
