import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import '../workout_data_type/workout_type.dart';
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
  bool _changed = false;
  Color _timerColor = Colors.blue;

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

  void pickColor() {
    Color selectedColor = _timerColor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: MaterialColorPicker(
            onMainColorChange: (value) {
              selectedColor = value as Color;
            },
            allowShades: false,
            selectedColor: selectedColor,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _timerColor = selectedColor;
                  _changed = true;
                });
                Navigator.pop(context);
              },
              child: Text('Select'),
            ),
          ],
        );
      },
    );
  }

  void submitForm(Workout workout) {
    // Validate returns true if the form is valid, or false otherwise.
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      workout.numExercises = _currentIntValue;
      workout.colorInt = _timerColor.value;

      pushExercises(workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    if (!_changed && workoutArgument.numExercises > 0) {
      _currentIntValue = workoutArgument.numExercises;
      _timerColor = Color(workoutArgument.colorInt);
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
              child: Text(
                "Name this workout:",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: NumberPicker(
                value: _currentIntValue,
                minValue: 1,
                maxValue: 100,
                step: 1,
                haptics: true,
                onChanged: (value) => setState(() {
                  _currentIntValue = value;
                  _changed = true;
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
                      _currentIntValue = newValue.clamp(1, 100);
                    }),
                  ),
                  Text('Current int value: $_currentIntValue'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() {
                      final newValue = _currentIntValue + 1;
                      _currentIntValue = newValue.clamp(1, 100);
                    }),
                  ),
                ],
              ),
            ),
            // Color picker
            const Padding(
              padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
              child: Text(
                "Set workout color:",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: pickColor,
                child: CircleColor(
                  color: _timerColor,
                  circleSize: MediaQuery.of(context).size.width * 0.15,
                ),
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
      ),
    );
  }
}
