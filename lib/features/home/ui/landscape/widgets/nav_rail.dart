import 'package:flutter/material.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/home/ui/constants.dart';
import 'package:openhiit/features/home/ui/widgets/nav_bar_icon_button.dart';
import 'package:openhiit/features/import_export_timers/ui/export_bottom_sheet.dart';
import 'package:openhiit/features/import_export_timers/utils/import_export_util.dart';
import 'package:url_launcher/url_launcher.dart';

class ListTimersNavRail extends StatefulWidget {
  final TimerProvider timerProvider;
  final Function? onImport;

  const ListTimersNavRail(
      {super.key, required this.timerProvider, this.onImport});

  @override
  ListTimersNavRailState createState() => ListTimersNavRailState();
}

class ListTimersNavRailState extends State<ListTimersNavRail> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: NavBarIconButton(
              icon: Icons.add_circle,
              iconSize: 25,
              label: 'New',
              verticalPadding: 8,
              onPressed: () {},
            ),
          ),
          SizedBox(height: 12),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: NavBarIconButton(
                  icon: Icons.upload,
                  iconSize: 25,
                  label: 'Export',
                  verticalPadding: 8,
                  onPressed: () {
                    showModalBottomSheet<void>(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      context: context,
                      builder: (BuildContext context) {
                        return ExportBottomSheet(
                            timerProvider: widget.timerProvider);
                      },
                    );
                  })),
          SizedBox(height: 12),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: NavBarIconButton(
                  icon: Icons.download,
                  iconSize: 25,
                  label: 'Import',
                  verticalPadding: 8,
                  onPressed: () async {
                    await ImportExportUtil.tryImport(widget.timerProvider);
                    widget.onImport?.call();
                  })),
          Spacer(),
          IconButton(
            key: const Key('about_button'),
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
                          final Uri url =
                              Uri.parse('https://a-mabe.github.io/OpenHIIT/');
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
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
