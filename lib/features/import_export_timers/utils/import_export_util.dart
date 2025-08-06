import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/import_export_timers/ui/import_copy_dialog.dart';
import 'package:openhiit/features/import_export_timers/ui/snackbars.dart';
import 'package:openhiit/features/import_export_timers/utils/file_util.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:openhiit/shared/globals.dart';
import 'package:share_plus/share_plus.dart';

class ImportExportUtil {
  static final Logger logger = Logger(
    printer: JsonLogPrinter('ImportExportUtil'),
    level: Level.info,
  );

  static Future<bool> exportToDevice(List<TimerType> timers) async {
    LocalFileUtil localFileUtil = LocalFileUtil();
    var fileContent = await localFileUtil.saveFileToDevice(timers);
    return fileContent;
  }

  static Future<bool> tryImport(TimerProvider timerProvider) async {
    try {
      List<TimerType> importedTimers =
          await ImportExportUtil.importFromFileToObject(timerProvider);

      if (importedTimers.isEmpty) {
        scaffoldMessengerKey.currentState
            ?.showSnackBar(infoSnackbar('Nothing imported.'));
        return false;
      } else {
        await ImportExportUtil.saveImportedTimers(
            importedTimers, timerProvider);
      }
      return true;
    } catch (e) {
      logger.e("Import failed: $e");
      scaffoldMessengerKey.currentState?.showSnackBar(
        errorSnackbar("Import failed: $e"),
      );
      return false;
    }
  }

  static Future<List<TimerType>> importFromFileToObject(
      TimerProvider timerProvider) async {
    logger.i("Picking file for import...");

    LocalFileUtil localFileUtil = LocalFileUtil();
    PlatformFile? file = await localFileUtil.pickFile();
    if (file != null) {
      String content = await localFileUtil.readFile(file);

      if (!content.startsWith("[")) {
        throw Exception("Invalid JSON list.");
      }

      List<dynamic> jsonList = jsonDecode(content);

      List<TimerType> importedTimers = [];

      for (Map<String, dynamic> item in jsonList) {
        logger.d("Importing timer: ${item['name']}");
        TimerType timer = TimerType.fromJson(item);

        importedTimers.add(timer);
      }
      return importedTimers;
    }
    return [];
  }

  static Future<bool> saveImportedTimers(
    List<TimerType> importedTimers,
    TimerProvider timerProvider,
  ) async {
    logger.i("Saving imported timers...");

    final messenger = scaffoldMessengerKey.currentState;

    int importedCount = 0;

    for (final timer in importedTimers) {
      final exists = timerProvider.timerExists(timer.id);

      if (exists) {
        await showImportDialog(
          timer.name,
          () {
            importedCount++;
            timerProvider.pushTimerCopy(timer);
          },
        );
      } else {
        importedCount++;
        timerProvider.pushTimer(timer);
      }
    }

    // Defer snackbar until after frame build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      messenger?.showSnackBar(
        importedCount > 0
            ? successSnackbar('Successfully imported $importedCount timers.')
            : infoSnackbar('Nothing imported.'),
      );
    });
    return true;
  }

  static Future<bool> share(List<TimerType> timers) async {
    logger.i("Sharing timers...");
    LocalFileUtil fileUtil = LocalFileUtil();
    ShareResult? result;
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      result = await fileUtil.shareFile(timers, context);
    }
    return result != null && result.status == ShareResultStatus.success;
  }
}
