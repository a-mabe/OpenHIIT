import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openhiit/data/timer_type.dart';
import 'package:openhiit/providers/workout_provider.dart';
import 'package:openhiit/utils/log/log.dart';
import 'package:openhiit/pages/home/home.dart';
import 'package:openhiit/utils/database/database_manager.dart';
import 'package:openhiit/pages/import_workout/widgets/file_error.dart';
import 'package:openhiit/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'widgets/copy_or_skip.dart';
import '../../data/workout_type.dart';
import 'package:file_picker/file_picker.dart';

class ImportWorkout extends StatefulWidget {
  const ImportWorkout({super.key});

  @override
  ImportWorkoutState createState() => ImportWorkoutState();
}

class ImportWorkoutState extends State<ImportWorkout> {
  String errorText = "";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    WorkoutProvider workoutProvider = Provider.of<WorkoutProvider>(context);

    /// Update the database with the workout. If this is a brand new workout,
    /// make its index the first in the list of workouts and push down the
    /// rest of the workouts. This ensures the new workout appears at the top
    /// of the list of workouts on the home page. If this is an existing workout
    /// that was edited, keep its index where it is.
    ///
    Future<bool> importWorkoutUpdateDatabase(
        TimerType timer, WorkoutProvider workoutProvider) async {
      logger.i("Adding imported timer to database: ${timer.toString()}");
      timer.timerIndex = 0;

      await workoutProvider
          .addIntervals(workoutProvider.generateIntervalsFromSettings(timer));
      await workoutProvider.addTimer(timer);

      logger.d("Imported timer: $timer");
      logger.d("All timers: ${workoutProvider.timers}");
      return true;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Import Workout"),
        ),
        body: Center(
            child: Stack(
          children: [
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 120,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                      ),
                      onPressed: () async {
                        // User picks file(s) for import.
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(allowMultiple: true, type: FileType.any);

                        // If grabbing file(s) successful...
                        if (result != null) {
                          // Show loader.
                          setState(() {
                            loading = true;
                          });

                          // Get files.
                          List<File> files =
                              result.paths.map((path) => File(path!)).toList();

                          for (File file in files) {
                            String contents = "";

                            try {
                              contents = await File(file.path).readAsString();
                            } on Exception catch (e) {
                              logger.e("Error reading file: $e");

                              if (context.mounted) {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorMessageAlert(
                                      title: "Error reading file",
                                      message:
                                          "${file.path.split("/").last} invalid format, skipping import.",
                                    );
                                  },
                                );
                              }
                              break;
                            }

                            logger.i("Grabbed file with contents: $contents");

                            logger.i("Parsing file contents and saving timer.");

                            try {
                              if (contents.characters.first != "[") {
                                throw Exception("Invalid JSON list.");
                              }

                              final List<dynamic> parsedList =
                                  await jsonDecode(contents);

                              logger.d("Parsed list: $parsedList");

                              for (Map<String, dynamic> parsedTimer
                                  in parsedList) {
                                try {
                                  logger.d("Creating object from json");

                                  TimerType timer =
                                      TimerType.fromJson(parsedTimer);

                                  logger.d("Parsed timer: $timer");

                                  logger.d("settings: ${timer.timeSettings}");

                                  if (timer.name.isNotEmpty) {
                                    bool importStatus = true;
                                    do {
                                      logger.i(
                                          "Attempting to import ${timer.name}");

                                      try {
                                        importStatus =
                                            await importWorkoutUpdateDatabase(
                                                timer, workoutProvider);
                                      } on Exception catch (e) {
                                        logger.e(
                                            "Database conflict on import: $e");
                                        logger.i(
                                            "Prompting user to import copy or skip.");

                                        if (context.mounted) {
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CopyOrSkipDialog(
                                                timer: timer,
                                                onSkip: () {
                                                  Navigator.of(context).pop();
                                                },
                                                onImportCopy: () {
                                                  importStatus = false;
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                          );
                                          if (!importStatus &&
                                              context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Importing copy of ${timer.name}'),
                                                behavior:
                                                    SnackBarBehavior.fixed,
                                                duration:
                                                    const Duration(seconds: 3),
                                                showCloseIcon: true,
                                              ),
                                            );
                                          }
                                        }
                                      }

                                      if (!importStatus) {
                                        timer.name = "${timer.name}_copy";
                                        timer.id = const Uuid().v1();
                                        timer.timeSettings.id =
                                            const Uuid().v1();
                                        timer.timeSettings.timerId = timer.id;
                                        timer.soundSettings.id =
                                            const Uuid().v1();
                                        timer.soundSettings.timerId = timer.id;
                                      }
                                    } while (!importStatus);
                                    logger.i(
                                        "Successfully imported ${timer.name}");
                                  } else {
                                    // User canceled the file picker
                                  }
                                } catch (e) {
                                  logger.e(
                                      "The provided file does not contain a valid workout configuration: $e");

                                  if (context.mounted) {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ErrorMessageAlert(
                                          title:
                                              "Error reading ${file.path.split('/').last}",
                                          message:
                                              "File contains invalid timer configuration, skipping import.",
                                        );
                                      },
                                    );
                                  }
                                }
                              }
                            } on Exception catch (e) {
                              logger.e(
                                  "The provided file does not contain valid exported timer JSON: $e");

                              if (context.mounted) {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorMessageAlert(
                                      title:
                                          "Error reading ${file.path.split('/').last}",
                                      message:
                                          "File contains invalid exported timer format, skipping import.",
                                    );
                                  },
                                );
                              }
                            }
                          }

                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MyHomePage()),
                                (route) => false);
                          }
                        }
                      },
                      child: const Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Icon(
                            Icons.file_open,
                            size: 30,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Browse files",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Select .json files to import",
                  style: TextStyle(fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                  child: Text(
                    errorText,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ],
            )),
            LoaderTransparent(
              loadingMessage: "Importing selected file(s)",
              visible: loading,
            )
          ],
        )));
  }
}
