import 'dart:convert';
import 'dart:io';
import 'package:openhiit/pages/home/home.dart';
import 'package:openhiit/providers/workout_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../../utils/functions.dart';
import 'widgets/start_button.dart';
import '../../widgets/card_item_animated.dart';
import '../../utils/database/database_manager.dart';
import 'widgets/view_workout_appbar.dart';
import '../../models/lists/list_model.dart';
import '../../models/workout_type.dart';
import '../../models/lists/list_tile_model.dart';
import '../active_timer/workout.dart';

class ViewWorkout extends StatefulWidget {
  final Workout workout;
  const ViewWorkout({super.key, required this.workout});
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
    WorkoutProvider workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);
    DatabaseManager databaseManager = DatabaseManager();

    workoutProvider.deleteWorkout(workoutArgument);
    workoutProvider.updateWorkoutIndices(0);
    databaseManager.updateWorkouts(workoutProvider.workouts);
  }

  @override
  Widget build(BuildContext context) {
    Workout workout = widget.workout;

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
            onTap: () async {
              if (Platform.isAndroid) {
                await Permission.scheduleExactAlarm.isDenied.then((value) {
                  if (value) {
                    Permission.scheduleExactAlarm.request();
                  }
                });

                if (await Permission.scheduleExactAlarm.isDenied) {
                  return;
                }
              }

              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CountDownTimer(workout: workout),
                    settings: RouteSettings(
                      arguments: workout,
                    ),
                  ),
                ).then((value) {
                  setStatusBarBrightness(context);
                });
              }
            },
          )),
      appBar: ViewWorkoutAppBar(
        workout: workout,
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? 40
            : 80,
        onDelete: () {
          deleteList(workout).then((value) {
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MyHomePage()),
                  (route) => false);
            }
          });
        },
        onEdit: () {
          Workout workoutCopy = workout.copy();

          if (exercises.isEmpty) {
            pushCreateTimer(workoutCopy, context, false, (value) {
              /// When we come back, reload the workout arg.
              ///
              setState(() {
                workout = ModalRoute.of(context)!.settings.arguments as Workout;
              });
            });
          } else {
            pushCreateWorkout(workoutCopy, context, false, (value) {
              /// When we come back, reload the workout arg.
              ///
              setState(() {
                workout = ModalRoute.of(context)!.settings.arguments as Workout;
              });
            });
          }
        },
        onCopy: () async {
          /// This function is triggered when the "Copy" button is clicked.
          /// It duplicates the current workout and updates the list and the database accordingly.

          /// Fetch the list of workouts from the database.
          List<Workout> workouts = await DatabaseManager().getWorkouts();

          /// Increment the workoutIndex of each workout in the list.
          for (Workout workout in workouts) {
            workout.workoutIndex++;
          }

          /// Create a duplicate of the current workout with a new unique ID and a workoutIndex of 0.
          Workout duplicateWorkout = Workout(
            const Uuid().v1(),
            workout.title,
            workout.numExercises,
            workout.exercises,
            workout.getReadyTime,
            workout.workTime,
            workout.restTime,
            workout.halfTime,
            workout.breakTime,
            workout.warmupTime,
            workout.cooldownTime,
            workout.iterations,
            workout.halfwayMark,
            workout.workSound,
            workout.restSound,
            workout.halfwaySound,
            workout.completeSound,
            workout.countdownSound,
            workout.colorInt,
            0,
            workout.showMinutes,
          );

          /// Insert the duplicate workout at the beginning of the list.
          workouts.insert(0, duplicateWorkout);

          /// Insert the duplicate workout into the database.
          await DatabaseManager().insertWorkout(duplicateWorkout);

          /// Update the workoutIndex of each workout in the database.
          for (Workout workout in workouts) {
            await DatabaseManager().updateWorkout(workout);
          }

          /// Navigate back to the main screen to show that the workout has been copied.
          /// The check for context.mounted ensures that the Navigator.pop() method is only called if the widget is still in the widget tree.
          if (context.mounted) Navigator.of(context).pop();
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
                      sizeMultiplier: 1,
                    );
                  },
                ))
          ])),
    );
  }
}
