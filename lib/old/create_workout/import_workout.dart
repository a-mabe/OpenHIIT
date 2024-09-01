import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/database/database_manager.dart';
import 'package:openhiit/old/helper_widgets/file_error.dart';
import 'package:openhiit/old/helper_widgets/loader.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';
import '../helper_widgets/copy_or_skip.dart';
import '../../main.dart';
import '../workout_data_type/workout_type.dart';
import 'package:file_picker/file_picker.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

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
    /// Update the database with the workout. If this is a brand new workout,
    /// make its index the first in the list of workouts and push down the
    /// rest of the workouts. This ensures the new workout appears at the top
    /// of the list of workouts on the home page. If this is an existing workout
    /// that was edited, keep its index where it is.
    ///
    Future<bool> importWorkoutUpdateDatabase(
        Database database, Workout workoutArgument) async {
      /// Grab the list of existing workouts so we can bump down the
      /// index of each in order to make room for this new workout to be at
      /// the top of the list.
      ///

      logger.i(
          "Adding imported workout to database: ${workoutArgument.toString()}");

      List<Workout> workouts =
          await DatabaseManager().workouts(await DatabaseManager().initDB());

      logger.i("Grabbed existing workouts: ${workouts.length}");

      // Insert the new workout into the top (beginning) of the list
      workouts.insert(0, workoutArgument);

      // Increase the index of all old workouts by 1.
      for (var i = 0; i < workouts.length; i++) {
        if (i == 0) {
          workouts[i].workoutIndex = 0;
          await DatabaseManager().insertWorkout(workouts[i], database);
        } else {
          workouts[i].workoutIndex = workouts[i].workoutIndex + 1;
          await DatabaseManager().updateWorkout(workouts[i], database);
        }
      }

      logger.i("Workout added and index of existing workouts updated.");
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

                              for (Map<String, dynamic> parsedWorkout
                                  in parsedList) {
                                try {
                                  Workout workout =
                                      Workout.fromJson(parsedWorkout);

                                  if (workout.title.isNotEmpty) {
                                    bool importStatus = true;
                                    do {
                                      logger.i(
                                          "Attempting to import ${workout.title}");

                                      try {
                                        Database database =
                                            await DatabaseManager().initDB();

                                        importStatus =
                                            await importWorkoutUpdateDatabase(
                                                database, workout);
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
                                                workout: workout,
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
                                                    'Importing copy of ${workout.title}'),
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
                                        workout.title = "${workout.title}_copy";
                                        workout.id = const Uuid().v1();
                                      }
                                    } while (!importStatus);
                                    logger.i(
                                        "Successfully imported ${workout.title}");
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
              visibile: loading,
            )
          ],
        )));
  }
}
