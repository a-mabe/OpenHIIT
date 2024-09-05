import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/snackbars.dart';
import '../../utils/import_export/local_file_util.dart';
import '../../models/workout_type.dart';

/// A bottom sheet widget used for exporting workout data.
///
/// This widget provides options for saving and sharing workout data.
class ExportBottomSheet extends StatelessWidget {
  /// The workout to be exported.
  ///
  final Workout? workout;

  /// Callback function to save the workout data.
  ///
  final void Function()? save;

  /// Callback function to share the workout data.
  ///
  final void Function()? share;

  const ExportBottomSheet({super.key, this.workout, this.save, this.share});

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
              onTap: workout != null
                  ? () async {
                      LocalFileUtil fileUtil = LocalFileUtil();

                      List<Workout> workoutsToExport = [workout!];

                      await fileUtil.saveFileToDevice(workoutsToExport);

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
              onTap: workout != null
                  ? () async {
                      LocalFileUtil fileUtil = LocalFileUtil();

                      await fileUtil.writeFile([workout!]);

                      if (context.mounted) {
                        ShareResult? result =
                            await fileUtil.shareFile([workout!], context);

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            result!.status == ShareResultStatus.success
                                ? createSuccessSnackBar("Shared successfully!")
                                : createErrorSnackBar("Share not completed"));
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
