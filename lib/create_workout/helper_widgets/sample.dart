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

class SampleClass extends StatefulWidget {
  /// Vars

  const SampleClass({
    Key? key,
  }) : super(key: key);

  @override
  SampleClassState createState() => SampleClassState();
}

class SampleClassState extends State<SampleClass> {
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
    return Text("This is a sample class");
  }
}
