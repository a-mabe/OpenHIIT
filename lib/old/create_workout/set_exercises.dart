import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import '../workout_data_type/workout_type.dart';
import 'set_timings.dart';
import 'main_widgets/submit_button.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class SetExercises extends StatefulWidget {
  const SetExercises({super.key});

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

  void generateTextControllers(Workout workout) {
    /// If the workout already had a list of exercises and the
    /// number of exercises is being updated, check the old
    /// length so that the form fields can be prepopulated with
    /// the old exercises.
    ///
    int currentNumWorkoutExercises =
        workout.exercises != "" ? jsonDecode(workout.exercises).length : 0;

    List currentWorkoutExercises = [];

    if (currentNumWorkoutExercises > 0) {
      currentWorkoutExercises = jsonDecode(workout.exercises);
    }

    for (var i = 0; i < workout.numExercises; i++) {
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
  List<Widget> generateTextFormFields(Workout workout) {
    logger.i("Generating ${workout.numExercises} TextFormFields");

    return List<Widget>.generate(workout.numExercises, (int index) {
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

  /// Submit the form and call [pushTimings].
  ///
  void submitExercises(
      GlobalKey<FormState> formKey, Workout workout, List exercises) {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      workout.exercises = jsonEncode(exercises);
      pushTimings(workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Grab the [workout] that was passed to this view
    /// from the previous view.
    ///
    Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

    /// Generate the text controllers.
    ///
    generateTextControllers(workout);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Set Exercises"),
        ),
        bottomSheet: SubmitButton(
          text: "Submit",
          color: Colors.blue,
          onTap: () {
            submitExercises(formKey, workout, exercises);
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
                        children: generateTextFormFields(workout),
                      ),
                    )))));
  }
}
