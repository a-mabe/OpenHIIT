import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:openhiit/old/pages/create/tabs/general/utils/numerical_input_formatter.dart';

class NumberInput extends StatefulWidget {
  final bool enabled;
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
  final TextEditingController? controller;

  final FocusNode? focusNode;

  const NumberInput({
    super.key,
    this.enabled = true,
    required this.widgetWidth,
    required this.formatter,
    required this.onSaved,
    required this.onChanged,
    required this.validator,
    required this.unit,
    required this.min,
    required this.max,
    required this.numberInputKey,
    this.controller,
    this.focusNode,
    this.title = "",
  });

  @override
  NumberInputState createState() => NumberInputState();
}

class NumberInputState extends State<NumberInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
            width: widget.widgetWidth,
            child: TextFormField(
              enabled: widget.enabled,
              focusNode: widget.focusNode,
              key: widget.numberInputKey,
              keyboardType: TextInputType.number,
              controller: widget.controller,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                NumericalRangeFormatter(min: widget.min, max: widget.max),
              ],
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 25),
              textAlign: TextAlign.end,
              maxLength: 3,
              decoration: InputDecoration(
                hintText: "00",
                errorStyle: TextStyle(fontSize: 0),
                counterText: "",
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              onChanged: widget.onChanged,
              validator: widget.validator,
              onSaved: widget.onSaved,
            )),
        Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 0, 8),
            child: Text(
              widget.unit,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: widget.enabled ? Colors.grey : Colors.grey.shade700,
                fontSize: 18,
              ),
            )),
      ],
    );
  }
}
