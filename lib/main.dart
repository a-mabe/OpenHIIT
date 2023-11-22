import 'dart:async';
import 'dart:convert';
import 'dart:ui';

// import 'package:audio_session/audio_session.dart';
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
  List<Workout> noteList = [];
  late Future<List<Workout>> workouts;

  void _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > noteList.length) newIndex = noteList.length;
    if (oldIndex < newIndex) newIndex -= 1;

    final Workout item = noteList[oldIndex];
    noteList.removeAt(oldIndex);

    item.workoutIndex = newIndex;
    noteList.insert(newIndex, item);

    setState(() {
      for (var i = 0; i < noteList.length; i++) {
        noteList[i].workoutIndex = i;
      }
    });

    for (var i = 0; i < noteList.length; i++) {
      await DatabaseManager()
          .updateList(noteList[i], await DatabaseManager().initDB());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
                    // _updateAppbar(context);
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
      // _updateAppbar(context);
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
    return Scaffold(
      /// Pushes to [CreateWorkout()]
      floatingActionButton: FloatingActionButton(
        onPressed: pushSelectTimerPage,
        tooltip: 'Create workout',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.882,
                  child: FutureBuilder(
                      future: workouts,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        /// When [workouts] has successfully loaded.
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return workoutEmpty();
                          } else {
                            print("Updating the notesList!!!!!!!!!!");
                            noteList = snapshot.data;
                            noteList.sort((a, b) =>
                                a.workoutIndex.compareTo(b.workoutIndex));
                            for (var i = 0; i < noteList.length; i++) {
                              print("------");
                              print(noteList[i].title);
                              print(noteList[i].workoutIndex);
                              print("------");
                            }
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
                        // if (snapshot.data == null) {
                        //   return const Text('Loading');
                        // } else {
                        //   if (snapshot.data.length < 1) {
                        //     return const Center(
                        //       child: Text('No Messages, Create New one'),
                        //     );
                        //   }

                        //   noteList = snapshot.data;
                        // }
                      })))),
    );
  }
}

// import 'dart:async';
// import 'dart:convert';

// // import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'create_workout/select_timer.dart';
// import 'workout_data_type/workout_type.dart';
// import 'database/database_manager.dart';
// import 'start_workout/view_workout.dart';
// import 'helper_widgets/timer_list_tile.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(const WorkoutTimer());
// }

// class WorkoutTimer extends StatelessWidget {
//   const WorkoutTimer({super.key});

//   /// Application root.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(),
//       darkTheme: ThemeData.dark(), // standard dark theme
//       themeMode: ThemeMode.system,
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   /// The list of workouts to be loaded with [DatabaseManager()].
//   late Future<List<Workout>> workouts;
//   List<Workout> items = [];

//   @override
//   initState() {
//     super.initState();
//     // init();
//   }

//   void _updateAppbar(context) async {
//     var brightness = MediaQuery.of(context).platformBrightness;
//     bool isDarkMode = brightness == Brightness.dark;

//     Brightness statusBarBrightness;

//     if (isDarkMode) {
//       statusBarBrightness = Brightness.dark;
//     } else {
//       statusBarBrightness = Brightness.light;
//     }

//     Future.delayed(Duration(milliseconds: 100)).then((_) =>
//         SystemChrome.setSystemUIOverlayStyle(
//             SystemUiOverlayStyle(statusBarBrightness: statusBarBrightness)));
//   }

//   /// Push to the [CreateWorkout()] page.
//   ///
//   /// Then, refresh the [workouts].
//   void pushSelectTimerPage() async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const SelectTimer()),
//     ).then((value) {
//       _updateAppbar(context);
//       setState(() {
//         workouts = DatabaseManager().lists(DatabaseManager().initDB());
//       });
//     });
//   }
//   // ---

//   /// Generates the ListView to display [workouts].
//   Widget workoutListView(items) {
//     final ColorScheme colorScheme = Theme.of(context).colorScheme;
//     final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
//     final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

