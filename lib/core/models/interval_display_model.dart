class IntervalDisplayModel {
  final int index;
  final int activeIndex;
  final String name;
  final int seconds;
  final bool showMinutes;

  IntervalDisplayModel({
    required this.index,
    required this.activeIndex,
    required this.name,
    required this.seconds,
    this.showMinutes = false,
  });
}
