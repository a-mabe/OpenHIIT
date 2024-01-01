import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../workout_data_type/workout_type.dart';
import './set_sounds.dart';
import 'helper_widgets/number_input.dart';
import 'helper_widgets/submit_button.dart';

class SetTimings extends StatefulWidget {
  const SetTimings({super.key});

  @override
  State<SetTimings> createState() => _SetTimingsState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetTimingsState extends State<SetTimings> {
  /// The global key for the form.
  ///
  final formKey = GlobalKey<FormState>();

  int workMinutes = 0;
  int workSeconds = 0;
  int restMinutes = 0;
  int restSeconds = 0;

  int calcMinutes(int seconds) {
    return (seconds - (seconds % 60)) ~/ 60;
  }

  int calcSeconds(int seconds) {
    return (seconds % 60);
  }

  void submitTimings(Workout workout) async {
    // Validate returns true if the form is valid, or false otherwise.
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();

      workout.exerciseTime = (workMinutes * 60) + workSeconds;
      workout.restTime = (restMinutes * 60) + restSeconds;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SetSounds(),
          settings: RouteSettings(
            arguments: workout,
          ),
        ),
      );
    }
  }

  Widget returnMinutesSecondsForm(Workout workout) {
    return SizedBox(
        height: (MediaQuery.of(context).size.height * 10) / 12,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 22,
                  child: const AutoSizeText("Enter the work time:",
                      maxFontSize: 50,
                      minFontSize: 16,
                      style: TextStyle(
                          color: Color.fromARGB(255, 107, 107, 107),
                          fontSize: 30)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberInput(
                        numberInputKey: const Key('work-minutes'),
                        numberValue: workout.exerciseTime,
                        formatter: (value) {
                          int calculation = ((workout.exerciseTime -
                                      (workout.exerciseTime % 60)) /
                                  60)
                              .round();
                          if (calculation == 0) {
                            return "";
                          }
                          return calculation;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter time';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            workMinutes = value!.contains(".")
                                ? int.parse(
                                    value.substring(0, value.indexOf(".")))
                                : int.parse(value);
                          });
                        },
                        unit: "m",
                        min: 1,
                        max: 99),
                    NumberInput(
                        numberInputKey: const Key('work-seconds'),
                        numberValue: workout.exerciseTime,
                        formatter: (value) {
                          return workout.exerciseTime % 60;
                        },
                        validator: (value) {
                          return null;
                        },
                        onSaved: (value) {
                          if (value != "") {
                            setState(() => workSeconds = value!.contains(".")
                                ? int.parse(
                                    value.substring(0, value.indexOf(".")))
                                : int.parse(value));
                          } else {
                            setState(() => workSeconds = 0);
                          }
                        },
                        unit: "s",
                        min: 0,
                        max: 59),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height / 22,
                    child: const AutoSizeText("Enter the rest time:",
                        maxFontSize: 50,
                        minFontSize: 16,
                        style: TextStyle(
                            color: Color.fromARGB(255, 107, 107, 107),
                            fontSize: 30))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberInput(
                        numberInputKey: const Key('rest-minutes'),
                        numberValue: workout.restTime,
                        formatter: (value) {
                          int calculation =
                              ((workout.restTime - (workout.restTime % 60)) /
                                      60)
                                  .round();
                          if (calculation == 0) {
                            return "";
                          }
                          return calculation;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter time';
                          }
                          return null;
                        },
                        onSaved: (value) => setState(() => restMinutes = value!
                                .contains(".")
                            ? int.parse(value.substring(0, value.indexOf(".")))
                            : int.parse(value)),
                        unit: "m",
                        min: 1,
                        max: 99),
                    NumberInput(
                        numberInputKey: const Key('rest-seconds'),
                        numberValue: workout.restTime,
                        formatter: (value) {
                          return workout.restTime % 60;
                        },
                        validator: (value) {
                          return null;
                        },
                        onSaved: (value) {
                          if (value != "") {
                            setState(() => restSeconds = value!.contains(".")
                                ? int.parse(
                                    value.substring(0, value.indexOf(".")))
                                : int.parse(value));
                          } else {
                            setState(() => restSeconds = 0);
                          }
                        },
                        unit: "s",
                        min: 0,
                        max: 59),
                  ],
                ),
              ],
            ),
          ),
        )));
  }

  Widget returnSecondsForm(Workout workout) {
    return SizedBox(
        height: (MediaQuery.of(context).size.height * 10) / 12,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text("Enter the work time:",
                        style: TextStyle(
                            color: Color.fromARGB(255, 107, 107, 107),
                            fontSize: 18))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberInput(
                        numberInputKey: const Key('work-seconds'),
                        numberValue: workout.exerciseTime,
                        formatter: (value) {
                          return workout.exerciseTime;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter time';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != "") {
                            setState(() => workSeconds = value!.contains(".")
                                ? int.parse(
                                    value.substring(0, value.indexOf(".")))
                                : int.parse(value));
                          } else {
                            setState(() => workSeconds = 0);
                          }
                        },
                        unit: "s",
                        min: 1,
                        max: 999),
                  ],
                ),
                const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text("Enter the rest time:",
                        style: TextStyle(
                            color: Color.fromARGB(255, 107, 107, 107),
                            fontSize: 18))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberInput(
                        numberInputKey: const Key('rest-seconds'),
                        numberValue: workout.restTime,
                        formatter: (value) {
                          return workout.restTime;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter time';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != "") {
                            setState(() => restSeconds = value!.contains(".")
                                ? int.parse(
                                    value.substring(0, value.indexOf(".")))
                                : int.parse(value));
                          } else {
                            setState(() => restSeconds = 0);
                          }
                        },
                        unit: "s",
                        min: 1,
                        max: 999),
                  ],
                ),
              ],
            ),
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

    return Scaffold(
        appBar: AppBar(
          title: const Text("New Interval Timer"),
        ),
        bottomSheet: SubmitButton(
          text: "Submit",
          color: Colors.blue,
          onTap: () {
            submitTimings(workout);
          },
        ),
        body: workout.showMinutes == 1
            ? returnMinutesSecondsForm(workout)
            : returnSecondsForm(workout));
  }
}
