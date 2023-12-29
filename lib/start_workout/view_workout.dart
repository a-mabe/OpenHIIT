import 'dart:convert';

import 'package:flutter/material.dart';
import '../helper_functions/functions.dart';
import '../helper_widgets/start_button.dart';
import 'package:sqflite/sqflite.dart';
import '../card_widgets/card_item_animated.dart';
import '../database/database_manager.dart';
import '../helper_widgets/view_workout_appbar.dart';
import '../models/list_model.dart';
import '../workout_data_type/workout_type.dart';
import '../models/list_tile_model.dart';
import 'workout.dart';

class ViewWorkout extends StatefulWidget {
  const ViewWorkout({super.key});
  @override
  ViewWorkoutState createState() => ViewWorkoutState();
}

class ViewWorkoutState extends State<ViewWorkout> {
  /// GlobalKey for the AnimatedList.
  ///
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  /// List of objects including all relevant info for each interval.
  /// Example: The String exercise for that interval, such as "Work"
  /// or an entered exercise such as "Bicep Curls".
  ///
  late ListModel<ListTileModel> intervalInfo;

  /// Asynchronously deletes a workout list from the database and updates the
  /// workout indices of remaining lists accordingly.
  ///
  /// Parameters:
  ///   - [workoutArgument]: The 'Workout' object representing the list to be deleted.
  ///
  /// Returns:
  ///   - A Future representing the completion of the delete operation.
  Future deleteList(workoutArgument) async {
    // Initialize the database.
    Future<Database> database = DatabaseManager().initDB();

    // Delete the specified workout list from the database.
    await DatabaseManager()
        .deleteList(workoutArgument.id, database)
        .then((value) async {
      // Retrieve the updated list of workouts from the database.
      List<Workout> workouts =
          await DatabaseManager().lists(DatabaseManager().initDB());

      // Sort the workouts based on their workout indices.
      workouts.sort((a, b) => a.workoutIndex.compareTo(b.workoutIndex));

      // Update the workout indices of remaining lists after the deleted list.
      for (int i = workoutArgument.workoutIndex; i < workouts.length; i++) {
        workouts[i].workoutIndex = i;
        await DatabaseManager()
            .updateList(workouts[i], await DatabaseManager().initDB());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Extracting the Workout object from the route arguments.
    ///
    Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

    /// Parsing the exercises data from the Workout object.
    ///
    List<dynamic> exercises =
        workout.exercises != "" ? jsonDecode(workout.exercises) : [];

    /// Creating a ListModel to manage the list of ListTileModel items.
    ///
    intervalInfo = ListModel<ListTileModel>(
      listKey: listKey, // Providing a key for the list.
      initialItems:
          listItems(exercises, workout), // Initializing the list with items.
    );

    /// Getting the height of the current screen using MediaQuery.
    ///
    double sizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: Container(
          color: Color(workout.colorInt),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height / 8
              : MediaQuery.of(context).size.height / 5,
          child: StartButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CountDownTimer(),
                  settings: RouteSettings(
                    arguments: workout,
                  ),
                ),
              ).then((value) {
                setStatusBarBrightness(context);
              });
            },
          )),
      appBar: ViewWorkoutAppBar(
        workout: workout,
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? 40
            : 80,
        onDelete: () {
          deleteList(workout).then((value) => Navigator.pop(context));
          Navigator.of(context).pop();
        },
        onEdit: () {
          if (exercises.isEmpty) {
            pushCreateTimer(workout, context);
          } else {
            pushCreateWorkout(workout, context);
          }
        },
      ),
      body: Container(
          color: Color(workout.colorInt),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Visibility(
                visible:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? true
                        : false,
                child: Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                              size: sizeHeight * .07,
                            ),
                            Text(
                              "${calculateWorkoutTime(workout)} minutes",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: sizeHeight * .03),
                            )
                          ],
                        ),
                        const Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.view_timeline,
                              color: Colors.white,
                              size: sizeHeight * .07,
                            ),
                            Text(
                              "${workout.numExercises} intervals",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: sizeHeight * .03),
                            )
                          ],
                        ),
                        const Spacer(),
                      ],
                    ))),
            Expanded(
                flex: 10,
                child: AnimatedList(
                  key: listKey,
                  initialItemCount: intervalInfo.length,
                  itemBuilder: (context, index, animation) {
                    return CardItemAnimated(
                      animation: animation,
                      item: intervalInfo[index],
                      fontColor: Colors.white,
                      fontWeight:
                          index == 0 ? FontWeight.bold : FontWeight.normal,
                      backgroundColor: Color(workout.colorInt),
                    );
                  },
                ))
          ])),
    );
  }
}
