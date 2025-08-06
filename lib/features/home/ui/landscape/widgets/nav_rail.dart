import 'package:flutter/material.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/home/ui/widgets/about_button.dart';
import 'package:openhiit/features/home/ui/widgets/nav_bar_icon_button.dart';
import 'package:openhiit/features/home/utils/functions.dart';

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
              onPressed: () {
                onNewTimerPressed(context, widget.timerProvider);
              },
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
                    onExportPressed(context, widget.timerProvider);
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
                    await onImportPressed(
                      context,
                      widget.timerProvider,
                      widget.onImport,
                    );
                  })),
          Spacer(),
          AboutButton(),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
