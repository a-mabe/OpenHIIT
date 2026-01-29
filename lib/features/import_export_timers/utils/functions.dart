import 'package:flutter/material.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/import_export_timers/ui/export_bottom_sheet.dart';
import 'package:openhiit/features/import_export_timers/utils/import_export_util.dart';

void onExportPressed(BuildContext context, List<TimerType> timers) {
  Log.debug("beginning export of ${timers.length} timer(s)");

  showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    useSafeArea: true,
    context: context,
    builder: (BuildContext context) {
      final bottomInset = MediaQuery.of(context).viewPadding.bottom;
      return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: ExportBottomSheet(
            timers: timers,
          ));
    },
  );
}

Future<void> onImportPressed(
    BuildContext context, TimerProvider timerProvider) async {
  Log.debug("import of timers beginning");
  await ImportExportUtil.tryImport(timerProvider);
}
