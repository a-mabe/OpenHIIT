import 'package:flutter/material.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/pages/set_exercises/set_exercises.dart';
import 'package:openhiit/widgets/form_widgets/create_form.dart';
import '../set_timings/set_timings.dart';
import '../../widgets/form_widgets/submit_button.dart';

class CreateTimer extends StatefulWidget {
  final TimerType timer;
  final bool workout;

  const CreateTimer({super.key, required this.timer, required this.workout});

  @override
  CreateTimerState createState() => CreateTimerState();
}

class CreateTimerState extends State<CreateTimer> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    void submitForm(TimerType timer) {
      final form = formKey.currentState!;
      if (form.validate()) {
        form.save();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.workout
                ? SetExercises(timer: timer)
                : SetTimings(timer: timer),
          ),
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("New Interval Timer"),
        ),
        bottomSheet: SubmitButton(
          text: "Submit",
          color: const Color.fromARGB(255, 58, 165, 255),
          onTap: () {
            submitForm(widget.timer);
          },
        ),
        body: CreateForm(timer: widget.timer, formKey: formKey));
  }
}
