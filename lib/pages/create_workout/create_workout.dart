// import 'package:flutter/material.dart';
// import 'package:openhiit/utils/log/log.dart';
// import 'package:openhiit/widgets/form_widgets/create_form.dart';
// import '../../data/workout_type.dart';
// import '../../widgets/form_widgets/submit_button.dart';
// import '../set_exercises/set_exercises.dart';

// class CreateWorkout extends StatefulWidget {
//   const CreateWorkout({super.key});

//   @override
//   CreateWorkoutState createState() => CreateWorkoutState();
// }

// class CreateWorkoutState extends State<CreateWorkout> {
//   @override
//   Widget build(BuildContext context) {
//     /// Grab the [workout] that was passed to this view
//     /// from the previous view.
//     ///
//     Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

//     /// Create a global key that uniquely identifies the Form widget
//     /// and allows validation of the form.
//     ///
//     /// Note: This is a `GlobalKey<FormState>`,
//     /// not a GlobalKey<MyCustomFormState>.
//     ///
//     final formKey = GlobalKey<FormState>();

//     /// Push to the SetExercises page.
//     ///
//     void pushExercises(workout) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const SetExercises(),
//           settings: RouteSettings(
//             arguments: workout,
//           ),
//         ),
//       );
//     }

//     /// Submit and form, save the workout values, and move
//     /// to the next view.
//     ///
//     void submitForm(Workout workout) {
//       // Validate returns true if the form is valid, or false otherwise.
//       final form = formKey.currentState!;
//       if (form.validate()) {
//         form.save();

//         logger.i(
//             "Title: ${workout.title}, Color: ${workout.colorInt}, Intervals: ${workout.numExercises}");

//         pushExercises(workout);
//       }
//     }
//     // ---

//     return Container();

//     // return Scaffold(
//     //     appBar: AppBar(
//     //       title: const Text("New Workout"),
//     //     ),
//     //     bottomSheet: SubmitButton(
//     //       text: "Submit",
//     //       color: Colors.blue,
//     //       onTap: () {
//     //         submitForm(workout);
//     //       },
//     //     ),
//     //     body: CreateForm(timer: timer, formKey: formKey));
//   }
// }
