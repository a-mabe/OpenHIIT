import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper_functions/functions.dart';
import '../helper_widgets/start_button.dart';
import 'package:sqflite/sqflite.dart';
import '../card_widgets/card_item_animated.dart';
import '../database/database_manager.dart';
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

  Color iconColor() {
    final darkMode =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (darkMode == Brightness.dark) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Future deleteList(workoutArgument) async {
    Future<Database> database = DatabaseManager().initDB();

    await DatabaseManager()
        .deleteList(workoutArgument.id, database)
        .then((value) async {
      List<Workout> workouts =
          await DatabaseManager().lists(DatabaseManager().initDB());
      workouts.sort((a, b) => a.workoutIndex.compareTo(b.workoutIndex));
      for (int i = workoutArgument.workoutIndex; i < workouts.length; i++) {
        workouts[i].workoutIndex = i;
        await DatabaseManager()
            .updateList(workouts[i], await DatabaseManager().initDB());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

    List<dynamic> exercises =
        workout.exercises != "" ? jsonDecode(workout.exercises) : [];

    intervalInfo = ListModel<ListTileModel>(
      listKey: listKey,
      initialItems: listItems(exercises, workout),
    );

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
                WidgetsBinding.instance.renderViews.first
                    .automaticSystemUiAdjustment = false;

                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarBrightness: Theme.of(context).brightness,
                ));
              });
            },
          )),
      appBar: AppBar(
        title: Text(workout.title),
        backgroundColor: Color(workout.colorInt),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete, color: iconColor()),
            tooltip: 'Delete timer',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete ${workout.title}'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                              'Are you sure you would like to delete ${workout.title}?'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          deleteList(workout)
                              .then((value) => Navigator.pop(context));
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: iconColor()),
            onPressed: () {
              if (exercises.isEmpty) {
                pushCreateTimer(workout, context);
              } else {
                pushCreateWorkout(workout, context);
              }
            },
          ),
        ],
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
