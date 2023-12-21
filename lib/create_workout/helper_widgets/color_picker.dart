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
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class ColorPicker extends StatefulWidget {
  /// Vars

  final Function onTap;

  final Color color;

  const ColorPicker({Key? key, required this.onTap, required this.color})
      : super(key: key);

  @override
  ColorPickerState createState() => ColorPickerState();
}

class ColorPickerState extends State<ColorPicker> {
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
        GestureDetector(
          onTap: () {
            widget.onTap();
          },
          child: CircleColor(
            color: widget.color,
            circleSize: MediaQuery.of(context).size.width * 0.15,
          ),
        ),
      ],
    );
  }
}
