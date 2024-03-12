import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openhiit/utils/functions.dart';
import 'package:sqflite/sqflite.dart';
import 'create_workout/select_timer.dart';
import 'workout_data_type/workout_type.dart';
import 'database/database_manager.dart';
import 'start_workout/view_workout.dart';
import 'helper_widgets/timer_list_tile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = false;

  /// Monospaced font licensing.
  ///
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(const WorkoutTimer());
}

class WorkoutTimer extends StatelessWidget {
  const WorkoutTimer({super.key});

  /// Application root.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenHIIT',
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
  /// List of workouts for reordering. The newly reordered
  /// workout indeices with be saved to the DB.
  ///
  List<Workout> reorderableWorkoutList = [];

  /// The initial list of workouts to be loaded fresh
  /// from the DB.
  ///
  late Future<List<Workout>> workouts;

  /// Initialize...
  @override
  void initState() {
    super.initState();
    workouts = DatabaseManager().lists(DatabaseManager().initDB());
  }
  // ---

  /// Callback function for handling the reordering of items in the list.
  ///
  /// Parameters:
  ///   - [oldIndex]: The index of the item before reordering.
  ///   - [newIndex]: The index where the item is moved to after reordering.
  ///
  void _onReorder(int oldIndex, int newIndex) async {
    // Ensure newIndex does not exceed the length of the list.
    if (newIndex > reorderableWorkoutList.length) {
      newIndex = reorderableWorkoutList.length;
    }

    // Adjust newIndex if oldIndex is less than newIndex.
    if (oldIndex < newIndex) newIndex -= 1;

    // Extract the Workout item being reordered.
    final Workout item = reorderableWorkoutList[oldIndex];
    // Remove the item from its old position.
    reorderableWorkoutList.removeAt(oldIndex);

    // Update the workoutIndex of the item to the new position.
    item.workoutIndex = newIndex;
    // Insert the item at the new position.
    reorderableWorkoutList.insert(newIndex, item);

    // Update the workoutIndex for all items in the list.
    setState(() {
      for (var i = 0; i < reorderableWorkoutList.length; i++) {
        reorderableWorkoutList[i].workoutIndex = i;
      }
    });

    // Initialize the database and update the workout order in the database.
    Database database = await DatabaseManager().initDB();

    for (var i = 0; i < reorderableWorkoutList.length; i++) {
      // Update the workout order in the database.
      await DatabaseManager().updateList(reorderableWorkoutList[i], database);
    }
  }
  // ---

  /// Method called when a workout is tapped. Opens up the view workout page
  /// for that workout.
  ///
  void onWorkoutTap(Workout tappedWorkout) {
    /// Push the ViewWorkout page.
    ///
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ViewWorkout(),

        /// Pass the [tappedWorkout] as an argument to
        /// the ViewWorkout page.
        settings: RouteSettings(
          arguments: tappedWorkout,
        ),
      ),
    ).then((value) {
      /// When we come back to the hompage, refresh the
      /// list of workouts by reloading from the DB.
      ///
      setState(() {
        workouts = DatabaseManager().lists(DatabaseManager().initDB());
      });
    });
  }
  // ---

  /// Widget for displaying a ReorderableListView of workout items.
  ///
  /// Parameters:
  ///   - [snapshot]: The data snapshot from the database containing workout information.
  Widget workoutListView(snapshot) {
    return ReorderableListView(
      onReorder: _onReorder, // Callback for handling item reordering.
      proxyDecorator: proxyDecorator, // Decorator for the dragged item.
      children: [
        /// For each workout in the returned DB data snapshot.
        ///
        for (final workout in snapshot.data)
          TimerListTile(
            key: Key(
                '${workout.workoutIndex}'), // Unique key for each list item.
            workout: workout,
            onTap: () {
              onWorkoutTap(workout);
            },
            index: workout.workoutIndex,
          ),
      ],
    );
  }
  // ---

  /// Generates the empty message for no [workouts] in DB.
  ///
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
  ///
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

  /// Generates the loading circle, display as workouts
  /// are being loaded from the DB.
  ///
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

  /// Load the page for the user to select whether they'd like
  /// to create a new interval timer or workout.
  ///
  void pushSelectTimerPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectTimer()),
    ).then((value) {
      /// When we come back to the hompage, refresh the
      /// list of workouts by reloading from the DB.
      ///
      setState(() {
        workouts = DatabaseManager().lists(DatabaseManager().initDB());
      });
    });
  }
  // ---

  /// The widget to return for a workout tile as it's being dragged.
  /// This AnimatedBuilder will slightly increase the elevation of the dragged
  /// workout without changing other UI elements.
  ///
  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
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
  // ---

  /// Build the home screen UI.
  ///
  @override
  Widget build(BuildContext context) {
    setStatusBarBrightness(context);

    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Scaffold(

              /// Pushes to [SelectTimer()]
              floatingActionButton: FloatingActionButton(
                onPressed: pushSelectTimerPage,
                tooltip: 'Create a new timer',
                child: const Icon(Icons.add),
              ),
              body: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
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
  // ---
}
