import 'package:flutter/material.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/import_export_timers/ui/export_bottom_sheet.dart';
import 'package:openhiit/features/import_export_timers/utils/import_export_util.dart';

void onExportPressed(BuildContext context, TimerProvider timerProvider) {
  showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    context: context,
    builder: (BuildContext context) {
      return ExportBottomSheet(timerProvider: timerProvider);
    },
  );
}

Future<void> onImportPressed(BuildContext context, TimerProvider timerProvider,
    Function? onImport) async {
  await ImportExportUtil.tryImport(timerProvider);
  onImport?.call();
}
