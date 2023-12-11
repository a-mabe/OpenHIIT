import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../workout_data_type/workout_type.dart';
import './set_sounds.dart';

class SetTimings extends StatefulWidget {
  const SetTimings({super.key});

  @override
  State<SetTimings> createState() => _SetTimingsState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetTimingsState extends State<SetTimings> {
  void pushHome() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => MyHomePage()), (route) => false);
  }

  void submitWorkout(Workout workoutArgument, int workMinutes, int workSeconds,
      int restMinutes, int restSeconds) async {
    if (workoutArgument.showMinutes == 1) {
      workoutArgument.exerciseTime = (workMinutes * 60) + workSeconds;
      workoutArgument.restTime = (restMinutes * 60) + restSeconds;
    }

    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Sounds(),
          settings: RouteSettings(
            arguments: workoutArgument,
          ),
        ),
      );
    });
  }

  int calcMinutes(int seconds) {
    return (seconds - (seconds % 60)) ~/ 60;
  }

  int calcSeconds(int seconds) {
    return (seconds % 60);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    int workMinutes = 0;
    int workSeconds = 0;
    int restMinutes = 0;
    int restSeconds = 0;

    if (workoutArgument.showMinutes == 1) {
      return buildMinutesSecondsForm(
          workoutArgument, workMinutes, workSeconds, restMinutes, restSeconds);
    } else {
      return buildSecondsForm(workoutArgument);
    }
  }

  Widget buildSecondsForm(Workout workoutArgument) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Enter Time Intervals'),
        ),
        bottomSheet: InkWell(
          onTap: () {
            // Validate returns true if the form is valid, or false otherwise.
            final form = _formKey.currentState!;
            if (form.validate()) {
              form.save();
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              submitWorkout(workoutArgument, 0, 0, 0, 0);
            }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
                    child: Text(
                      "Work interval time:",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          initialValue: workoutArgument.exerciseTime == 0
                              ? ""
                              : workoutArgument.exerciseTime
                                  .toString()
                                  .characters
                                  .take(3)
                                  .toString(),
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            NumericalRangeFormatter(min: 5, max: 999),
                          ],
                          // textInputAction: TextInputAction.done,
                          style: const TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,
                          maxLength: 3,
                          decoration: const InputDecoration(
                            hintText: "00",
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter time';
                            }
                            return null;
                          },
                          onSaved: (val) => setState(() => workoutArgument
                              .exerciseTime = val!
                                  .contains(".")
                              ? int.parse(val.substring(0, val.indexOf(".")))
                              : int.parse(val)),
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                          child: Text(
                            "s",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey, fontSize: 25),
                          ))
                    ],
                  )),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
                    child: Text(
                      "Rest interval time:",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                            initialValue: workoutArgument.restTime == 0
                                ? ""
                                : workoutArgument.restTime
                                    .toString()
                                    .characters
                                    .take(3)
                                    .toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              NumericalRangeFormatter(min: 5, max: 999),
                            ],
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 40),
                            textAlign: TextAlign.center,
                            maxLength: 3,
                            decoration: const InputDecoration(
                              hintText: "00",
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              counterText: "",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter time';
                              }
                              return null;
                            },
                            onSaved: (val) => setState(() => workoutArgument
                                .restTime = val!
                                    .contains(".")
                                ? int.parse(val.substring(0, val.indexOf(".")))
                                : int.parse(val))),
                      ),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                          child: Text(
                            "s",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey, fontSize: 25),
                          ))
                    ],
                  )),
            ],
          ),
        ));
  }

  Widget buildMinutesSecondsForm(Workout workoutArgument, int workMinutes,
      int workSeconds, int restMinutes, int restSeconds) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Enter Time Intervals'),
        ),
        bottomSheet: InkWell(
          onTap: () {
            // Validate returns true if the form is valid, or false otherwise.
            final form = _formKey.currentState!;
            if (form.validate()) {
              form.save();
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              submitWorkout(workoutArgument, workMinutes, workSeconds,
                  restMinutes, restSeconds);
            }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
                    child: Text(
                      "Work interval time:",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          initialValue: workoutArgument.exerciseTime == 0
                              ? ""
                              : calcMinutes(workoutArgument.exerciseTime)
                                  .toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            NumericalRangeFormatter(min: 1, max: 99),
                          ],
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,
                          maxLength: 2,
                          decoration: const InputDecoration(
                            hintText: "00",
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter time';
                            }
                            return null;
                          },
                          onSaved: (val) =>
                              setState(() => workMinutes = int.parse(val!)),
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                          child: Text(
                            "m",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey, fontSize: 25),
                          )),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          initialValue: workoutArgument.exerciseTime == 0
                              ? ""
                              : calcSeconds(workoutArgument.exerciseTime)
                                  .toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            NumericalRangeFormatter(min: 0, max: 59),
                          ],
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,
                          maxLength: 2,
                          decoration: const InputDecoration(
                            hintText: "00",
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            counterText: "",
                          ),
                          onSaved: (val) {
                            if (val != "") {
                              setState(() => workSeconds = int.parse(val!));
                            } else {
                              setState(() => workSeconds = 0);
                            }
                          },
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                          child: Text(
                            "s",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey, fontSize: 25),
                          ))
                    ],
                  )),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
                    child: Text(
                      "Rest interval time:",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          initialValue: workoutArgument.restTime == 0
                              ? ""
                              : calcMinutes(workoutArgument.restTime)
                                  .toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            NumericalRangeFormatter(min: 1, max: 99),
                          ],
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,
                          maxLength: 2,
                          decoration: const InputDecoration(
                            hintText: "00",
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter time';
                            }
                            return null;
                          },
                          onSaved: (val) =>
                              setState(() => restMinutes = int.parse(val!)),
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                          child: Text(
                            "m",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey, fontSize: 25),
                          )),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                            initialValue: workoutArgument.restTime == 0
                                ? ""
                                : calcSeconds(workoutArgument.restTime)
                                    .toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              NumericalRangeFormatter(min: 0, max: 59),
                            ],
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 40),
                            textAlign: TextAlign.center,
                            maxLength: 2,
                            decoration: const InputDecoration(
                              hintText: "00",
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              counterText: "",
                            ),
                            onSaved: (val) {
                              if (val != "") {
                                setState(() => restSeconds = int.parse(val!));
                              } else {
                                setState(() => restSeconds = 0);
                              }
                            }),
                      ),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                          child: Text(
                            "s",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey, fontSize: 25),
                          ))
                    ],
                  )),
            ],
          ),
        ));
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return const TextEditingValue().copyWith(text: min.toStringAsFixed(2));
    } else {
      return int.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}
