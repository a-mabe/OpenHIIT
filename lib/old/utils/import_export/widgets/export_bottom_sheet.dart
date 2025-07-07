import 'package:flutter/material.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';
import 'package:share_plus/share_plus.dart';

import 'package:openhiit/old/constants/snackbars.dart';
import 'package:openhiit/old/utils/import_export/utils/local_file_util.dart';

/// A bottom sheet widget used for exporting workout data.
///
/// This widget provides options for saving and sharing workout data.
class ExportBottomSheet extends StatelessWidget {
  /// The workout to be exported.
  ///
  final TimerType? timer;

  /// Callback function to save the workout data.
  ///
  final void Function()? save;

  /// Callback function to share the workout data.
  ///
  final void Function()? share;

  const ExportBottomSheet({super.key, this.timer, this.save, this.share});

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
              onTap: timer != null
                  ? () async {
                      LocalFileUtil fileUtil = LocalFileUtil();

                      List<TimerType> timersToExport = [timer!];

                      await fileUtil.saveFileToDevice(timersToExport);

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            createSuccessSnackBar("Saved to device!"));
                      }
                    }
                  : save,
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
              onTap: timer != null
                  ? () async {
                      LocalFileUtil fileUtil = LocalFileUtil();

                      await fileUtil.writeFile([timer!]);

                      if (context.mounted) {
                        ShareResult? result =
                            await fileUtil.shareFile([timer!], context);

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(result!
                                      .status ==
                                  ShareResultStatus.success
                              ? createSuccessSnackBar("Shared successfully!")
                              : createErrorSnackBar("Share not completed"));
                        }
                      }
                    }
                  : share,
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
