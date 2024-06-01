import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/create_workout/constants/snackbars.dart';
import 'package:openhiit/database/database_manager.dart';
import 'package:openhiit/helper_widgets/loader.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../main.dart';
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
    Future updateDatabase(Database database, Workout workoutArgument) async {
      /// Grab the list of existing workouts so we can bump down the
      /// index of each in order to make room for this new workout to be at
      /// the top of the list.
      ///

      logger.i(
          "Adding imported workout to database: ${workoutArgument.toString()}");

      List<Workout> workouts =
          await DatabaseManager().lists(DatabaseManager().initDB());

      logger.i("Grabbed existing workouts: ${workouts.length}");

      // Insert the new workout into the top (beginning) of the list
      workouts.insert(0, workoutArgument);

      // Increase the index of all old workouts by 1.
      for (var i = 0; i < workouts.length; i++) {
        if (i == 0) {
          workouts[i].workoutIndex = 0;
          await DatabaseManager().insertList(workouts[i], database);
        } else {
          workouts[i].workoutIndex = workouts[i].workoutIndex + 1;
          await DatabaseManager().updateList(workouts[i], database);
        }
      }

      logger.i("Workout added and index of existing workouts updated.");
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
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                                allowMultiple: true,
                                type: FileType.custom,
                                allowedExtensions: ['json']);

                        if (result != null) {
                          loading = true;

                          List<File> files =
                              result.paths.map((path) => File(path!)).toList();

                          for (File file in files) {
                            String contents =
                                await File(file.path).readAsString();

                            logger.i("Grabbed file with contents: $contents");

                            logger.i("Parsing file contents and saving timer.");

                            Workout workout = Workout.empty();

                            /// Attempt to parse the file contents, catch the error if
                            /// the file contains invalid JSON.
                            try {
                              final Map<String, dynamic> parsed =
                                  await jsonDecode(contents);

                              /// Attempt to create the Workout object from the parsed
                              /// JSON if the JSON was valid.
                              try {
                                workout = Workout.fromJson(parsed);
                              } catch (e) {
                                // Invalid workout config.
                                if (context.mounted) {
                                  if (files.length < 2) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(invalidConfigSnackBar);
                                    setState(() {
                                      errorText =
                                          'Selected file contains invalid workout configuration, please select another file.';
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        invalidConfigMultipleSnackBar);
                                    setState(() {
                                      errorText =
                                          'Import incomplete, a file contains invalid configuration.';
                                    });
                                  }
                                }
                              }
                            } on FormatException catch (e) {
                              // Invalid JSON.
                              logger.e(
                                  "The provided file does not contain valid JSON: $e");
                              if (context.mounted) {
                                if (files.length < 2) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(invalidJsonSnackBar);
                                  setState(() {
                                    errorText =
                                        'Selected file contains invalid JSON, please select another file.';
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      invalidJsonMultipleSnackBar);
                                  setState(() {
                                    errorText =
                                        'Import incomplete, ${file.path} contains invalid JSON.';
                                  });
                                }
                              }
                            }

                            /// If the Workout object was successfully created from the
                            /// parsed JSON, save it to the DB.
                            if (workout.title.isNotEmpty) {
                              try {
                                Database database =
                                    await DatabaseManager().initDB();

                                await updateDatabase(database, workout)
                                    .then((value) {
                                  logger.i(
                                      "Successfully imported ${workout.title}");
                                });
                              } on Exception catch (e) {
                                logger.e(
                                    "Encountered error while importing file: $e");
                              }
                            } else {
                              // User canceled the file picker
                            }
                          }

                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(successfulImportSnackBar);

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
