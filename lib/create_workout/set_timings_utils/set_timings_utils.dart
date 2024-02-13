String minutesFormatter(int time) {
  int calculation = ((time - (time % 60)) / 60).round();
  if (calculation == 0) {
    return "";
  }
  return calculation.toString();
}

String secondsRemainderFormatter(int time) {
  return (time % 60).toString();
}

String secondsFormatter(int time) {
  return time.toString();
}
