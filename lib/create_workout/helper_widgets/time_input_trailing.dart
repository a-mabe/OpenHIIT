import 'package:flutter/material.dart';
import 'package:openhiit/create_workout/utils/set_timings_utils.dart';

import 'number_input.dart';

class TimeInputTrailing extends StatefulWidget {
  /// Vars

  final int showMinutes;
  final int timeInSeconds;

  final double widgetWidth;

  final String minutesKey;
  final String secondsKey;

  final String unit;

  final String title;

  // final Function? minutesFormatter;
  // final Function? secondsFormatter;

  final Function(String?)? minutesOnSaved;
  final Function(String?)? secondsOnSaved;

  final String? Function(String?)? minutesValidator;
  final String? Function(String?)? secondsValidator;

  final void Function(String?)? secondsOnChanged;

  const TimeInputTrailing({
    this.showMinutes = 0,
    this.timeInSeconds = 0,
    this.widgetWidth = 0,
    this.minutesKey = "",
    this.secondsKey = "",
    this.unit = "",
    this.title = "",
    this.minutesOnSaved,
    this.secondsOnSaved,
    this.minutesValidator,
    this.secondsValidator,
    required this.secondsOnChanged,
    super.key,
  });

  @override
  TimeInputTrailingState createState() => TimeInputTrailingState();
}

class TimeInputTrailingState extends State<TimeInputTrailing> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.widgetWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
              visible: widget.showMinutes == 1,
              child: NumberInput(
                  widgetWidth: 80,
                  numberValue: widget.timeInSeconds,
                  formatter: minutesFormatter,
                  onSaved: widget.minutesOnSaved!,
                  onChanged: (text) {},
                  validator: widget.minutesValidator!,
                  unit: "m",
                  min: 0,
                  max: 99,
                  numberInputKey: Key(widget.minutesKey))),
          NumberInput(
              title: widget.title,
              widgetWidth: widget.unit == "time(s)" ? 120 : 70,
              numberValue: widget.timeInSeconds,
              formatter: widget.showMinutes == 1
                  ? secondsRemainderFormatter
                  : secondsFormatter,
              onSaved: widget.secondsOnSaved!,
              onChanged: widget.secondsOnChanged!,
              validator: widget.secondsValidator!,
              unit: widget.unit != "" ? widget.unit : "s",
              min: 0,
              max: widget.showMinutes == 1
                  ? (widget.unit != "" ? 999 : 59)
                  : 999,
              numberInputKey: Key(widget.secondsKey))
        ],
      ),
    );
  }
}
