import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/workout_data_type/workout_type.dart';
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

  Future<File> localFilePath(Workout workout) async {
    final path = await _localPath;
    return File('$path/openhiit_timer_${workout.id}.json');
  }

  Future<File> writeFile(Workout workout) async {
    final file = await localFilePath(workout);

    // Write the file
    return file.writeAsString(jsonEncode(workout));
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

  Future<int> shareFile(Workout workout) async {
    try {
      final file = await localFilePath(workout);

      await Share.shareXFiles([XFile(file.path)], text: 'Export');

      return 1;
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<bool> saveFileToDevice(Workout workout) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: "Select folder to save exported file",
        fileName: "openhiit_timer_${workout.id}.json",
        allowedExtensions: ["json"],
        type: FileType.custom,
        bytes: utf8.encode(jsonEncode(workout)),
      );

      if (Platform.isIOS) {
        File(outputFile!).writeAsBytes(utf8.encode(jsonEncode(workout)));
      }
    } on Exception catch (e) {
      logger.e("Error saving file to device: $e");
    }

    return false;
  }
}
