import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../main.dart';
import '../workout_data_type/workout_type.dart';
import './set_sounds.dart';

class Timings extends StatelessWidget {
  const Timings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Time Intervals'),
      ),
      body: const Center(
        child: SetTimings(),
      ),
    );
  }
}

class SetTimings extends StatefulWidget {
  const SetTimings({super.key});

  @override
  State<SetTimings> createState() => _SetTimingsState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetTimingsState extends State<SetTimings> {
  int _exerciseTime = 20;
  int _restTime = 10;
  int _halfTime = 0;

  bool _exerciseChanged = false;
  bool _restChanged = false;
  bool _halfChanged = false;

  void pushHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false);
  }

  void submitWorkout(workoutArgument) async {
    workoutArgument.exerciseTime = _exerciseTime;
    workoutArgument.restTime = _restTime;
    workoutArgument.halfTime = _halfTime;

    // if (_exerciseTime > 6) {
    //   workoutArgument.halfwayMark = halfwayMark == false ? 0 : 1;
    // } else {
    //   workoutArgument.halfwayMark = 0;
    // }

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

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    if (workoutArgument.exerciseTime > 0) {
      if (!_exerciseChanged) {
        _exerciseTime = workoutArgument.exerciseTime;
      }
      if (!_restChanged) {
        _restTime = workoutArgument.restTime;
      }
      if (!_halfChanged) {
        _halfTime = workoutArgument.halfTime;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.fitness_center),
                Column(children: [
                  NumberPicker(
                    value: _exerciseTime,
                    minValue: 1,
                    maxValue: 120,
                    step: 1,
                    axis: Axis.horizontal,
                    haptics: true,
                    onChanged: (value) => setState(() {
                      _exerciseTime = value;
                      _exerciseChanged = true;
                    }),
                  ),
                  Row(
                    children: [
                      IconButton(
                        key: const Key('work-decrement'),
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(() {
                          final newValue = _exerciseTime - 1;
                          _exerciseTime = newValue.clamp(1, 120);
                          _exerciseChanged = true;
                        }),
                      ),
                      Text('Working time: $_exerciseTime seconds'),
                      IconButton(
                        key: const Key('work-increment'),
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() {
                          final newValue = _exerciseTime + 1;
                          _exerciseTime = newValue.clamp(1, 120);
                          _exerciseChanged = true;
                        }),
                      ),
                    ],
                  ),
                ])
              ])),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.snooze),
                Column(children: [
                  NumberPicker(
                    value: _restTime,
                    minValue: 1,
                    maxValue: 120,
                    step: 1,
                    axis: Axis.horizontal,
                    haptics: true,
                    onChanged: (value) => setState(() {
                      _restTime = value;
                      _restChanged = true;
                    }),
                  ),
                  Row(children: [
                    IconButton(
                      key: const Key('rest-decrement'),
                      icon: const Icon(Icons.remove),
                      onPressed: () => setState(() {
                        final newValue = _restTime - 1;
                        _restTime = newValue.clamp(1, 120);
                        _restChanged = true;
                      }),
                    ),
                    Text('Rest time: $_restTime seconds'),
                    IconButton(
                      key: const Key('rest-increment'),
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() {
                        final newValue = _restTime + 1;
                        _restTime = newValue.clamp(1, 120);
                        _restChanged = true;
                      }),
                    ),
                  ]),
                ]),
              ],
            ),
          ),
        ),
        // Visibility(
        //   visible: _exerciseTime > 6 ? true : false,
        //   child: Center(
        //       child: CheckboxListTile(
        //     title: const Text("Play sound at half time:"),
        //     value: halfwayMark,
        //     onChanged: (newValue) {
        //       setState(() {
        //         halfwayMark = newValue!;
        //       });
        //     },
        //     // controlAffinity:
        //     //     ListTileControlAffinity.leading, //  <-- leading Checkbox
        //   )),
        // ),

        // Center(
        //   child: Padding(
        //     padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Icon(Icons.timelapse),
        //         IconButton(
        //           icon: const Icon(Icons.remove),
        //           onPressed: () => setState(() {
        //             final newValue = halfTime - 1;
        //             halfTime = newValue.clamp(1, 60);
        //             halfChanged = true;
        //           }),
        //         ),
        //         Text('Half time: $halfTime seconds'),
        //         IconButton(
        //           icon: const Icon(Icons.add),
        //           onPressed: () => setState(() {
        //             final newValue = halfTime + 1;
        //             halfTime = newValue.clamp(1, 50);
        //             halfChanged = true;
        //           }),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                submitWorkout(workoutArgument);
              },
              child: const Text('Submit'),
            ),
          ),
        ),
      ],
    );
  }
}
