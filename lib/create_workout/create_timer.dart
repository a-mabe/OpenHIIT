import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import '../workout_data_type/workout_type.dart';
import './set_timings.dart';

// class CreateTimer extends StatelessWidget {
//   const CreateTimer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text('New Interval Timer'),
//       ),
//       body: const Center(
//         child: ChooseIntervals(),
//       ),
//     );
//   }
// }

class ChooseIntervals extends StatefulWidget {
  const ChooseIntervals({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChooseIntervalsState createState() => _ChooseIntervalsState();
}

class _ChooseIntervalsState extends State<ChooseIntervals> {
  int _currentIntValue = 10;
  final _formKey = GlobalKey<FormState>();
  bool _changed = false;
  Color _timerColor = Colors.blue;

  List<Widget> timerDisplayOptions = <Widget>[
    const Text('102s'),
    const Text('1:42'),
  ];

  List<bool> selectedTimerDisplay = <bool>[true, false];

  void pushTimings(workout) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SetTimings(),
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
      workout.exercises = "";
      workout.colorInt = _timerColor.value;
      workout.showMinutes = selectedTimerDisplay[0] == true ? 0 : 1;

      pushTimings(workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    if (!_changed && workoutArgument.numExercises > 0) {
      _currentIntValue = workoutArgument.numExercises;
      _timerColor = Color(workoutArgument.colorInt);
      selectedTimerDisplay =
          workoutArgument.showMinutes == 1 ? [false, true] : [true, false];
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('New Interval Timer'),
        ),
        bottomSheet: InkWell(
          onTap: () {
            submitForm(workoutArgument);
          },
          child: Ink(
            height: MediaQuery.of(context).size.height / 12,
            width: MediaQuery.of(context).size.width,
            color: Colors.blue,
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    "Submit",
                    minFontSize: 18,
                    maxFontSize: 40,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
                  child: Text(
                    "Name this timer:",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
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
                    onSaved: (val) =>
                        setState(() => workoutArgument.title = val!),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
                  child: Text(
                    "Timer display style:",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
                  child: ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        _changed = true;
                        // The button that is tapped is set to true, and the others to false.
                        for (int i = 0; i < selectedTimerDisplay.length; i++) {
                          selectedTimerDisplay[i] = i == index;
                        }
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: Colors.blue,
                    selectedColor: Colors.white,
                    fillColor: Colors.blue,
                    color: Colors.blue,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 80.0,
                    ),
                    isSelected: selectedTimerDisplay,
                    children: timerDisplayOptions,
                  ),
                )),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0),
                  child: selectedTimerDisplay[0] == true
                      ? const Text("Max 999 seconds")
                      : const Text("Max 99 minutes (99:00)"),
                )),
                const Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
                  child: Text(
                    "How many intervals?",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
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
                          final newValue0 = _currentIntValue - 1;
                          _currentIntValue = newValue0.clamp(1, 100);
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
                    "Set timer color:",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 100.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: pickColor,
                      child: CircleColor(
                        color: _timerColor,
                        circleSize: MediaQuery.of(context).size.width * 0.15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
