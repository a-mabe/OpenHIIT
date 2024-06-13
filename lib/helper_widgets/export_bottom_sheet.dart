import 'package:flutter/material.dart';

import '../constants/snackbars.dart';
import '../import_export/local_file_util.dart';
import '../workout_data_type/workout_type.dart';

class ExportBottomSheet extends StatelessWidget {
  final Workout workout;

  const ExportBottomSheet({super.key, required this.workout});

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
              onTap: () async {
                LocalFileUtil fileUtil = LocalFileUtil();

                await fileUtil.saveFileToDevice(workout);

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(successfulSaveToDeviceSnackBar);
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
              onTap: () async {
                LocalFileUtil fileUtil = LocalFileUtil();

                await fileUtil.writeFile(workout);

                await fileUtil.shareFile(workout).then((value) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(successfulShareSnackBar);
                });
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
