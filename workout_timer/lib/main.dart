import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'create_workout/create_workout.dart';
import 'workout_type/workout_type.dart';
import 'database/database_manager.dart';
import 'start_workout/view_workout.dart';

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
  /// The list of workouts to be loaded with [DatabaseManager()].
  late Future<List<Workout>> workouts;

  /// Push to the [CreateWorkout()] page.
  ///
  /// Then, refresh the [workouts].
  void pushCreateWorkoutPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateWorkout()),
    ).then((value) {
      setState(() {
        workouts = DatabaseManager().lists(DatabaseManager().initDB());
      });
    });
  }
  // ---

  /// Generates the ListView to display [workouts].
  Widget workoutListView(snapshot) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: snapshot.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          // Title of the workout.
          title: Text(snapshot.data![index].title),
          // Workout metadata.
          subtitle: Text(
              '${jsonDecode(snapshot.data![index].exercises).length} exercises, X minutes'),
          tileColor: Colors.blue[700],
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(index.toString())));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewWorkout(),
                settings: RouteSettings(
                  arguments: snapshot.data![index],
                ),
              ),
            ).then((value) {
              setState(() {
                workouts = DatabaseManager().lists(DatabaseManager().initDB());
              });
            });
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
  // ---

  @override
  Widget build(BuildContext context) {
    workouts = DatabaseManager().lists(DatabaseManager().initDB());
    return Scaffold(
      appBar: AppBar(),

      /// Pushes to [CreateWorkout()]
      floatingActionButton: FloatingActionButton(
        onPressed: pushCreateWorkoutPage,
        tooltip: 'Create workout',
        child: const Icon(Icons.add),
      ),
      // ---

      body: FutureBuilder<List<Workout>>(
        future: workouts,
        builder: (BuildContext context, AsyncSnapshot<List<Workout>> snapshot) {
          /// When [workouts] has successfully loaded.
          if (snapshot.hasData) {
            return workoutListView(snapshot);
          }

          /// When there was an error loading [workouts].
          else if (snapshot.hasError) {
            return workoutFetchError(snapshot);
          }

          /// While still waiting to load [workouts].
          else {
            return workoutLoading();
          }
        },
      ),
    );
  }
}
