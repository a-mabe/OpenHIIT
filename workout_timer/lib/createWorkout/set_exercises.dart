import 'package:flutter/material.dart';
import 'dart:convert';
import '../workoutType/workout_type.dart';
import './set_timings.dart';

class Exercises extends StatelessWidget {
  const Exercises({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Exercises'),
      ),
      body: const Center(
        child: SetExercises(),
      ),
    );
  }
}

class SetExercises extends StatefulWidget {
  const SetExercises({super.key});

  @override
  State<SetExercises> createState() => _SetExercisesState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetExercisesState extends State<SetExercises> {
  // final bool _validate = false;
  List<TextEditingController> controllers = [];
  Workout workout = Workout.empty();

  void submitExercises() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Timings(),
          settings: RouteSettings(
            arguments: workout,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    // final List<GlobalKey<FormState>> formKeys = [];
    List<bool> validators = [];
    List<String> exercises = [];

    final formKey = GlobalKey<FormState>();

    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: workoutArgument.numExercises,
                  itemBuilder: (context, index) {
                    controllers.add(TextEditingController());
                    // formKeys.add(GlobalKey<FormState>());
                    validators.add(false);

                    return Padding(
                      padding:
                          const EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: controllers[index],
                        decoration: InputDecoration(
                          labelText: 'Exercise #${index + 1}',
                          errorText: validators[index]
                              ? 'Value Can\'t Be Empty'
                              : null,
                        ),
                        onSaved: (val) => setState(() => exercises.add(
                            val!)), // workoutArgument.exercises.add(val!)),
                      ),
                    );
                  }),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    final form = formKey.currentState!;
                    if (form.validate()) {
                      form.save();

                      workoutArgument.exercises = jsonEncode(exercises);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(workoutArgument.exercises)),
                      );

                      workout = workoutArgument;

                      submitExercises();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ));
  }
}
