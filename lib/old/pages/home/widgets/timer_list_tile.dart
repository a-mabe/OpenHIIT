import 'package:flutter/material.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';

class TimerListTile extends StatefulWidget {
  final TimerType timer;

  final Function? onTap;

  final int index;

  const TimerListTile({
    super.key,
    required this.timer,
    required this.onTap,
    required this.index,
  });

  @override
  TimerListTileState createState() => TimerListTileState();
}

class TimerListTileState extends State<TimerListTile>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String timeString(int showMinutes, int seconds) {
    if (showMinutes == 1) {
      int secondsRemainder = seconds % 60;
      int minutes = ((seconds - secondsRemainder) / 60).round();

      if (minutes == 0) {
        return "${seconds.toString()} seconds";
      }

      String secondsString = secondsRemainder.toString();
      if (secondsRemainder < 10) {
        secondsString = "0$secondsRemainder";
      }

      return "$minutes:$secondsString";
    } else {
      return "${seconds.toString()} seconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        key: Key('$widget.index'),
        color: Color(widget.timer.color),
        child: ListTile(
          title: Text(widget.timer.name),
          titleTextStyle: const TextStyle(
            fontSize: 20,
          ),
          subtitle: Text(
              '''${widget.timer.activities.isNotEmpty ? 'Exercises - ${widget.timer.activeIntervals}' : 'Intervals - ${widget.timer.activeIntervals}'}
Exercise time - ${timeString(widget.timer.showMinutes, widget.timer.timeSettings.workTime)}
Rest time - ${timeString(widget.timer.showMinutes, widget.timer.timeSettings.restTime)}
Total - ${(widget.timer.totalTime / 60).round()} minutes'''),
          subtitleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          minVerticalPadding: 15.0,
          onTap: () {
            widget.onTap!();
          },
          trailing: ReorderableDragStartListener(
            index: widget.index,
            child: const Icon(Icons.drag_handle),
          ),
        ));
  }
}
