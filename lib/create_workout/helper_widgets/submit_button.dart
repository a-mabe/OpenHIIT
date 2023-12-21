/// Copyright (C) 2021 Abigail Mabe - All Rights Reserved
/// You may use, distribute and modify this code under the terms
/// of the license.
///
/// You should have received a copy of the license with this file.
/// If not, please email <mabe.abby.a@gmail.com>
///
/// Defines a sample widget class.
///

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  /// Vars

  /// Text to display on the button.
  ///
  /// e.g., Submit
  ///
  final String text;

  final Color color;

  final Function onTap;

  const SubmitButton(
      {Key? key, required this.text, required this.color, required this.onTap})
      : super(key: key);

  @override
  SubmitButtonState createState() => SubmitButtonState();
}

class SubmitButtonState extends State<SubmitButton> {
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
    return Container(
        decoration: BoxDecoration(
            color: widget.color,
            // border: Border.fromBorderSide(BorderSide.lerp(a, b, t))
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 12,
        child: InkWell(
          onTap: () {
            widget.onTap();
          },
          child: Ink(
            height: MediaQuery.of(context).size.height / 12,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: AutoSizeText(
                      widget.text,
                      minFontSize: 18,
                      // maxFontSize: 200,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 40),
                    ))),
          ),
        ));
  }
}
