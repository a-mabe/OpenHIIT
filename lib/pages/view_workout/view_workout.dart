import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openhiit/constants/snackbars.dart';
import 'package:openhiit/database/database_manager.dart';
import 'package:openhiit/log/log.dart';
import 'package:openhiit/old/create_workout/create_timer.dart';
import 'package:openhiit/old/create_workout/create_workout.dart';
import 'package:openhiit/old/helper_widgets/view_workout_appbar.dart';
import 'package:openhiit/old/workout_data_type/workout_type.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

class ViewWorkout extends StatefulWidget {
  const ViewWorkout({super.key});

  @override
  State<ViewWorkout> createState() => _ViewWorkoutState();
}

class _ViewWorkoutState extends State<ViewWorkout> {
  /// Deletes the workout from the database and reorders the remaining workouts.
  /// Displays a snackbar if an error occurs.
  /// - [context]: The BuildContext of the current screen.
  /// - [workout]: The workout to be deleted.
  ///
  void delete(Workout workout) async {
    Database database = await DatabaseManager().initDB();
    try {
      await DatabaseManager().deleteWorkoutAndReorder(workout, database);
    } catch (e) {
      logger.e('Error deleting workout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(errorDeletingWorkoutSnackBar);
      }
    }
    if (mounted) {
      Navigator.of(context)
        ..pop()
        ..pop();
    }
  }

