import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:openhiit/constants/snackbars.dart';
import 'package:openhiit/data/timer_type.dart';
import 'package:openhiit/pages/select_timer/select_timer.dart';
import 'package:openhiit/pages/view_workout/view_timer.dart';
import 'package:openhiit/pages/home/widgets/fab_column.dart';
import 'package:openhiit/providers/workout_provider.dart';
import 'package:openhiit/utils/database/database_manager.dart';
import 'package:openhiit/utils/functions.dart';
import 'package:openhiit/utils/import_export/local_file_util.dart';
import 'package:openhiit/widgets/home/export_bottom_sheet.dart';
import 'package:openhiit/widgets/home/timer_list_tile.dart';
import 'package:openhiit/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// Global flag to indicate if exporting is in progress
bool exporting = false;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TimerType> reorderableWorkoutList = [];
  late WorkoutProvider workoutProvider;

  @override
  void initState() {
    super.initState();
    workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
  }

  void _onReorder(int oldIndex, int newIndex) async {
    // Ensure newIndex does not exceed the length of the list.
    if (newIndex > reorderableWorkoutList.length) {
      newIndex = reorderableWorkoutList.length;
    }

    // Adjust newIndex if oldIndex is less than newIndex.
    if (oldIndex < newIndex) newIndex -= 1;

    // Extract the Workout item being reordered.
    final TimerType item = reorderableWorkoutList[oldIndex];
    // Remove the item from its old position.
    reorderableWorkoutList.removeAt(oldIndex);

    // Update the workoutIndex of the item to the new position.
    item.timerIndex = newIndex;
    // Insert the item at the new position.
    reorderableWorkoutList.insert(newIndex, item);

    // Update the workoutIndex for all items in the list.
    setState(() {
      for (var i = 0; i < reorderableWorkoutList.length; i++) {
        reorderableWorkoutList[i].timerIndex = i;
      }
    });

    DatabaseManager().updateTimers(reorderableWorkoutList);
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
        for (final timer in snapshot.data)
          TimerListTile(
            key: Key('${timer.timerIndex}'), // Unique key for each list item.
            timer: timer,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewTimer(
                    timer: timer,
                  ),
                ),
              );
            },
            index: timer.timerIndex,
          ),
      ],
    );
  }

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
        child: Text('Fetching timers...'),
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
    );
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

    LocalFileUtil fileUtil = LocalFileUtil();
    bool result = await fileUtil.saveFileToDevice(workoutProvider.timers);

    if (result) {
      setState(() {
        logger.i("Exporting complete.");
        exporting = false;
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(createSuccessSnackBar("Saved to device!"));
      }
    } else {
      setState(() {
        logger.e("Export not completed.");
        exporting = false;
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(createErrorSnackBar("Save not completed"));
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
    // List<Workout> loadedWorkouts = workoutProvider.workouts;

    LocalFileUtil fileUtil = LocalFileUtil();

    await fileUtil.writeFile(workoutProvider.timers);

    if (buildContext.mounted) {
      ShareResult? result = await fileUtil.shareMultipleFiles(
          workoutProvider.timers, buildContext);

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
                .showSnackBar(createErrorSnackBar("Share not completed"));
          }
        } else {
          setState(() {
            logger.i("Export and share complete.");
            exporting = false;
          });

          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(createSuccessSnackBar("Shared successfully!"));
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
          timer: null,
          save: saveWorkouts,
          share: () => shareWorkouts(context),
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    setStatusBarBrightness(context);

    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 30,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("About OpenHIIT"),
                              content: const Text(
                                  "OpenHIIT is a free and open-source interval timer."),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    final Uri url = Uri.parse(
                                        'https://a-mabe.github.io/OpenHIIT/');
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  child: const Text("View privacy policy"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Close"),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),

              /// Pushes to [SelectTimer()]
              floatingActionButton: Visibility(
                visible: !exporting,
                child: FABColumn(bulk: bulkExport, create: pushSelectTimerPage),
              ),
              body: Stack(children: [
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        child: FutureBuilder(
                            future: workoutProvider.loadWorkoutData(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.isEmpty) {
                                  return workoutEmpty();
                                } else {
                                  reorderableWorkoutList = snapshot.data;
                                  reorderableWorkoutList.sort((a, b) =>
                                      a.timerIndex.compareTo(b.timerIndex));
                                  return workoutListView(snapshot);
                                }
                              } else if (snapshot.hasError) {
                                return workoutFetchError(snapshot);
                              } else {
                                return workoutLoading();
                              }
                            }))),
                LoaderTransparent(
                  loadingMessage: "Exporting file(s)",
                  visible: exporting,
                )
              ])),
        ));
  }
  // ---
}
