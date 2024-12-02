import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openhiit/data/timer_type.dart';
import 'package:openhiit/utils/log/log.dart';
import 'dart:convert';
import '../../data/workout_type.dart';
import '../set_timings/set_timings.dart';
import '../../widgets/form_widgets/submit_button.dart';

class SetExercises extends StatefulWidget {
  final TimerType timer;

  const SetExercises({super.key, required this.timer});

  @override
  State<SetExercises> createState() => _SetExercisesState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetExercisesState extends State<SetExercises> {
  /// The list of validators to be used in the form. Each
  /// validator will correspond to one TextFormField.
  ///
  List<bool> validators = [];

  /// The list of validators to be used in the form. Each
  /// validator will correspond to one TextFormField.
  ///
  List<TextEditingController> controllers = [];

  /// The list of exercises the user had filled out in the form. Each
  /// validator will correspond to one TextFormField.
  ///
  List<String> exercises = [];

  /// The global key for the form.
  ///
  final formKey = GlobalKey<FormState>();

  void generateTextControllers(TimerType timer) {
    int currentNumWorkoutExercises = timer.activities.length;

    List currentWorkoutExercises = timer.activities;

    for (var i = 0; i < timer.activeIntervals; i++) {
      validators.add(false);
      if (i < currentNumWorkoutExercises) {
        // If there might be a previously set exercise, use it!
        controllers
            .add(TextEditingController(text: currentWorkoutExercises[i]));
      } else {
        // Otherwise, blank text controller.
        controllers.add(TextEditingController());
      }
    }
  }

  /// Generate the list of TextFormFields based off of the number of exercises.
  ///
  List<Widget> generateTextFormFields(TimerType timer) {
    return List<Widget>.generate(timer.activeIntervals, (int index) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
        child: TextFormField(
          key: Key('exercise-$index'),
          textCapitalization: TextCapitalization.sentences,
          maxLength: 40,

          /// Validate that the field is filled out.
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
          // onSaved push the value into the list of exercises.
          onSaved: (val) => setState(() => exercises.add(val!)),
        ),
      );
    });
  }

  /// Push to the [SetTimings] view.
  ///
  void pushTimings(Workout workout) {
    setState(() {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const SetTimings(),
      //     settings: RouteSettings(
      //       arguments: workout,
      //     ),
      //   ),
      // );
    });
  }

  /// Submit the form and call [pushTimings].
  ///
  void submitExercises(
      GlobalKey<FormState> formKey, TimerType timer, List<String> exercises) {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      timer.activities = exercises;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SetTimings(timer: timer),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    generateTextControllers(widget.timer);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Set Exercises"),
        ),
        bottomSheet: SubmitButton(
          text: "Submit",
          color: Colors.blue,
          onTap: () {
            submitExercises(formKey, widget.timer, exercises);
          },
        ),
        body: SizedBox(
            height: (MediaQuery.of(context).size.height * 10) / 12,
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: generateTextFormFields(widget.timer),
                      ),
                    )))));
  }
}
