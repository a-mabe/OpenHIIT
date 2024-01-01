import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'numerical_input_formatter.dart';

class NumberInput extends StatefulWidget {
  /// Vars

  final int numberValue;

  final String unit;

  final double min;

  final double max;

  final Key numberInputKey;

  final Function formatter;

  final void Function(String?) onSaved;

  final String? Function(String?) validator;

  const NumberInput(
      {super.key,
      required this.numberValue,
      required this.formatter,
      required this.onSaved,
      required this.validator,
      required this.unit,
      required this.min,
      required this.max,
      required this.numberInputKey});

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: 80,
            child: TextFormField(
              key: widget.numberInputKey,
              initialValue: widget.numberValue == 0
                  ? ""
                  : widget.formatter(widget.numberValue).toString(),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                NumericalRangeFormatter(min: widget.min, max: widget.max),
              ],
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
              maxLength: 3,
              decoration: const InputDecoration(
                hintText: "00",
                errorMaxLines: 2,
                border: InputBorder.none,
                fillColor: Colors.white,
                counterText: "",
                contentPadding: EdgeInsets.zero,
              ),
              validator: widget.validator,
              onSaved: widget.onSaved,
            )),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
            child: Text(
              widget.unit,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.grey, fontSize: 25),
            )),
      ],
    );
  }
}
