import 'package:flutter/material.dart';
import 'package:openhiit/database/database_manager.dart';
import 'package:openhiit/log/log.dart';
import 'package:openhiit/old/constants/snackbars.dart';
import 'package:openhiit/old/create_workout/select_timer.dart';
import 'package:openhiit/old/helper_widgets/export_bottom_sheet.dart';
import 'package:openhiit/old/helper_widgets/fab_column.dart';
import 'package:openhiit/pages/view_workout/view_workout.dart';
import 'package:openhiit/pages/home/widgets/reorderable_workout_grid_view.dart';
import 'package:openhiit/utils/local_file_util.dart';
import 'package:openhiit/old/workout_data_type/workout_type.dart';
import 'package:openhiit/pages/home/widgets/workout_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

// Global flag to indicate if exporting is in progress
bool exporting = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenHIIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(), // standard dark theme
      themeMode: ThemeMode.system, // use system theme
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
  /// workout indices will be saved to the database.
  ///
  List<Workout> reorderableWorkoutList = [];

  /// The initial list of workouts to be loaded fresh
  /// from the DB.
  ///
  late Future<List<Workout>> workouts;

  /// The database instance.
  ///
  late Database database;

  /// Load the workouts from the database.
  ///
  Future<List<Workout>> loadWorkouts() async {
    try {
      database = await DatabaseManager().initDB();
      return DatabaseManager().workouts(database);
    } catch (e) {
      logger.e("Failed to load workouts: $e");
      rethrow;
    }
  }

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
        workouts = DatabaseManager().workouts(database);
      });
    });
  }
  // ---

  /// Saves the workouts to the device.
  ///
  /// This function exports the workouts to the device by saving them to a file.
  /// It sets the [exporting] flag to true to indicate that the export is in progress.
  /// It then retrieves the loaded workouts using the [workouts] variable.
  /// The workouts are saved to the device using the [LocalFileUtil] class.
  /// After the export is complete, the [exporting] flag is set to false.
  /// If the context is still mounted, a snackbar is shown to indicate that the workouts have been exported.
  /// Finally, the function logs the completion of the export.
  void saveWorkouts() async {
    // Export workouts to device
    logger.i("Exporting workouts to device...");

    setState(() {
      exporting = true;
    });

    List<Workout> loadedWorkouts = await workouts;

    LocalFileUtil fileUtil = LocalFileUtil();

    bool result = await fileUtil.saveFileToDevice(loadedWorkouts);

    if (result) {
      setState(() {
        logger.i("Exporting complete.");
        exporting = false;
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(successfulSaveMultipleToDeviceSnackBar);
      }
    } else {
      setState(() {
        logger.e("Export not completed.");
        exporting = false;
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(errorSaveMultipleSnackBar);
      }
    }
  }

  /// Exports and shares the workouts.
  ///
  /// This function exports the workouts and shares them with other applications.
  /// It sets the [exporting] flag to true to indicate that the export process is in progress.
  /// It uses the [LocalFileUtil] class to write each workout to a file.
  /// After exporting and sharing the workouts, it sets the [exporting] flag to false.
  /// It also shows a success message using a snackbar.
  void shareWorkouts(BuildContext buildContext) async {
    // Export and share workouts
    logger.i("Exporting and sharing workouts...");
    setState(() {
      exporting = true;
    });
    List<Workout> loadedWorkouts = await workouts;

    LocalFileUtil fileUtil = LocalFileUtil();

    try {
      await fileUtil.writeFile(loadedWorkouts);
    } catch (e) {
      logger.e("Failed to write file: $e");
      rethrow;
    }

    if (buildContext.mounted) {
      ShareResult? result =
          await fileUtil.shareMultipleFiles(loadedWorkouts, buildContext);

      if (result != null) {
        if (result.status == ShareResultStatus.dismissed ||
            result.status == ShareResultStatus.unavailable) {
          setState(() {
            logger.e("Share not completed.");
            exporting = false;
          });

          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(errorShareMultipleSnackBar);
          }
        } else {
          setState(() {
            logger.i("Export and share complete.");
            exporting = false;
          });

          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(successfulShareMultipleSnackBar);
          }
        }
      }
    }
  }

  /// Function to handle bulk export of workouts.
  /// This function displays a modal bottom sheet and provides options to save or share workouts.
  /// When the save option is selected, the function exports the workouts to the device.
  /// When the share option is selected, the function exports the workouts to the device and then shares them.
  void bulkExport() async {
    // Display modal bottom sheet
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      context: context,
      builder: (BuildContext context) {
        return ExportBottomSheet(
          workout: null,
          save: saveWorkouts,
          share: () => shareWorkouts(context),
        );
      },
    );
  }
  // ---

  /// Method called when a workout is tapped. Opens up the view workout page
  /// for that workout.
  /// - [tappedWorkout]: The workout that was tapped.
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
        workouts = DatabaseManager().workouts(database);
      });
    });
  }
  // ---

  /// Generates the loading circle, displayed as workouts are being loaded from the DB.
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

  /// Initialize...
  /// - Load workouts from the database.
  ///
  @override
  void initState() {
    super.initState();
    workouts = loadWorkouts();
  }
  // ---

  @override
  Widget build(BuildContext context) {
    /// Build the item for the ReorderableGridView.
    /// - [text] The text to display in the item.
    /// - Returns a Card widget with the given text.
    ///
    Widget buildItem(Workout workout) {
      return WorkoutCard(
        key: ValueKey(workout.id),
        workout: workout,
        onWorkoutTap: onWorkoutTap,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
            child: FutureBuilder<List<Workout>>(
          future: workouts,
          builder:
              (BuildContext context, AsyncSnapshot<List<Workout>> snapshot) {
            /// Data has loaded successfully.
            if (snapshot.hasData) {
              /// Encountered an error loading the data.
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                if (snapshot.data!.isEmpty) {
                  return workoutEmpty();
                }

                reorderableWorkoutList = snapshot.data!;

                reorderableWorkoutList
                    .sort((a, b) => a.workoutIndex.compareTo(b.workoutIndex));

                return ReorderableWorkoutGridView(
                  onReorder: (oldIndex, newIndex) async {
                    logger.d(
                        "Old Index: $oldIndex, New Index: $newIndex, Length: ${reorderableWorkoutList.length}");

                    // Ensure newIndex does not exceed the length of the list.
                    if (newIndex > reorderableWorkoutList.length) {
                      newIndex = reorderableWorkoutList.length;
                    }

                    final Workout item = reorderableWorkoutList[oldIndex];

                    reorderableWorkoutList.removeAt(oldIndex);

                    item.workoutIndex = newIndex;

                    reorderableWorkoutList.insert(newIndex, item);

                    // Update the workoutIndex for all items in the list.
                    setState(() {
                      for (var i = 0; i < reorderableWorkoutList.length; i++) {
                        reorderableWorkoutList[i].workoutIndex = i;
                      }
                    });

                    // Initialize the database and update the workout order in the database.
                    for (var i = 0; i < reorderableWorkoutList.length; i++) {
                      await DatabaseManager()
                          .updateWorkout(reorderableWorkoutList[i], database);
                    }
                  },
                  workouts: reorderableWorkoutList
                      .map((Workout e) => buildItem(e))
                      .toList(),
                );
              }
            } else {
              /// While still waiting to load [workouts].
              return workoutLoading();
            }
          },
        )),
      ),
      floatingActionButton: Visibility(
        visible: !exporting,
        child: FABColumn(bulk: bulkExport, create: pushSelectTimerPage),
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:logger/logger.dart';
// import 'package:openhiit/old/helper_widgets/fab_column.dart';
// import 'package:openhiit/old/import_export/local_file_util.dart';
// import 'package:openhiit/old/utils/functions.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:sqflite/sqflite.dart';
// import 'old/constants/snackbars.dart';
// import 'old/create_workout/select_timer.dart';
// import 'old/helper_widgets/export_bottom_sheet.dart';
// import 'old/helper_widgets/loader.dart';
// import 'old/workout_data_type/workout_type.dart';
// import 'database/database_manager.dart';
// import 'old/start_workout/view_workout.dart';
// import 'old/helper_widgets/timer_list_tile.dart';

// // Global logger instance for logging messages
// var logger = Logger(
//   printer: PrettyPrinter(methodCount: 0),
// );

// // Global flag to indicate if exporting is in progress
// bool exporting = false;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (Platform.isAndroid) {
//     await Permission.scheduleExactAlarm.isDenied.then((value) {
//       if (value) {
//         Permission.scheduleExactAlarm.request();
//       }
//     });
//   }

//   GoogleFonts.config.allowRuntimeFetching = false;

//   /// Monospaced font licensing.
//   ///
//   LicenseRegistry.addLicense(() async* {
//     final license = await rootBundle.loadString('google_fonts/OFL.txt');
//     yield LicenseEntryWithLineBreaks(['google_fonts'], license);
//   });

//   runApp(const WorkoutTimer());
// }

// class WorkoutTimer extends StatelessWidget {
//   const WorkoutTimer({super.key});

//   /// Application root.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OpenHIIT',
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
//   /// List of workouts for reordering. The newly reordered
//   /// workout indeices with be saved to the DB.
//   ///
//   List<Workout> reorderableWorkoutList = [];

//   /// The initial list of workouts to be loaded fresh
//   /// from the DB.
//   ///
//   late Future<List<Workout>> workouts;

//   /// Initialize...
//   @override
//   void initState() {
//     super.initState();
//     workouts = DatabaseManager().workouts(DatabaseManager().initDB());
//   }
//   // ---

//   /// Callback function for handling the reordering of items in the list.
//   ///
//   /// Parameters:
//   ///   - [oldIndex]: The index of the item before reordering.
//   ///   - [newIndex]: The index where the item is moved to after reordering.
//   ///
//   void _onReorder(int oldIndex, int newIndex) async {
//     // Ensure newIndex does not exceed the length of the list.
//     if (newIndex > reorderableWorkoutList.length) {
//       newIndex = reorderableWorkoutList.length;
//     }

//     // Adjust newIndex if oldIndex is less than newIndex.
//     if (oldIndex < newIndex) newIndex -= 1;

//     // Extract the Workout item being reordered.
//     final Workout item = reorderableWorkoutList[oldIndex];
//     // Remove the item from its old position.
//     reorderableWorkoutList.removeAt(oldIndex);

//     // Update the workoutIndex of the item to the new position.
//     item.workoutIndex = newIndex;
//     // Insert the item at the new position.
//     reorderableWorkoutList.insert(newIndex, item);

//     // Update the workoutIndex for all items in the list.
//     setState(() {
//       for (var i = 0; i < reorderableWorkoutList.length; i++) {
//         reorderableWorkoutList[i].workoutIndex = i;
//       }
//     });

//     // Initialize the database and update the workout order in the database.
//     Database database = await DatabaseManager().initDB();

//     for (var i = 0; i < reorderableWorkoutList.length; i++) {
//       // Update the workout order in the database.
//       await DatabaseManager()
//           .updateWorkout(reorderableWorkoutList[i], database);
//     }
//   }
//   // ---

//   /// Method called when a workout is tapped. Opens up the view workout page
//   /// for that workout.
//   ///
//   void onWorkoutTap(Workout tappedWorkout) {
//     /// Push the ViewWorkout page.
//     ///
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const ViewWorkout(),

//         /// Pass the [tappedWorkout] as an argument to
//         /// the ViewWorkout page.
//         settings: RouteSettings(
//           arguments: tappedWorkout,
//         ),
//       ),
//     ).then((value) {
//       /// When we come back to the hompage, refresh the
//       /// list of workouts by reloading from the DB.
//       ///
//       setState(() {
//         workouts = DatabaseManager().workouts(DatabaseManager().initDB());
//       });
//     });
//   }
//   // ---

//   /// Widget for displaying a ReorderableListView of workout items.
//   ///
//   /// Parameters:
//   ///   - [snapshot]: The data snapshot from the database containing workout information.
//   Widget workoutListView(snapshot) {
//     return ReorderableListView(
//       onReorder: _onReorder, // Callback for handling item reordering.
//       proxyDecorator: proxyDecorator, // Decorator for the dragged item.
//       children: [
//         /// For each workout in the returned DB data snapshot.
//         ///
//         for (final workout in snapshot.data)
//           TimerListTile(
//             key: Key(
//                 '${workout.workoutIndex}'), // Unique key for each list item.
//             workout: workout,
//             onTap: () {
//               onWorkoutTap(workout);
//             },
//             index: workout.workoutIndex,
//           ),
//       ],
//     );
//   }
//   // ---

//   /// Generates the empty message for no [workouts] in DB.
//   ///
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
//   ///
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

//   /// Generates the loading circle, display as workouts
//   /// are being loaded from the DB.
//   ///
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

//   /// Load the page for the user to select whether they'd like
//   /// to create a new interval timer or workout.
//   ///
//   void pushSelectTimerPage() async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const SelectTimer()),
//     ).then((value) {
//       /// When we come back to the hompage, refresh the
//       /// list of workouts by reloading from the DB.
//       ///
//       setState(() {
//         workouts = DatabaseManager().workouts(DatabaseManager().initDB());
//       });
//     });
//   }
//   // ---

//   /// Saves the workouts to the device.
//   ///
//   /// This function exports the workouts to the device by saving them to a file.
//   /// It sets the [exporting] flag to true to indicate that the export is in progress.
//   /// It then retrieves the loaded workouts using the [workouts] variable.
//   /// The workouts are saved to the device using the [LocalFileUtil] class.
//   /// After the export is complete, the [exporting] flag is set to false.
//   /// If the context is still mounted, a snackbar is shown to indicate that the workouts have been exported.
//   /// Finally, the function logs the completion of the export.
//   void saveWorkouts() async {
//     // Export workouts to device
//     logger.i("Exporting workouts to device...");

//     setState(() {
//       exporting = true;
//     });

//     List<Workout> loadedWorkouts = await workouts;

//     LocalFileUtil fileUtil = LocalFileUtil();

//     bool result = await fileUtil.saveFileToDevice(loadedWorkouts);

//     if (result) {
//       setState(() {
//         logger.i("Exporting complete.");
//         exporting = false;
//       });

//       if (mounted) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context)
//             .showSnackBar(successfulSaveMultipleToDeviceSnackBar);
//       }
//     } else {
//       setState(() {
//         logger.e("Export not completed.");
//         exporting = false;
//       });

//       if (mounted) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(errorSaveMultipleSnackBar);
//       }
//     }
//   }

//   /// Exports and shares the workouts.
//   ///
//   /// This function exports the workouts and shares them with other applications.
//   /// It sets the [exporting] flag to true to indicate that the export process is in progress.
//   /// It uses the [LocalFileUtil] class to write each workout to a file.
//   /// After exporting and sharing the workouts, it sets the [exporting] flag to false.
//   /// It also shows a success message using a snackbar.
//   void shareWorkouts(BuildContext buildContext) async {
//     // Export and share workouts
//     logger.i("Exporting and sharing workouts...");
//     setState(() {
//       exporting = true;
//     });
//     List<Workout> loadedWorkouts = await workouts;

//     LocalFileUtil fileUtil = LocalFileUtil();

//     await fileUtil.writeFile(loadedWorkouts);

//     if (buildContext.mounted) {
//       ShareResult? result =
//           await fileUtil.shareMultipleFiles(loadedWorkouts, buildContext);

//       if (result != null) {
//         if (result.status == ShareResultStatus.dismissed ||
//             result.status == ShareResultStatus.unavailable) {
//           setState(() {
//             logger.e("Share not completed.");
//             exporting = false;
//           });

//           if (mounted) {
//             Navigator.pop(context);
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(errorShareMultipleSnackBar);
//           }
//         } else {
//           setState(() {
//             logger.i("Export and share complete.");
//             exporting = false;
//           });

//           if (mounted) {
//             Navigator.pop(context);
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(successfulShareMultipleSnackBar);
//           }
//         }
//       }
//     }
//   }

//   /// Function to handle bulk export of workouts.
//   /// This function displays a modal bottom sheet and provides options to save or share workouts.
//   /// When the save option is selected, the function exports the workouts to the device.
//   /// When the share option is selected, the function exports the workouts to the device and then shares them.
//   void bulkExport() async {
//     // Display modal bottom sheet
//     showModalBottomSheet<void>(
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//       context: context,
//       builder: (BuildContext context) {
//         return ExportBottomSheet(
//           workout: null,
//           save: saveWorkouts,
//           share: () => shareWorkouts(context),
//         );
//       },
//     );
//   }
//   // ---

//   /// The widget to return for a workout tile as it's being dragged.
//   /// This AnimatedBuilder will slightly increase the elevation of the dragged
//   /// workout without changing other UI elements.
//   ///
//   Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
//     return AnimatedBuilder(
//       animation: animation,
//       builder: (BuildContext context, Widget? child) {
//         final double animValue = Curves.easeInOut.transform(animation.value);
//         final double scale = lerpDouble(1, 1.02, animValue)!;
//         return Transform.scale(
//             scale: scale,
//             // Create a Card based on the color and the content of the dragged one
//             // and set its elevation to the animated value.
//             child: child);
//       },
//       child: child,
//     );
//   }
//   // ---

//   /// Build the home screen UI.
//   ///
//   @override
//   Widget build(BuildContext context) {
//     setStatusBarBrightness(context);

//     return Container(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         child: SafeArea(
//           child: Scaffold(

//               /// Pushes to [SelectTimer()]
//               floatingActionButton: Visibility(
//                 visible: !exporting,
//                 child: FABColumn(bulk: bulkExport, create: pushSelectTimerPage),
//               ),
//               body: Stack(children: [
//                 Container(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                         child: FutureBuilder(
//                             future: workouts,
//                             builder:
//                                 (BuildContext context, AsyncSnapshot snapshot) {
//                               /// When [workouts] has successfully loaded.
//                               if (snapshot.hasData) {
//                                 if (snapshot.data!.isEmpty) {
//                                   return workoutEmpty();
//                                 } else {
//                                   reorderableWorkoutList = snapshot.data;
//                                   reorderableWorkoutList.sort((a, b) =>
//                                       a.workoutIndex.compareTo(b.workoutIndex));
//                                   return workoutListView(snapshot);
//                                 }
//                               }

//                               /// When there was an error loading [workouts].
//                               else if (snapshot.hasError) {
//                                 return workoutFetchError(snapshot);
//                               }

//                               /// While still waiting to load [workouts].
//                               else {
//                                 return workoutLoading();
//                               }
//                             }))),
//                 LoaderTransparent(
//                   loadingMessage: "Exporting file(s)",
//                   visibile: exporting,
//                 )
//               ])),
//         ));
//   }
//   // ---
// }
