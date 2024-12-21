import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/data/timer_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class LocalFileUtil {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> localFilePath(List<TimerType> timers) async {
    String fileTitle = "";
    if (timers.length == 1) {
      fileTitle = "exported_openhiit_timer_${timers[0].name}.json";
    } else {
      fileTitle = "exported_openhiit_timers.json";
    }

    final path = await _localPath;
    return File('$path/$fileTitle');
  }

  Future<File> writeFile(List<TimerType> timers) async {
    final file = await localFilePath(timers);

    // Write the file
    return file.writeAsString(jsonEncode(timers));
  }

  Future<String> readFile(PlatformFile platformFile) async {
    try {
      final file = File(platformFile.path!);

      // Read the file
      final contents = await file.readAsString();

      return contents.toString();
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  /// Shares the local file of the given [workout] using the Share plugin.
  ///
  /// The [workout] parameter represents the workout to be shared.
  ///
  /// Returns an integer value indicating the success of the file sharing operation.
  /// If the file sharing is successful, it returns 1. If an error occurs, it returns 0.
  Future<ShareResult?> shareFile(
      List<TimerType> timers, BuildContext context) async {
    try {
      final file = await localFilePath(timers);

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

  Future<ShareResult?> shareMultipleFiles(
      List<TimerType> timers, BuildContext context) async {
    try {
      List<XFile> files = [];

      files.add(XFile((await localFilePath(timers)).path));

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

  Future<bool> saveFileToDevice(List<TimerType> timers) async {
    String fileTitle = "";
    if (timers.length == 1) {
      fileTitle = "exported_openhiit_timer_${timers[0].name}.json";
    } else {
      fileTitle = "exported_openhiit_timers.json";
    }

    try {
      String? outputFile = await FilePicker.platform.saveFile(
        fileName: fileTitle,
        allowedExtensions: ["json", "txt"],
        type: FileType.custom,
        bytes: utf8.encode(jsonEncode(timers)),
      );

      if (outputFile == null) {
        return false;
      }

      if (Platform.isIOS) {
        File(outputFile).writeAsBytes(utf8.encode(jsonEncode(timers)));
      }

      return true;
    } on Exception catch (e) {
      logger.e("Error saving file to device: $e");
    }

    return false;
  }
}
