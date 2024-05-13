import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:openhiit/workout_data_type/workout_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

      final result =
          await Share.shareXFiles([XFile(file.path)], text: 'Export');

      if (result.status == ShareResultStatus.success) {
        print('Thank you for sharing the picture!');
      }

      return 1;
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
}
