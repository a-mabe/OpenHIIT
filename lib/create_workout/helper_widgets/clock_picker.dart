/// Copyright (C) 2021 Abigail Mabe - All Rights Reserved
/// You may use, distribute and modify this code under the terms
/// of the license.
///
/// You should have received a copy of the license with this file.
/// If not, please email <mabe.abby.a@gmail.com>
///
/// Defines a sample widget class.
///

import 'package:flutter/material.dart';

class ClockPicker extends StatefulWidget {
  /// Vars

  /// The clock display selection, 1 being clock
  /// view and 0 being default seconds view.
  ///
  final int displayOption;

  final List<bool> selectedTimerDisplayOptions;

  final Function(int) onPressed;

  const ClockPicker(
      {Key? key,
      required this.displayOption,
      required this.selectedTimerDisplayOptions,
      required this.onPressed})
      : super(key: key);

  @override
  ClockPickerState createState() => ClockPickerState();
}

class ClockPickerState extends State<ClockPicker> {
  List<Widget> timerDisplayOptions = <Widget>[
    const Text('102s'),
    const Text('1:42'),
  ];

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
    return Column(
      children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
          child: ToggleButtons(
            direction: Axis.horizontal,
            onPressed: widget.onPressed,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.blue,
            selectedColor: Colors.white,
            fillColor: Colors.blue,
            color: Colors.blue,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: widget.selectedTimerDisplayOptions,
            children: timerDisplayOptions,
          ),
        )),
        Center(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0),
          child: widget.selectedTimerDisplayOptions[0] == true
              ? const Text("Max 999 seconds")
              : const Text("Max 99 minutes (99:00)"),
        )),
      ],
    );
  }
}