  /// Navigates to the specified page.
  /// - [page]: The page to navigate to.
  /// - [workoutCopy]: The workout object to pass to the page.
  ///
  void navigateToPage(Widget page, Workout workoutCopy) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(
          arguments: workoutCopy,
        ),
      ),
    );
  }

  /// Copies the current workout and updates the list and the database accordingly.
  /// - [workout]: The workout to be copied.
  ///
  void copy(Workout workout) async {
    try {
      // Initialize the database.
      final databaseManager = DatabaseManager();
      final database = await databaseManager.initDB();

      // Fetch the list of workouts from the database.
      final List<Workout> workouts = await databaseManager.workouts(database);

      // Increment the workoutIndex of each workout and update it in the database.
      for (Workout workout in workouts) {
        workout.workoutIndex++;
        await databaseManager.updateWorkout(workout, database);
      }

      // Create a duplicate of the first workout with a new unique ID and a workoutIndex of 0.
      final duplicateWorkout = workouts.first.copy();
      duplicateWorkout.id = const Uuid().v1();
      duplicateWorkout.workoutIndex = 0;

      // Insert the duplicate workout into the database and the beginning of the list.
      await databaseManager.insertWorkout(duplicateWorkout, database);
      workouts.insert(0, duplicateWorkout);

      // Navigate back to the main screen to show that the workout has been copied.
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      logger.e('Error copying workout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            createErrorSnackbar(errorMessage: 'Error copying workout'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Extracting the Workout object from the route arguments.
    ///
    Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

    return Scaffold(
      appBar: ViewWorkoutAppBar(
          onDelete: () async {
            delete(workout);
          },
          onEdit: () {
            if (jsonDecode(workout.exercises).isEmpty) {
              navigateToPage(const CreateTimer(), workout.copy());
            } else {
              navigateToPage(const CreateWorkout(), workout.copy());
            }
          },
          onCopy: () async {
            copy(workout);
          },
          workout: workout,
          height: 40),
      body: Container(
        color: Color(workout.colorInt),
      ),
    );
  }
}

// class ViewWorkout extends StatelessWidget {
//   const ViewWorkout({
//     super.key,
//     required this.color,
//   });

//   /// The color of the workout.
//   ///
//   final Color color;

//   /// Deletes the workout from the database and reorders the remaining workouts.
//   /// Displays a snackbar if an error occurs.
//   /// - [context]: The BuildContext of the current screen.
//   /// - [workout]: The workout to be deleted.
//   ///
//   void delete(BuildContext context, Workout workout) async {
//     Database database = await DatabaseManager().initDB();
//     try {
//       await DatabaseManager().deleteWorkoutAndReorder(workout, database);
//     } catch (e) {
//       logger.e('Error deleting workout: $e');
//       if (context.mounted) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(errorDeletingWorkoutSnackBar);
//       }
//     }
//     if (context.mounted) {
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     /// Extracting the Workout object from the route arguments.
//     ///
//     Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

//     return Scaffold(
//       appBar: ViewWorkoutAppBar(
//           onDelete: () async {
//             delete(context, workout);
//           },
//           onEdit: () {
//             Workout workoutCopy = workout.copy();

//             if (jsonDecode(workout.exercises).isEmpty) {

//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CreateTimer(),
//                   settings: RouteSettings(
//                     arguments: workout,
//                   ),
//                 ),
//               ).then((value) {
//                 if (context.mounted) {
//                   setState(() {
//                     workout = ModalRoute.of(context)!.settings.arguments as Workout;
//                   });
//                 }
//               });

//               pushCreateTimer(workoutCopy, context, false, (value) {
//                 /// When we come back, reload the workout arg.
//                 ///
//                 setState(() {
//                   workout =
//                       ModalRoute.of(context)!.settings.arguments as Workout;
//                 });
//               });
//             } else {
//               pushCreateWorkout(workoutCopy, context, false, (value) {
//                 /// When we come back, reload the workout arg.
//                 ///
//                 setState(() {
//                   workout =
//                       ModalRoute.of(context)!.settings.arguments as Workout;
//                 });
//               });
//             }
//           },
//           onCopy: () {},
//           workout: workout,
//           height: 20),
//       body: Container(
//         color: Color(workout.colorInt),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:uuid/uuid.dart';
// import 'package:flutter/material.dart';
// import '../../old/utils/functions.dart';
// import '../../old/helper_widgets/start_button.dart';
// import 'package:sqflite/sqflite.dart';
// import '../../old/card_widgets/card_item_animated.dart';
// import '../../database/database_manager.dart';
// import '../../old/helper_widgets/view_workout_appbar.dart';
// import '../../old/models/list_model.dart';
// import '../../old/workout_data_type/workout_type.dart';
// import '../../old/models/list_tile_model.dart';
// import '../../old/start_workout/workout.dart';

// class ViewWorkout extends StatefulWidget {
//   const ViewWorkout({super.key});
//   @override
//   ViewWorkoutState createState() => ViewWorkoutState();
// }

// class ViewWorkoutState extends State<ViewWorkout> {
//   /// GlobalKey for the AnimatedList.
//   ///
//   GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

//   /// List of objects including all relevant info for each interval.
//   /// Example: The String exercise for that interval, such as "Work"
//   /// or an entered exercise such as "Bicep Curls".
//   ///
//   late ListModel<ListTileModel> intervalInfo;

//   /// Asynchronously deletes a workout list from the database and updates the
//   /// workout indices of remaining lists accordingly.
//   ///
//   /// Parameters:
//   ///   - [workoutArgument]: The 'Workout' object representing the list to be deleted.
//   ///
//   /// Returns:
//   ///   - A Future representing the completion of the delete operation.
//   Future deleteList(workoutArgument) async {
//     // Initialize the database.
//     Future<Database> database = DatabaseManager().initDB();

//     // Delete the specified workout list from the database.
//     await DatabaseManager()
//         .deleteWorkout(workoutArgument.id, database)
//         .then((value) async {
//       // Retrieve the updated list of workouts from the database.
//       List<Workout> workouts =
//           await DatabaseManager().workouts(await DatabaseManager().initDB());

//       // Sort the workouts based on their workout indices.
//       workouts.sort((a, b) => a.workoutIndex.compareTo(b.workoutIndex));

//       // Update the workout indices of remaining lists after the deleted list.
//       for (int i = workoutArgument.workoutIndex; i < workouts.length; i++) {
//         workouts[i].workoutIndex = i;
//         await DatabaseManager()
//             .updateWorkout(workouts[i], await DatabaseManager().initDB());
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     /// Extracting the Workout object from the route arguments.
//     ///
//     Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

//     /// Parsing the exercises data from the Workout object.
//     ///
//     List<dynamic> exercises =
//         workout.exercises != "" ? jsonDecode(workout.exercises) : [];

//     /// Creating a ListModel to manage the list of ListTileModel items.
//     ///
//     intervalInfo = ListModel<ListTileModel>(
//       listKey: listKey, // Providing a key for the list.
//       initialItems:
//           listItems(exercises, workout), // Initializing the list with items.
//     );

//     /// Getting the height of the current screen using MediaQuery.
//     ///
//     double sizeHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       bottomNavigationBar: Container(
//           color: Color(workout.colorInt),
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).orientation == Orientation.portrait
//               ? MediaQuery.of(context).size.height / 8
//               : MediaQuery.of(context).size.height / 5,
//           child: StartButton(
//             onTap: () async {
//               if (Platform.isAndroid) {
//                 await Permission.scheduleExactAlarm.isDenied.then((value) {
//                   if (value) {
//                     Permission.scheduleExactAlarm.request();
//                   }
//                 });

//                 if (await Permission.scheduleExactAlarm.isDenied) {
//                   return;
//                 }
//               }

