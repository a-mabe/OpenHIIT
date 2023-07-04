import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../workout_type/workout_type.dart';
import './set_exercises.dart';

class CreateWorkout extends StatelessWidget {
  const CreateWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('New Workout'),
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
  final _formKey = GlobalKey<FormState>();
  bool changed = false;
  // final workout = Workout.empty();

  void pushExercises(workout) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Exercises(),
          settings: RouteSettings(
            arguments: workout,
          ),
        ),
      );
    });
  }

  void submitForm(workout) {
    // Validate returns true if the form is valid, or false otherwise.
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      workout.numExercises = _currentIntValue;

      pushExercises(workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    if (!changed && workoutArgument.numExercises > 0) {
      _currentIntValue = workoutArgument.numExercises;
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
            child: Text(
              "Name this workout:",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              maxLength: 40,
              initialValue: workoutArgument.title,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (val) => setState(() => workoutArgument.title = val!),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
            child: Text(
              "How many exercises/sets?",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: NumberPicker(
              value: _currentIntValue,
              minValue: 1,
              maxValue: 50,
              step: 1,
              haptics: true,
              onChanged: (value) => setState(() {
                _currentIntValue = value;
                changed = true;
              }),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() {
                    final newValue = _currentIntValue - 1;
                    _currentIntValue = newValue.clamp(1, 50);
                  }),
                ),
                Text('Current int value: $_currentIntValue'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() {
                    final newValue = _currentIntValue + 1;
                    _currentIntValue = newValue.clamp(1, 50);
                  }),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  submitForm(workoutArgument);
                },
                child: const Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
