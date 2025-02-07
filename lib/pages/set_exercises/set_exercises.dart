import 'package:flutter/material.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import '../set_timings/set_timings.dart';
import '../../widgets/form_widgets/submit_button.dart';

class SetExercises extends StatefulWidget {
  final TimerType timer;

  const SetExercises({super.key, required this.timer});

  @override
  State<SetExercises> createState() => _SetExercisesState();
}

class _SetExercisesState extends State<SetExercises> {
  List<bool> validators = [];
  List<TextEditingController> controllers = [];
  List<String> exercises = [];
  final formKey = GlobalKey<FormState>();

  void generateTextControllers(TimerType timer) {
    int currentNumWorkoutExercises = timer.activities.length;

    List currentWorkoutExercises = timer.activities;

    for (var i = 0; i < timer.activeIntervals; i++) {
      validators.add(false);
      if (i < currentNumWorkoutExercises) {
        controllers
            .add(TextEditingController(text: currentWorkoutExercises[i]));
      } else {
        controllers.add(TextEditingController());
      }
    }
  }

  List<Widget> generateTextFormFields(TimerType timer) {
    return List<Widget>.generate(timer.activeIntervals, (int index) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
        child: TextFormField(
          key: Key('exercise-$index'),
          textCapitalization: TextCapitalization.sentences,
          maxLength: 40,
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
          onSaved: (val) => setState(() => exercises.add(val!)),
        ),
      );
    });
  }

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
