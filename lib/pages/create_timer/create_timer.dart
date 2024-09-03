import 'package:flutter/material.dart';
import 'package:openhiit/widgets/form_widgets/create_form.dart';
import '../../models/workout_type.dart';
import '../set_timings.dart/set_timings.dart';
import '../../widgets/form_widgets/submit_button.dart';

class CreateTimer extends StatefulWidget {
  const CreateTimer({super.key});

  @override
  CreateTimerState createState() => CreateTimerState();
}

class CreateTimerState extends State<CreateTimer> {
  @override
  Widget build(BuildContext context) {
    /// Grab the [workout] that was passed to this view
    /// from the previous view.
    Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

    // Create a global key that uniquely identifies the Form widget
    // and allows validation of the form.
    //
    // Note: This is a `GlobalKey<FormState>`,
    // not a GlobalKey<MyCustomFormState>.
    final formKey = GlobalKey<FormState>();

    /// Push to the SetTimings page.
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

    /// Submit and form, save the workout values, and move
    /// to the next view.
    ///
    void submitForm(Workout workout) {
      // Validate returns true if the form is valid, or false otherwise.
      final form = formKey.currentState!;
      if (form.validate()) {
        form.save();
        pushTimings(workout);
      }
    }
    // ---

    return Scaffold(
        appBar: AppBar(
          title: const Text("New Interval Timer"),
        ),
        bottomSheet: SubmitButton(
          text: "Submit",
          color: const Color.fromARGB(255, 58, 165, 255),
          onTap: () {
            submitForm(workout);
          },
        ),
        body: CreateForm(workout: workout, formKey: formKey));
  }
}
