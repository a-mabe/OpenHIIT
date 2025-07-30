import 'package:flutter/material.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/import_export_timers/ui/snackbars.dart';
import 'package:openhiit/features/import_export_timers/utils/import_export_util.dart';

class ExportBottomSheet extends StatefulWidget {
  final TimerProvider timerProvider;

  const ExportBottomSheet({super.key, required this.timerProvider});

  @override
  State<ExportBottomSheet> createState() => _ExportBottomSheetState();
}

class _ExportBottomSheetState extends State<ExportBottomSheet> {
  bool exporting = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              onTap: exporting
                  ? null
                  : () async {
                      setState(() {
                        exporting = true;
                      });
                      try {
                        bool result = await ImportExportUtil.exportToDevice(
                          widget.timerProvider.timers,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            result
                                ? successSnackbar(
                                    'Timers exported successfully.')
                                : infoSnackbar('Nothing exported.'),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            exporting = false;
                          });
                        }
                      }
                    },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(25, 15, 15, 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.download,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        "Save to device",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: exporting
                  ? null
                  : () async {
                      setState(() => exporting = true);
                      try {
                        final result = await ImportExportUtil.share(
                            widget.timerProvider.timers);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            result
                                ? successSnackbar('Timers shared successfully.')
                                : infoSnackbar('Share canceled.'),
                          );
                        }
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackbar(
                                'An error occurred while sharing timers.'),
                          );
                        }
                      } finally {
                        if (context.mounted) setState(() => exporting = false);
                      }
                    },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(25, 15, 15, 15),
                child: Row(
                  children: [
                    Icon(Icons.share),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        "Share external",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
