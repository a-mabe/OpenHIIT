// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// import '../workout_data_type/workout_type.dart';

// class ViewWorkoutAppBar extends StatelessWidget {
//   /// Called on button tap.
//   ///
//   final VoidCallback? onTap;

//   final Workout workout;

//   const ViewWorkoutAppBar({super.key, this.onTap, required this.workout});

//   @override
//   Widget build(BuildContext context) {
//     /// Device screen height, used to calculate text and
//     /// icon sizes.
//     ///
//     // double sizeHeight = MediaQuery.of(context).size.height;

//     /// Device screen width, used to calculate text and
//     /// icon sizes.
//     ///
//     // double sizeWidth = MediaQuery.of(context).size.width;

//     return AppBar(
//       title: Text(workout.title),
//       backgroundColor: Color(workout.colorInt),
//       actions: <Widget>[
//         IconButton(
//           icon: Icon(Icons.delete, color: iconColor()),
//           tooltip: 'Delete timer',
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: Text('Delete ${workout.title}'),
//                   content: SingleChildScrollView(
//                     child: ListBody(
//                       children: <Widget>[
//                         Text(
//                             'Are you sure you would like to delete ${workout.title}?'),
//                       ],
//                     ),
//                   ),
//                   actions: <Widget>[
//                     TextButton(
//                       child: const Text('Cancel'),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     TextButton(
//                       child: const Text('Delete'),
//                       onPressed: () {
//                         deleteList(workout)
//                             .then((value) => Navigator.pop(context));
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.edit, color: iconColor()),
//           onPressed: () {
//             if (exercises.isEmpty) {
//               pushCreateTimer(workout, context);
//             } else {
//               pushCreateWorkout(workout, context);
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
