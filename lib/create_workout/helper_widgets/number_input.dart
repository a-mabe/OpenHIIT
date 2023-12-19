/// Copyright (C) 2021 Abigail Mabe - All Rights Reserved
/// You may use, distribute and modify this code under the terms
/// of the license.
///
/// You should have received a copy of the license with this file.
/// If not, please email <mabe.abby.a@gmail.com>
///
///

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'numerical_input_formatter.dart';

class NumberInput extends StatefulWidget {
  /// Vars

  final int numberValue;

  final String unit;

  final double min;

  final double max;

  final Function formatter;

  final void Function(String?) onSaved;

  final String? Function(String?) validator;

  const NumberInput(
      {Key? key,
      required this.numberValue,
      required this.formatter,
      required this.onSaved,
      required this.validator,
      required this.unit,
      required this.min,
      required this.max})
      : super(key: key);

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
            width: 70,
            child: TextFormField(
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
              maxLength: 2,
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
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: Text(
              widget.unit,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.grey, fontSize: 25),
            )),
      ],
    );
  }
}
