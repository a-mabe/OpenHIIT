import 'package:flutter/material.dart';

class SampleClass extends StatefulWidget {
  /// Vars

  const SampleClass({
    super.key,
  });

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
    return const Text("This is a sample class");
  }
}
