import 'package:flutter/material.dart';
import 'dart:convert';
import '../workout_type/workout_type.dart';
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

  void pushTimings() {
    setState(() {
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

  void submitExercises(formKey, workoutArgument, exercises) {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      workoutArgument.exercises = jsonEncode(exercises);
      workout = workoutArgument;
      pushTimings();
    }
  }

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    // final List<GlobalKey<FormState>> formKeys = [];
    List<bool> validators = [];
    List<String> exercises = [];

    final formKey = GlobalKey<FormState>();

    for (var i = 0; i < workoutArgument.numExercises; i++) {
      controllers.add(TextEditingController());
      validators.add(false);
    }

    List<Widget> createChildren() {
      return List<Widget>.generate(workoutArgument.numExercises + 1,
          (int index) {
        if (index == workoutArgument.numExercises) {
          // return the submit button
          return ElevatedButton(
            onPressed: () {
              submitExercises(formKey, workoutArgument, exercises);
            },
            child: const Text('Submit'),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
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
                errorText: validators[index] ? 'Value Can\'t Be Empty' : null,
              ),
              onSaved: (val) => setState(() =>
                  exercises.add(val!)), // workoutArgument.exercises.add(val!)),
            ),
          );
        }
      });
    }

    return Form(
      key: formKey,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(children: createChildren()),
          ),
        ],
      ),
    );
  }
}
