import 'package:flutter/material.dart';
import 'dart:convert';
import '../workout_data_type/workout_type.dart';
import './set_timings.dart';

class SetExercises extends StatefulWidget {
  const SetExercises({super.key});

  @override
  State<SetExercises> createState() => _SetExercisesState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetExercisesState extends State<SetExercises> {
  List<TextEditingController> _controllers = [];
  Workout _workout = Workout.empty();

  void pushTimings() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SetTimings(),
          settings: RouteSettings(
            arguments: _workout,
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
      _workout = workoutArgument;
      pushTimings();
    }
  }

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;
    List<dynamic> exercisesArgument = workoutArgument.exercises != ""
        ? jsonDecode(workoutArgument.exercises)
        : [];
    List<bool> validators = [];
    List<String> exercises = [];
    final formKey = GlobalKey<FormState>();

    for (var i = 0; i < workoutArgument.numExercises; i++) {
      if (workoutArgument.exercises == "") {
        _controllers.add(TextEditingController());
      } else {
        _controllers.add(TextEditingController(
            text: i < exercisesArgument.length ? exercisesArgument[i] : ""));
      }
      validators.add(false);
    }

    List<Widget> createChildren() {
      return List<Widget>.generate(workoutArgument.numExercises + 1,
          (int index) {
        if (index == workoutArgument.numExercises) {
          // return the submit button
          return Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
            child: ElevatedButton(
              onPressed: () {
                submitExercises(formKey, workoutArgument, exercises);
              },
              child: const Text('Submit'),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              maxLength: 40,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: _controllers[index],
              decoration: InputDecoration(
                labelText: 'Exercise #${index + 1}',
                errorText: validators[index] ? 'Value Can\'t Be Empty' : null,
              ),
              onSaved: (val) => setState(() => exercises.add(val!)),
            ),
          );
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Exercises'),
      ),
      body: Center(
          child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: createChildren(),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
