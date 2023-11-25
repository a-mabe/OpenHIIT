import 'dart:convert';

import 'package:flutter/material.dart';
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
          builder: (context) => const CreateWorkout(),
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
          builder: (context) => const CreateTimer(),
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
              interval: i,
              total: workoutArgument.numExercises,
              seconds: workoutArgument.exerciseTime,
            ),
          );
          if (i < workoutArgument.numExercises) {
            listItems.add(
              ListTileModel(
                action: "Rest",
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
              interval: i,
              total: workoutArgument.numExercises,
              seconds: workoutArgument.exerciseTime,
            ),
          );
          if (i < workoutArgument.numExercises) {
            listItems.add(
              ListTileModel(
                action: "Rest",
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

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.delete),
            tooltip: 'Show Snackbar',
            onPressed: () async {
              await deleteList(workoutArgument, database)
                  .then((value) => Navigator.pop(context));
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
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
                    );
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
