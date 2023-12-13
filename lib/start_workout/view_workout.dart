import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import '../create_workout/create_timer.dart';
import '../create_workout/create_workout.dart';
import '../database/database_manager.dart';
import '../models/list_model.dart';
import '../workout_data_type/workout_type.dart';
import '../card_widgets/card_item.dart';
import '../models/list_tile_model.dart';
import 'workout.dart';

class ViewWorkout extends StatefulWidget {
  const ViewWorkout({super.key});
  @override
  ViewWorkoutState createState() => ViewWorkoutState();
}

class ViewWorkoutState extends State<ViewWorkout> {
  late ListModel<ListTileModel> _intervalInfo;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void pushCreateWorkout(workout) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseNumber(),
          settings: RouteSettings(
            arguments: workout,
          ),
        ),
      );
    });
  }

  void pushCreateTimer(workout) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseIntervals(),
          settings: RouteSettings(
            arguments: workout,
          ),
        ),
      );
    });
  }

  List<ListTileModel> listItems(List exercises, Workout workoutArgument) {
    List<ListTileModel> listItems = [];

    for (var i = 0; i < workoutArgument.numExercises + 1; i++) {
      if (i == 0) {
        listItems.add(
          ListTileModel(
            action: "Prepare",
            showMinutes: workoutArgument.showMinutes,
            interval: 0,
            total: workoutArgument.numExercises,
            seconds: 10,
          ),
        );
      } else {
        if (exercises.length < workoutArgument.numExercises) {
          listItems.add(
            ListTileModel(
              action: "Work",
              showMinutes: workoutArgument.showMinutes,
              interval: i,
              total: workoutArgument.numExercises,
              seconds: workoutArgument.exerciseTime,
            ),
          );
          if (i < workoutArgument.numExercises) {
            listItems.add(
              ListTileModel(
                action: "Rest",
                showMinutes: workoutArgument.showMinutes,
                interval: 0,
                total: workoutArgument.numExercises,
                seconds: workoutArgument.restTime,
              ),
            );
          }
        } else {
          listItems.add(
            ListTileModel(
              action: exercises[i - 1],
              showMinutes: workoutArgument.showMinutes,
              interval: i,
              total: workoutArgument.numExercises,
              seconds: workoutArgument.exerciseTime,
            ),
          );
          if (i < workoutArgument.numExercises) {
            listItems.add(
              ListTileModel(
                action: "Rest",
                showMinutes: workoutArgument.showMinutes,
                interval: 0,
                total: workoutArgument.numExercises,
                seconds: workoutArgument.restTime,
              ),
            );
          }
        }
      }
    }

    return listItems;
  }

  @override
  void initState() {
    super.initState();
    _intervalInfo = ListModel<ListTileModel>(
      listKey: _listKey,
      initialItems: <ListTileModel>[],
    );
  }

  Future deleteList(workoutArgument, database) async {
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

  Color iconColor() {
    final darkMode =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (darkMode == Brightness.dark) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.renderViews.first.automaticSystemUiAdjustment =
        false;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Theme.of(context).brightness,
    ));

    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    List<dynamic> exercises = workoutArgument.exercises != ""
        ? jsonDecode(workoutArgument.exercises)
        : [];
    Future<Database> database = DatabaseManager().initDB();

    Widget exerciseList() {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _intervalInfo.length,
        itemBuilder: (BuildContext context, int index) {
          return CardItem(item: _intervalInfo[index]);
        },
      );
    }

    if (_intervalInfo.length == 0) {
      _intervalInfo = ListModel<ListTileModel>(
        listKey: _listKey,
        initialItems: listItems(exercises, workoutArgument),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(workoutArgument.colorInt),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete, color: iconColor()),
            tooltip: 'Show Snackbar',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete ${workoutArgument.title}'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                              'Are you sure you would like to delete ${workoutArgument.title}?'),
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
                        onPressed: () async {
                          await deleteList(workoutArgument, database)
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
                pushCreateTimer(workoutArgument);
              } else {
                pushCreateWorkout(workoutArgument);
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CountDownTimer(),
                        settings: RouteSettings(
                          arguments: workoutArgument,
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
                  child: Ink(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width * 0.25,
                    color: Colors.green,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          Text("Start")
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: exerciseList(),
      ),
    );
  }
}
