import 'package:flutter/material.dart';
import 'package:openhiit/pages/create/tabs/general/utils/set_timings_utils.dart';

import 'package:openhiit/pages/create/tabs/general/sections/rows/widgets/number_input.dart';

class TimeInputTrailing extends StatefulWidget {
  final int showMinutes;
  // final int timeInSeconds;
  final bool enabled;

  final double widgetWidth;

  final String minutesKey;
  final String secondsKey;

  final String unit;

  final String title;

  final TextEditingController minutesController;
  final TextEditingController secondsController;

  final Function(String?)? minutesOnSaved;
  final Function(String?)? secondsOnSaved;

  final String? Function(String?)? minutesValidator;
  final String? Function(String?)? secondsValidator;

  final void Function(String?)? secondsOnChanged;

  final FocusNode? minuteFocusNode;
  final FocusNode? secondFocusNode;

  const TimeInputTrailing({
    this.showMinutes = 0,
    // this.timeInSeconds = 0,
    this.enabled = true,
    this.widgetWidth = 0,
    this.minutesKey = "",
    this.secondsKey = "",
    this.unit = "",
    this.title = "",
    required this.minutesController,
    required this.secondsController,
    this.minutesOnSaved,
    this.secondsOnSaved,
    this.minuteFocusNode,
    this.secondFocusNode,
    this.minutesValidator,
    this.secondsValidator,
    required this.secondsOnChanged,
    super.key,
  });

  @override
  TimeInputTrailingState createState() => TimeInputTrailingState();
}

class TimeInputTrailingState extends State<TimeInputTrailing> {
  int showMinutes = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("TimeInputTrailing didUpdateWidget");

    if (widget.showMinutes == 1) {
      int totalSeconds = int.tryParse(widget.secondsController.text) ?? 0;
      int minutes = totalSeconds ~/ 60;
      int seconds = totalSeconds % 60;

      // Only update if values actually change to avoid unnecessary rebuilds
      if ((int.tryParse(widget.minutesController.text) ?? 0) != minutes ||
          (int.tryParse(widget.secondsController.text) ?? 0) != seconds) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if ((int.tryParse(widget.minutesController.text) ?? 0) != minutes) {
            widget.minutesController.text = minutes.toString();
          }
          if ((int.tryParse(widget.secondsController.text) ?? 0) != seconds) {
            widget.secondsController.text = seconds.toString();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    showMinutes = widget.showMinutes;

    return SizedBox(
      width: widget.widgetWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
              visible: (widget.showMinutes == 1 && widget.unit != "time(s)"),
              child: NumberInput(
                  enabled: widget.enabled,
                  focusNode: widget.minuteFocusNode,
                  controller: widget.minutesController,
                  widgetWidth: 80,
                  formatter: minutesFormatter,
                  onSaved: widget.minutesOnSaved!,
                  onChanged: (text) {},
                  validator: widget.minutesValidator!,
                  unit: "m",
                  min: 0,
                  max: 99,
                  numberInputKey: Key(widget.minutesKey))),
          NumberInput(
              enabled: widget.enabled,
              focusNode: widget.secondFocusNode,
              controller: widget.secondsController,
              title: widget.title,
              widgetWidth: 60,
              formatter: widget.showMinutes == 1
                  ? secondsRemainderFormatter
                  : secondsFormatter,
              onSaved: widget.secondsOnSaved!,
              onChanged: widget.secondsOnChanged!,
              validator: widget.secondsValidator!,
              unit: widget.unit,
              min: 0,
              max: widget.showMinutes == 1
                  ? 59
                  : (widget.unit == "time(s)" ? 99 : 999),
              numberInputKey: Key(widget.secondsKey))
        ],
      ),
    );
  }
}
