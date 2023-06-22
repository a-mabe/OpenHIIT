import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:workout_timer/create_workout/create_workout.dart';
import 'package:workout_timer/create_workout/create_timer.dart';
import '../workout_type/workout_type.dart';
import './set_exercises.dart';

class SelectTimer extends StatelessWidget {
  const SelectTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Workout'),
      ),
      body: const Center(
        child: SelectTimerType(),
      ),
    );
  }
}

class SelectTimerType extends StatefulWidget {
  const SelectTimerType({super.key});

  @override
  // ignore: library_private_types_in_public_api
  SelectTimerTypeState createState() => SelectTimerTypeState();
}

class SelectTimerTypeState extends State<SelectTimerType> {
  int _currentIntValue = 10;
  final _formKey = GlobalKey<FormState>();
  final workout = Workout.empty();

  void pushCreateWorkout() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateWorkout(),
          settings: RouteSettings(
            arguments: workout,
          ),
        ),
      );
    });
  }

  void pushCreateTimer() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateTimer(),
          settings: RouteSettings(
            arguments: workout,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Column(
          children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(
                      30.0,
                    ),
                    child: Card(
                      // color: Colors.yellow,
                      child: InkWell(
                        child: const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Icon(Icons.alarm, size: 25),
                                    ),
                                    Text(
                                      "Interval Timer",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 25,
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Text(
                                      "An interval timer is a tool that helps you track the time spent working and resting during a workout."),
                                )
                              ],
                            )),
                        onTap: () {
                          pushCreateTimer();
                        },
                      ),
                    ))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(
                      30.0,
                    ),
                    child: Card(
                      // color: Colors.yellow,
                      child: InkWell(
                        child: const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child:
                                          Icon(Icons.fitness_center, size: 25),
                                    ),
                                    Text(
                                      "Workout",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 25,
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Text(
                                      "A workout is a planned set of exercise combined with an interval timer."),
                                )
                              ],
                            )),
                        onTap: () {
                          pushCreateWorkout();
                        },
                      ),
                    ))),
          ],
        ));
    // return Form(
    //   key: _formKey,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Padding(
    //         padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
    //         child: Text(
    //           "Name this workout:",
    //           style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
    //         child: TextFormField(
    //           // The validator receives the text that the user has entered.
    //           validator: (value) {
    //             if (value == null || value.isEmpty) {
    //               return 'Please enter some text';
    //             }
    //             return null;
    //           },
    //           onSaved: (val) => setState(() => workout.title = val!),
    //         ),
    //       ),
    //       const Padding(
    //         padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
    //         child: Text(
    //           "How many exercises?",
    //           style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //       Center(
    //         child: NumberPicker(
    //           value: _currentIntValue,
    //           minValue: 1,
    //           maxValue: 50,
    //           step: 1,
    //           haptics: true,
    //           onChanged: (value) => setState(() => _currentIntValue = value),
    //         ),
    //       ),
    //       Center(
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             IconButton(
    //               icon: const Icon(Icons.remove),
    //               onPressed: () => setState(() {
    //                 final newValue = _currentIntValue - 1;
    //                 _currentIntValue = newValue.clamp(1, 50);
    //               }),
    //             ),
    //             Text('Current int value: $_currentIntValue'),
    //             IconButton(
    //               icon: const Icon(Icons.add),
    //               onPressed: () => setState(() {
    //                 final newValue = _currentIntValue + 1;
    //                 _currentIntValue = newValue.clamp(1, 50);
    //               }),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Center(
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(vertical: 16.0),
    //           child: ElevatedButton(
    //             onPressed: () {
    //               submitForm();
    //             },
    //             child: const Text('Submit'),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
