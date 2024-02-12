import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openhiit/create_workout/constants/set_timings_constants.dart';

import 'numerical_input_formatter.dart';

class NumberInput extends StatefulWidget {
  /// Vars

  final int numberValue;

  final double widgetWidth;

  final String unit;

  final double min;

  final double max;

  final String title;

  final Key numberInputKey;

  final Function formatter;

  final void Function(String?) onSaved;

  final String? Function(String?) validator;

  final void Function(String?) onChanged;

  const NumberInput({
    super.key,
    required this.numberValue,
    required this.widgetWidth,
    required this.formatter,
    required this.onSaved,
    required this.onChanged,
    required this.validator,
    required this.unit,
    required this.min,
    required this.max,
    required this.numberInputKey,
    this.title = "",
  });

  @override
  NumberInputState createState() => NumberInputState();
}

class NumberInputState extends State<NumberInput> {
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
        // color: Colors.red,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
                width: 55,
                child: TextFormField(
                  key: widget.numberInputKey,
                  initialValue: widget.numberValue == -1
                      ? ""
                      : widget.formatter(widget.numberValue).toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    NumericalRangeFormatter(min: widget.min, max: widget.max),
                  ],
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    hintText: "00",
                    errorStyle: TextStyle(height: 0.1, fontSize: 10),
                    errorMaxLines: 1,
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    counterText: "",
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: widget.onChanged,
                  validator: widget.validator,
                  onSaved: widget.onSaved,
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                child: Text(
                  widget.unit,
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                )),
          ],
        ));
  }
}
