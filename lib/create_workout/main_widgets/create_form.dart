import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import '../form_picker_widgets/clock_picker.dart';
import '../form_picker_widgets/number_input.dart';
import '../../workout_data_type/workout_type.dart';
import '../form_picker_widgets/color_picker.dart';

class CreateForm extends StatefulWidget {
  /// Vars

  final Workout workout;

  final GlobalKey<FormState> formKey;

  const CreateForm({super.key, required this.workout, required this.formKey});

  @override
  CreateFormState createState() => CreateFormState();
}

class CreateFormState extends State<CreateForm> {
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
    List<bool> selectedTimerDisplayOptions =
        widget.workout.showMinutes == 1 ? [false, true] : [true, false];

    /// The onTap logic for [ColorPicker]. Opens a dialog that
    /// allows the user to select a color.
    ///
    void pickColor() {
      Color selectedColor = Color(widget.workout.colorInt);
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
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    widget.workout.colorInt = selectedColor.value;
                  });
                },
                child: const Text('Select'),
              ),
            ],
          );
        },
      );
    }
    // ---

    return SizedBox(
        height: (MediaQuery.of(context).size.height) -
            MediaQuery.of(context).size.height / 12,
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
                child: Form(
                  key: widget.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Workout/timer name form field.
                      ///
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 22,
                        child: const AutoSizeText("Enter a name:",
                            maxFontSize: 50,
                            minFontSize: 16,
                            style: TextStyle(
                                color: Color.fromARGB(255, 107, 107, 107),
                                fontSize: 30)),
                      ),
                      TextFormField(
                        key: const Key('timer-name'),
                        initialValue: widget.workout.title,
                        textCapitalization: TextCapitalization.sentences,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (String? val) {
                          widget.workout.title = val!;
                        },
                        onChanged: (String? val) {
                          widget.workout.title = val!;
                        },
                        style: const TextStyle(fontSize: 18),
                      ),

                      /// Workout/timer color form field.
                      ///
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 22,
                          child: const AutoSizeText("Set color:",
                              maxFontSize: 50,
                              minFontSize: 16,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 107, 107, 107),
                                  fontSize: 30)),
                        ),
                      ),
                      Center(
                          child: ColorPicker(
                        key: const Key('color-picker'),
                        onTap: () {
                          pickColor();
                        },
                        color: Color(widget.workout.colorInt),
                      )),

                      /// Workout/timer number of intervals.
                      ///
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 22,
                          child: const AutoSizeText("Number of intervals:",
                              maxFontSize: 50,
                              minFontSize: 16,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 107, 107, 107),
                                  fontSize: 30)),
                        ),
                      ),
                      NumberInput(
                          widgetWidth: 60,
                          numberInputKey: const Key('interval-input'),
                          numberValue: widget.workout.numExercises == 0
                              ? -1
                              : widget.workout.numExercises,
                          formatter: (value) {
                            return value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter intervals';
                            }
                            return null;
                          },
                          onSaved: (String? val) {
                            widget.workout.numExercises = int.parse(val!);
                          },
                          onChanged: (String? val) {
                            widget.workout.numExercises = int.parse(val!);
                          },
                          unit: "intervals",
                          min: 1,
                          max: 999),

                      /// Workout/timer timer display
                      ///
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 22,
                          child: const AutoSizeText("Timer display:",
                              maxFontSize: 50,
                              minFontSize: 16,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 107, 107, 107),
                                  fontSize: 30)),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 35),
                          child: ClockPicker(
                              displayOption: 1,
                              selectedTimerDisplayOptions:
                                  selectedTimerDisplayOptions,
                              onPressed: (int index) {
                                setState(() {
                                  // The button that is tapped is set to true, and the others to false.
                                  for (int i = 0;
                                      i < selectedTimerDisplayOptions.length;
                                      i++) {
                                    selectedTimerDisplayOptions[i] = i == index;
                                    widget.workout.showMinutes = index;
                                  }
                                });
                              }))
                    ],
                  ),
                ))));
  }
}
