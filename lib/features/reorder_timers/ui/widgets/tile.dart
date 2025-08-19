import 'package:flutter/material.dart';
import 'package:openhiit/core/models/timer_type.dart';

class ListTimersTile extends StatefulWidget {
  final TimerType timer;
  final VoidCallback? onTap;

  const ListTimersTile({
    super.key,
    required this.timer,
    this.onTap,
  });

  @override
  ListTimersTileState createState() => ListTimersTileState();
}

class ListTimersTileState extends State<ListTimersTile> {
  String timeString(int showMinutes, int seconds) {
    if (showMinutes == 1) {
      final minutes = seconds ~/ 60;
      final secondsRemainder = seconds % 60;
      if (minutes == 0) return "${seconds}s";
      final secondsString = secondsRemainder.toString().padLeft(2, '0');
      return "$minutes:$secondsString";
    }
    return "${seconds}s";
  }

  String getTimerDescription() {
    final timer = widget.timer;
    final intervalsLabel =
        timer.activities.isNotEmpty ? 'Exercises' : 'Intervals';
    final exerciseTime =
        timeString(timer.showMinutes, timer.timeSettings.workTime);
    final restTime = timeString(timer.showMinutes, timer.timeSettings.restTime);
    final totalTime = (timer.totalTime / 60).round();
    return '$intervalsLabel - ${timer.activeIntervals}\n'
        'Exercise time - $exerciseTime\n'
        'Rest time - $restTime\n'
        'Total - $totalTime minutes';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(widget.timer.color),
      child: ListTile(
        onTap: widget.onTap,
        key: Key(widget.timer.id),
        title: Text(widget.timer.name),
        subtitle: Text(getTimerDescription()),
        titleTextStyle: const TextStyle(
          fontSize: 20,
        ),
        subtitleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        minVerticalPadding: 15.0,
        trailing: ReorderableDragStartListener(
          index: widget.timer.timerIndex,
          child: const Icon(Icons.drag_handle),
        ),
      ),
    );
  }
}