//               if (context.mounted) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const CountDownTimer(),
//                     settings: RouteSettings(
//                       arguments: workout,
//                     ),
//                   ),
//                 ).then((value) {
//                   if (context.mounted) setStatusBarBrightness(context);
//                 });
//               }
//             },
//           )),
//       appBar: ViewWorkoutAppBar(
//         workout: workout,
//         height: MediaQuery.of(context).orientation == Orientation.portrait
//             ? 40
//             : 80,
//         onDelete: () {
//           deleteList(workout).then((value) => Navigator.pop(context));
//           Navigator.of(context).pop();
//         },
//         onEdit: () {
//           Workout workoutCopy = workout.copy();

//           if (exercises.isEmpty) {
//             pushCreateTimer(workoutCopy, context, false, (value) {
//               /// When we come back, reload the workout arg.
//               ///
//               setState(() {
//                 workout = ModalRoute.of(context)!.settings.arguments as Workout;
//               });
//             });
//           } else {
//             pushCreateWorkout(workoutCopy, context, false, (value) {
//               /// When we come back, reload the workout arg.
//               ///
//               setState(() {
//                 workout = ModalRoute.of(context)!.settings.arguments as Workout;
//               });
//             });
//           }
//         },
//         onCopy: () async {
//           /// This function is triggered when the "Copy" button is clicked.
//           /// It duplicates the current workout and updates the list and the database accordingly.

//           /// Fetch the list of workouts from the database.
//           List<Workout> workouts = await DatabaseManager()
//               .workouts(await DatabaseManager().initDB());

//           /// Increment the workoutIndex of each workout in the list.
//           for (Workout workout in workouts) {
//             workout.workoutIndex++;
//           }

//           /// Create a duplicate of the current workout with a new unique ID and a workoutIndex of 0.
//           Workout duplicateWorkout = Workout(
//             const Uuid().v1(),
//             workout.title,
//             workout.numExercises,
//             workout.exercises,
//             workout.getReadyTime,
//             workout.workTime,
//             workout.restTime,
//             workout.halfTime,
//             workout.breakTime,
//             workout.warmupTime,
//             workout.cooldownTime,
//             workout.iterations,
//             workout.halfwayMark,
//             workout.workSound,
//             workout.restSound,
//             workout.halfwaySound,
//             workout.completeSound,
//             workout.countdownSound,
//             workout.colorInt,
//             0,
//             workout.showMinutes,
//           );

//           /// Insert the duplicate workout at the beginning of the list.
//           workouts.insert(0, duplicateWorkout);

//           /// Initialize the database.
//           Database database = await DatabaseManager().initDB();

//           /// Insert the duplicate workout into the database.
//           await DatabaseManager().insertWorkout(duplicateWorkout, database);

//           /// Update the workoutIndex of each workout in the database.
//           for (Workout workout in workouts) {
//             await DatabaseManager().updateWorkout(workout, database);
//           }

//           /// Navigate back to the main screen to show that the workout has been copied.
//           /// The check for context.mounted ensures that the Navigator.pop() method is only called if the widget is still in the widget tree.
//           if (context.mounted) Navigator.of(context).pop();
//         },
//       ),
//       body: Container(
//           color: Color(workout.colorInt),
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Visibility(
//                 visible:
//                     MediaQuery.of(context).orientation == Orientation.portrait
//                         ? true
//                         : false,
//                 child: Expanded(
//                     flex: 4,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const Spacer(),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.timer,
//                               color: Colors.white,
//                               size: sizeHeight * .07,
//                             ),
//                             Text(
//                               "${calculateWorkoutTime(workout)} minutes",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   fontSize: sizeHeight * .03),
//                             )
//                           ],
//                         ),
//                         const Spacer(),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.view_timeline,
//                               color: Colors.white,
//                               size: sizeHeight * .07,
//                             ),
//                             Text(
//                               "${workout.numExercises} intervals",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   fontSize: sizeHeight * .03),
//                             )
//                           ],
//                         ),
//                         const Spacer(),
//                       ],
//                     ))),
//             Expanded(
//                 flex: 10,
//                 child: AnimatedList(
//                   key: listKey,
//                   initialItemCount: intervalInfo.length,
//                   itemBuilder: (context, index, animation) {
//                     return CardItemAnimated(
//                       animation: animation,
//                       item: intervalInfo[index],
//                       fontColor: Colors.white,
//                       fontWeight:
//                           index == 0 ? FontWeight.bold : FontWeight.normal,
//                       backgroundColor: Color(workout.colorInt),
//                       sizeMultiplier: 1,
//                     );
//                   },
//                 ))
//           ])),
//     );
//   }
// }