//     return ReorderableListView(
//       padding: const EdgeInsets.symmetric(horizontal: 40),
//       children: <Widget>[
//         for (int index = 0; index < items.length; index += 1)
//           ListTile(
//             key: ValueKey('$index'),
//             tileColor: index % 2 != 0 ? oddItemColor : evenItemColor,
//             title: Text('Item ${items[index]}'),
//             trailing: ReorderableDragStartListener(
//               index: index,
//               child: const Icon(Icons.drag_handle),
//             ),
//           ),
//       ],
//       onReorder: (int oldIndex, int newIndex) {
//         if (newIndex > items.length) newIndex = items.length;
//         if (oldIndex < newIndex) newIndex -= 1;

//         setState(() {
//           final Workout item = items[oldIndex];
//           items.removeAt(oldIndex);

//           print(item.title);
//           items.insert(newIndex, item);
//         });
//       },
//     );
//     // return ListView.separated(
//     //   scrollDirection: Axis.vertical,
//     //   shrinkWrap: true,
//     //   padding: const EdgeInsets.all(8),
//     //   itemCount: snapshot.data!.length,
//     //   itemBuilder: (BuildContext context, int index) {
//     //     Workout workout = snapshot.data![index] as Workout;
//     //     return TimerListTile(
//     //         workout: workout,
//     //         onTap: () {
//     //           Navigator.push(
//     //             context,
//     //             MaterialPageRoute(
//     //               builder: (context) => const ViewWorkout(),
//     //               settings: RouteSettings(
//     //                 arguments: workout,
//     //               ),
//     //             ),
//     //           ).then((value) {
//     //             _updateAppbar(context);
//     //             setState(() {
//     //               workouts =
//     //                   DatabaseManager().lists(DatabaseManager().initDB());
//     //             });
//     //           });
//     //         });
//     //   },
//     //   separatorBuilder: (BuildContext context, int index) => const Divider(),
//     // );
//   }
//   // ---

//   /// Generates the empty message for no [workouts] in DB.
//   Widget workoutEmpty() {
//     List<Widget> children;
//     children = <Widget>[
//       const Text(
//         'No saved timers',
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       const SizedBox(height: 5),
//       const Text(
//         'Hit the + at the bottom to get started!',
//       ),
//     ];
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: children,
//       ),
//     );
//   }
//   // ---

//   /// Generates the error message for an issue loading [workouts].
//   Widget workoutFetchError(snapshot) {
//     List<Widget> children;
//     children = <Widget>[
//       const Icon(
//         Icons.error_outline,
//         color: Colors.red,
//         size: 60,
//       ),
//       Padding(
//         padding: const EdgeInsets.only(top: 16),
//         child: Text('Error: ${snapshot.error}'),
//       ),
//     ];
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: children,
//       ),
//     );
//   }
//   // ---

//   /// Generates the loading circle.
//   Widget workoutLoading() {
//     List<Widget> children;
//     children = const <Widget>[
//       SizedBox(
//         width: 60,
//         height: 60,
//         child: CircularProgressIndicator(),
//       ),
//       Padding(
//         padding: EdgeInsets.only(top: 16),
//         child: Text('Awaiting result...'),
//       ),
//     ];
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: children,
//       ),
//     );
//   }
//   // ---

//   @override
//   Widget build(BuildContext context) {
//     workouts = DatabaseManager().lists(DatabaseManager().initDB());
//     return Scaffold(
//       /// Pushes to [CreateWorkout()]
//       floatingActionButton: FloatingActionButton(
//         onPressed: pushSelectTimerPage,
//         tooltip: 'Create workout',
//         child: const Icon(Icons.add),
//       ),
//       // ---

//       body: SafeArea(
//         child: FutureBuilder<List<Workout>>(
//           future: workouts,
//           builder:
//               (BuildContext context, AsyncSnapshot<List<Workout>> snapshot) {
//             /// When [workouts] has successfully loaded.
//             if (snapshot.hasData) {
//               if (snapshot.data!.isEmpty) {
//                 return workoutEmpty();
//               } else {
//                 items = snapshot.data!;
//                 return workoutListView(items);
//               }
//             }

//             /// When there was an error loading [workouts].
//             else if (snapshot.hasError) {
//               return workoutFetchError(snapshot);
//             }

//             /// While still waiting to load [workouts].
//             else {
//               return workoutLoading();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
