import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openhiit/constants/snackbars.dart';
import 'package:openhiit/constants/strings.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/pages/select_timer/select_timer.dart';
import 'package:openhiit/pages/view_timer/view_timer.dart';
import 'package:openhiit/pages/home/widgets/fab_column.dart';
import 'package:openhiit/providers/timer_creation_notifier.dart';
import 'package:openhiit/providers/timer_provider.dart';
import 'package:openhiit/utils/database/database_manager.dart';
import 'package:openhiit/utils/import_export/utils/local_file_util.dart';
import 'package:openhiit/utils/import_export/widgets/export_bottom_sheet.dart';
import 'package:openhiit/pages/home/widgets/timer_list_tile.dart';
import 'package:openhiit/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

bool exporting = false;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TimerType> reorderableTimerList = [];
  late TimerProvider workoutProvider;

  @override
  void initState() {
    super.initState();
    workoutProvider = Provider.of<TimerProvider>(context, listen: false);
  }

  void _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > reorderableTimerList.length) {
      newIndex = reorderableTimerList.length;
    }
    if (oldIndex < newIndex) newIndex -= 1;

    final TimerType item = reorderableTimerList.removeAt(oldIndex);
    item.timerIndex = newIndex;
    reorderableTimerList.insert(newIndex, item);

    setState(() {
      for (var i = 0; i < reorderableTimerList.length; i++) {
        reorderableTimerList[i].timerIndex = i;
      }
    });

    DatabaseManager().updateTimers(reorderableTimerList);
  }

  Widget workoutListView(snapshot) {
    return ReorderableListView(
      onReorder: _onReorder,
      proxyDecorator: proxyDecorator,
      children: [
        for (final timer in snapshot.data)
          TimerListTile(
            key: Key('${timer.timerIndex}'),
            timer: timer,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewTimer(timer: timer),
                ),
              ).then((value) {
                if (mounted) {
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    statusBarBrightness: Theme.of(context).brightness,
                  ));
                }
              });
            },
            index: timer.timerIndex,
          ),
      ],
    );
  }

  Widget buildMessageWidget({required String summary, String? description}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(summary, style: const TextStyle(fontSize: 20)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(description ?? ""),
          ),
        ],
      ),
    );
  }

  void pushSelectTimerPage() async {
    TimerCreationNotifier timerCreationNotifier =
        Provider.of<TimerCreationNotifier>(context, listen: false);
    timerCreationNotifier.reset();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectTimer()),
    );
  }

  void saveWorkouts() async {
    logger.i("Exporting workouts to device...");
    setState(() => exporting = true);

    LocalFileUtil fileUtil = LocalFileUtil();
    bool result = await fileUtil.saveFileToDevice(workoutProvider.timers);

    setState(() => exporting = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        result
            ? createSuccessSnackBar("Saved to device!")
            : createErrorSnackBar("Save not completed"),
      );
    }
  }

  void shareWorkouts(BuildContext buildContext) async {
    logger.i("Exporting and sharing workouts...");
    setState(() => exporting = true);

    LocalFileUtil fileUtil = LocalFileUtil();
    await fileUtil.writeFile(workoutProvider.timers);

    if (buildContext.mounted) {
      ShareResult? result = await fileUtil.shareMultipleFiles(
          workoutProvider.timers, buildContext);

      setState(() => exporting = false);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          result != null && result.status == ShareResultStatus.success
              ? createSuccessSnackBar("Shared successfully!")
              : createErrorSnackBar("Share not completed"),
        );
      }
    }
  }

  void bulkExport() async {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      context: context,
      builder: (BuildContext context) {
        return ExportBottomSheet(
          timer: null,
          save: saveWorkouts,
          share: () => shareWorkouts(context),
        );
      },
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(scale: scale, child: child);
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Theme.of(context).brightness,
    ));

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 30,
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("About OpenHIIT"),
                        content: const Text(aboutText),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              final Uri url = Uri.parse(
                                  'https://a-mabe.github.io/OpenHIIT/');
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            },
                            child: const Text("View privacy policy"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          floatingActionButton: Visibility(
            visible: !exporting,
            child: FABColumn(bulk: bulkExport, create: pushSelectTimerPage),
          ),
          body: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: workoutProvider.loadWorkoutData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return buildMessageWidget(
                            summary: noSavedTimers,
                            description: noSavedTimersDescription);
                      } else {
                        reorderableTimerList = snapshot.data;
                        reorderableTimerList.sort(
                            (a, b) => a.timerIndex.compareTo(b.timerIndex));
                        return workoutListView(snapshot);
                      }
                    } else if (snapshot.hasError) {
                      return buildMessageWidget(
                          summary: 'Error: ${snapshot.error}');
                    } else {
                      return buildMessageWidget(summary: fetchingTimers);
                    }
                  },
                ),
              ),
              LoaderTransparent(
                loadingMessage: exportingFiles,
                visible: exporting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
