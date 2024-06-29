import 'package:flutter/material.dart';
import 'package:openhiit/create_workout/set_timings_utils/set_timings_utils.dart';

import 'number_input.dart';

class TimeInputTrailing extends StatefulWidget {
  /// Vars

  final int showMinutes;
  final int timeInSeconds;

  final double widgetWidth;

  final String minutesKey;
  final String secondsKey;

  final TextEditingController? minutesController;
  final TextEditingController? secondsController;

  final String unit;

  final String title;

  final Function(String?)? minutesOnSaved;
  final Function(String?)? secondsOnSaved;

  final String? Function(String?)? minutesValidator;
  final String? Function(String?)? secondsValidator;

  final void Function(String?)? secondsOnChanged;

  final FocusNode? minuteFocusNode;
  final FocusNode? secondFocusNode;

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
    this.minuteFocusNode,
    this.secondFocusNode,
    required this.minutesController,
    required this.secondsController,
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
              visible: (widget.showMinutes == 1 && widget.unit != "time(s)"),
              child: NumberInput(
                  focusNode: widget.minuteFocusNode,
                  widgetWidth: 50,
                  numberValue: widget.timeInSeconds,
                  controller:
                      widget.minutesController ?? TextEditingController(),
                  formatter: minutesFormatter,
                  onSaved: widget.minutesOnSaved!,
                  onChanged: (text) {},
                  validator: widget.minutesValidator!,
                  unit: "m",
                  min: 0,
                  max: 99,
                  numberInputKey: Key(widget.minutesKey))),
          NumberInput(
              focusNode: widget.secondFocusNode,
              title: widget.title,
              widgetWidth: 50,
              numberValue: widget.timeInSeconds,
              controller: widget.secondsController ?? TextEditingController(),
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
