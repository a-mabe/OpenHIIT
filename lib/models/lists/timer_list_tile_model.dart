class TimerListTileModel<E> {
  TimerListTileModel({
    required this.action,
    required this.showMinutes,
    required this.interval,
    required this.total,
    required this.seconds,
  });

  String action;
  int showMinutes;
  int interval;
  int total;
  int seconds;

  String intervalString() {
    if (["Rest", "Warmup", "Cooldown", "Get Ready", "Break"].contains(action)) {
      return "";
    }
    return "$interval of $total";
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
