import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import './setExercises.dart';

class CreateWorkout extends StatelessWidget {
  const CreateWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: const Center(
        child: ChooseNumber(),
      ),
    );
  }
}

class ChooseNumber extends StatefulWidget {
  const ChooseNumber({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChooseNumberState createState() => _ChooseNumberState();
}

class _ChooseNumberState extends State<ChooseNumber> {
  int _currentIntValue = 10;

  void submitNumExercises() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Exercises()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 16),
        Text('Select number of exercises:',
            style: Theme.of(context).textTheme.titleLarge),
        NumberPicker(
          value: _currentIntValue,
          minValue: 0,
          maxValue: 50,
          step: 1,
          haptics: true,
          onChanged: (value) => setState(() => _currentIntValue = value),
        ),
        TextButton(
          style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.blue.withOpacity(0.38),
              backgroundColor: Colors.blue),
          onPressed: () {
            submitNumExercises();
          },
          child: Text('Submit'),
        )
      ],
    );
  }
}
