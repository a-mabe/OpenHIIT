import 'dart:async';
import 'dart:convert';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'create_workout/select_timer.dart';
import 'workout_data_type/workout_type.dart';
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

  @override
  initState() {
    super.initState();
    init();
  }

  void init() async {
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.music());

    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ),
    );
  }

  int calculateWorkoutTime(Workout workout) {
    return (((workout.exerciseTime * workout.numExercises) +
                (workout.restTime * (workout.numExercises - 1)) +
                (workout.halfTime * workout.numExercises)) /
            60)
        .round();
  }

  /// Push to the [CreateWorkout()] page.
  ///
  /// Then, refresh the [workouts].
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
          titleTextStyle: const TextStyle(
            fontSize: 20,
          ),
          // Workout metadata.
          subtitle: Text(
              '''${snapshot.data![index].exercises != "" ? 'Exercises: ${jsonDecode(snapshot.data![index].exercises).length}' : 'Intervals: ${snapshot.data![index].numExercises}'}
Exercise time: ${snapshot.data![index].exerciseTime} seconds
Rest time: ${snapshot.data![index].restTime} seconds
Total: ${calculateWorkoutTime(snapshot.data![index])} minutes'''),
          subtitleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          tileColor: Colors.blue[700],
          minVerticalPadding: 15.0,
          onTap: () {
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
      // appBar: AppBar(),

      /// Pushes to [CreateWorkout()]
      floatingActionButton: FloatingActionButton(
        onPressed: pushSelectTimerPage,
        tooltip: 'Create workout',
        child: const Icon(Icons.add),
      ),
      // ---

      body: SafeArea(
        child: FutureBuilder<List<Workout>>(
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
      ),
    );
  }
}
