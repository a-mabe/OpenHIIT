import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'create_workout/select_timer.dart';
import 'workout_data_type/workout_type.dart';
import 'database/database_manager.dart';
import 'start_workout/view_workout.dart';
import 'helper_widgets/timer_list_tile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const WorkoutTimer());
}

class WorkoutTimer extends StatelessWidget {
  const WorkoutTimer({super.key});

  /// Application root.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(), // standard dark theme
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Workout> reorderableWorkoutList = [];
  late Future<List<Workout>> workouts;

  void _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > reorderableWorkoutList.length) {
      newIndex = reorderableWorkoutList.length;
    }
    if (oldIndex < newIndex) newIndex -= 1;

    final Workout item = reorderableWorkoutList[oldIndex];
    reorderableWorkoutList.removeAt(oldIndex);

    item.workoutIndex = newIndex;
    reorderableWorkoutList.insert(newIndex, item);

    setState(() {
      for (var i = 0; i < reorderableWorkoutList.length; i++) {
        reorderableWorkoutList[i].workoutIndex = i;
      }
    });

    Database database = await DatabaseManager().initDB();

    for (var i = 0; i < reorderableWorkoutList.length; i++) {
      await DatabaseManager().updateList(reorderableWorkoutList[i], database);
    }
  }

  @override
  void initState() {
    super.initState();
    workouts = DatabaseManager().lists(DatabaseManager().initDB());
  }

  Widget workoutListView(snapshot) {
    return ReorderableListView(
        onReorder: _onReorder,
        proxyDecorator: proxyDecorator,
        children: [
          for (final workout in snapshot.data)
            TimerListTile(
                key: Key('${workout.workoutIndex}'),
                workout: workout,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewWorkout(),
                      settings: RouteSettings(
                        arguments: workout,
                      ),
                    ),
                  ).then((value) {
                    setState(() {
                      workouts =
                          DatabaseManager().lists(DatabaseManager().initDB());
                    });
                  });
                },
                index: workout.workoutIndex),
        ]);
  }

  /// Generates the empty message for no [workouts] in DB.
  Widget workoutEmpty() {
    List<Widget> children;
    children = <Widget>[
      const Text(
        'No saved timers',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        'Hit the + at the bottom to get started!',
      ),
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
  // ---

  /// Generates the error message for an issue loading [workouts].
  Widget workoutFetchError(snapshot) {
    List<Widget> children;
    children = <Widget>[
      const Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 60,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text('Error: ${snapshot.error}'),
      ),
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
  // ---

  /// Generates the loading circle.
  Widget workoutLoading() {
    List<Widget> children;
    children = const <Widget>[
      SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Awaiting result...'),
      ),
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
  // ---

  void pushSelectTimerPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectTimer()),
    ).then((value) {
      setState(() {
        workouts = DatabaseManager().lists(DatabaseManager().initDB());
      });
    });
  }
  // ---

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        // final double elevation = lerpDouble(1, 6, animValue)!;
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
            scale: scale,
            // Create a Card based on the color and the content of the dragged one
            // and set its elevation to the animated value.
            child: child);
      },
      child: child,
    );
  }

  /// ---

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Scaffold(

              /// Pushes to [CreateWorkout()]
              floatingActionButton: FloatingActionButton(
                onPressed: pushSelectTimerPage,
                tooltip: 'Create workout',
                child: const Icon(Icons.add),
              ),
              body: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.882,
                      child: FutureBuilder(
                          future: workouts,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            /// When [workouts] has successfully loaded.
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return workoutEmpty();
                              } else {
                                reorderableWorkoutList = snapshot.data;
                                reorderableWorkoutList.sort((a, b) =>
                                    a.workoutIndex.compareTo(b.workoutIndex));
                                return workoutListView(snapshot);
                              }
                            }

                            /// When there was an error loading [workouts].
                            else if (snapshot.hasError) {
                              return workoutFetchError(snapshot);
                            }

                            /// While still waiting to load [workouts].
                            else {
                              return workoutLoading();
                            }
                          })))),
        ));
  }
}
