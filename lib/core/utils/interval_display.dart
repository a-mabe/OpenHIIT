String intervalSecondsDisplay(int seconds, bool showMinutes) {
  if (!showMinutes) {
    return seconds.toString();
  }
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  final secondsStr = remainingSeconds.toString().padLeft(2, '0');
  return '$minutes:$secondsStr';
}
