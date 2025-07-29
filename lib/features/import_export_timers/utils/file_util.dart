import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LocalFileUtil {
  final logger = Logger(
    printer: JsonLogPrinter('FileUtil'),
    level: Level.debug,
  );

  /// Returns the app's document directory path.
  Future<String> get _localPath async =>
      (await getApplicationDocumentsDirectory()).path;

  /// Generates a file name based on the number of timers.
  String _fileTitle(List<TimerType> timers) => timers.length == 1
      ? "exported_openhiit_timer_${timers[0].name}.json"
      : "exported_openhiit_timers.json";

  /// Returns the local file for the given timers.
  Future<File> _localFile(List<TimerType> timers) async =>
      File('${await _localPath}/${_fileTitle(timers)}');

  /// Writes the timers to a local file as JSON.
  Future<File> writeFile(List<TimerType> timers) async {
    final file = await _localFile(timers);
    return file.writeAsString(jsonEncode(timers), flush: true);
  }

  /// Reads the content of a file picked from the device.
  Future<String> readFile(PlatformFile platformFile) async {
    final file = File(platformFile.path!);
    return await file.readAsString();
  }

  /// Shares the exported timers file.
  Future<ShareResult?> shareFile(
      List<TimerType> timers, BuildContext context) async {
    final file = await writeFile(timers);
    if (!context.mounted) return null;
    final box = context.findRenderObject() as RenderBox?;
    return await Share.shareXFiles(
      [XFile(file.path)],
      text: 'OpenHIIT Export',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & (box.size),
    );
  }

  // /// Shares multiple exported timer files (currently only one file).
  // Future<ShareResult?> shareMultipleFiles(
  //     List<TimerType> timers, BuildContext context) async {
  //   final file = await _localFile(timers);
  //   if (!context.mounted) return null;
  //   final box = context.findRenderObject() as RenderBox?;
  //   return await Share.shareXFiles(
  //     [XFile(file.path)],
  //     text: 'Export',
  //     sharePositionOrigin: box!.localToGlobal(Offset.zero) & (box.size),
  //   );
  // }

  /// Saves the exported timers file to the device using FilePicker.
  Future<bool> saveFileToDevice(List<TimerType> timers) async {
    final fileTitle = _fileTitle(timers);
    final encoded = utf8.encode(jsonEncode(timers));
    final outputFile = await FilePicker.platform.saveFile(
      fileName: fileTitle,
      allowedExtensions: ["json", "txt"],
      type: FileType.custom,
      bytes: encoded,
    );
    if (outputFile == null) return false;
    if (Platform.isIOS) {
      await File(outputFile).writeAsBytes(encoded);
    }
    return true;
  }

  /// Picks a file from the device and returns the selected PlatformFile, or null if cancelled.
  Future<PlatformFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'txt'],
      withData: false,
    );
    if (result != null && result.files.isNotEmpty) {
      return result.files.first;
    }
    return null;
  }
}
