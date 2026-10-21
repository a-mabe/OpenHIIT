class TimerListTileModel<E> {
  TimerListTileModel({
    required this.action,
    required this.showMinutes,
    required this.interval,
    required this.total,
    required this.seconds,
    required this.set,
    required this.totalSets,
  });

  String action;
  int showMinutes;
  int interval;
  int total;
  int seconds;
  int set;
  int totalSets;

  String intervalString() {
    if ([
      "Rest",
      "Warmup",
      "Cooldown",
      "Get Ready",
      "Break",
      "Rest between sets"
    ].contains(action)) {
      return "";
    }
    return "$interval of $total";
  }

  String setString() {
    if (totalSets <= 1) {
      return "";
    }
    final remaining = (totalSets - set);
    final remainingLabel = remaining > 0 ? "$remaining left" : "last set";
    return "Set $set of $totalSets • $remainingLabel";
  }

  /// Label for the rest between sets, announcing the set that follows it.
  String nextSetString() {
    if (action != "Rest between sets" || totalSets <= 1) {
      return "";
    }
    return "Next: Set $set of $totalSets";
  }

  String timeString() {
    if (showMinutes == 1) {
      int secondsRemainder = seconds % 60;
      int minutes = ((seconds - secondsRemainder) / 60).round();

      if (minutes == 0) {
        return "${seconds.toString()}s";
      }

      String secondsString = secondsRemainder.toString();
      if (secondsRemainder < 10) {
        secondsString = "0$secondsRemainder";
      }

      return "$minutes:$secondsString";
    } else {
      return ("${seconds.toString()}s");
    }
  }
}
