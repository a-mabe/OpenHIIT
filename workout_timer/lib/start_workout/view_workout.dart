import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_manager.dart';
import '../workout_type/workout_type.dart';
import 'workout.dart';

class ViewWorkout extends StatefulWidget {
  const ViewWorkout({super.key});
  @override
  ViewWorkoutState createState() => ViewWorkoutState();
}

class ViewWorkoutState extends State<ViewWorkout> {
  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    List<dynamic> exercises = jsonDecode(workoutArgument.exercises);
    Future<Database> database = DatabaseManager().initDB();

    Widget exerciseList() {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: exercises.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: (index % 2 == 0) ? Colors.grey[50] : Colors.grey[100],
            child: Center(child: Text(exercises[index])),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Show Snackbar',
            onPressed: () async {
              await DatabaseManager()
                  .deleteList(workoutArgument.id, database)
                  .then((value) {
                Navigator.pop(context);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              print(workoutArgument);
            },
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width * 0.25,
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width * 0.25,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StartWorkout(),
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
                        ))),
                  ),
                ),
              ],
            )),
      ),
      body: Center(
        child: exerciseList(),
      ),
    );
  }
}
