import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/log/log.dart';
import 'package:openhiit/old/workout_data_type/workout_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LocalFileUtil {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  /// Returns the local file path for the given list of [workouts].
  /// - [workouts]: The list of workouts to export.
  ///
  Future<File> localFilePath(List<Workout> workouts) async {
    String fileTitle = "";
    if (workouts.length == 1) {
      fileTitle = "exported_openhiit_timer_${workouts[0].title}.json";
    } else {
      fileTitle = "exported_openhiit_timers.json";
    }

    final path = await _localPath;
    return File('$path/$fileTitle');
  }

  Future<File> writeFile(List<Workout> workouts) async {
    final file = await localFilePath(workouts);

    // Write the file
    return file.writeAsString(jsonEncode(workouts));
  }

  /// Shares the local file of the given [workout] using the Share plugin.
  ///
  /// The [workout] parameter represents the workout to be shared.
  ///
  /// Returns an integer value indicating the success of the file sharing operation.
  /// If the file sharing is successful, it returns 1. If an error occurs, it returns 0.
  ///
  Future<ShareResult?> shareFile(
      List<Workout> workouts, BuildContext context) async {
    try {
      final file = await localFilePath(workouts);

      if (context.mounted) {
        final box = context.findRenderObject() as RenderBox?;

        ShareResult result = await Share.shareXFiles([XFile(file.path)],
            text: 'OpenHIIT Export',
            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

        return result;
      }

      return null;
    } catch (e) {
      // If encountering an error, return null
      return null;
    }
  }

  /// Shares the local file of the given [workout] using the Share plugin.
  /// This method is used to share multiple files.
  /// - [workout] Represents the workout to be shared.
  /// Returns an integer value indicating the success of the file sharing operation.
  ///
  Future<ShareResult?> shareMultipleFiles(
      List<Workout> workouts, BuildContext context) async {
    try {
      List<XFile> files = [];

      files.add(XFile((await localFilePath(workouts)).path));

      if (context.mounted) {
        final box = context.findRenderObject() as RenderBox?;

        ShareResult result = await Share.shareXFiles(files,
            text: 'Export',
            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
        return result;
      }

      return null;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  /// Saves the file to the device.
  /// - [workoutsToExport] The list of workouts to export.
  ///
  Future<bool> saveFileToDevice(List<Workout> workoutsToExport) async {
    String fileTitle = "";
    if (workoutsToExport.length == 1) {
      fileTitle = "exported_openhiit_timer_${workoutsToExport[0].title}.json";
    } else {
      fileTitle = "exported_openhiit_timers.json";
    }

    try {
      String? outputFile = await FilePicker.platform.saveFile(
        fileName: fileTitle,
        allowedExtensions: ["json", "txt"],
        type: FileType.custom,
        bytes: utf8.encode(jsonEncode(workoutsToExport)),
      );

      if (outputFile == null) {
        return false;
      }

      if (Platform.isIOS) {
        File(outputFile)
            .writeAsBytes(utf8.encode(jsonEncode(workoutsToExport)));
      }

      return true;
    } on Exception catch (e) {
      logger.e("Error saving file to device: $e");
      return false;
    }
  }
}
