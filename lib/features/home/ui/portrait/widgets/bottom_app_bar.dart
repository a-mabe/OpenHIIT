import 'package:flutter/material.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/home/ui/widgets/nav_bar_icon_button.dart';
import 'package:openhiit/features/import_export_timers/utils/import_export_util.dart';

class ListTimersBottomAppBar extends StatefulWidget {
  final TimerProvider timerProvider;
  final Function? onImport;

  const ListTimersBottomAppBar(
      {super.key, required this.timerProvider, this.onImport});

  @override
  State<ListTimersBottomAppBar> createState() => _ListTimersBottomAppBarState();
}

class _ListTimersBottomAppBarState extends State<ListTimersBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          NavBarIconButton(
            icon: Icons.upload,
            label: 'Export',
            verticalPadding: 4,
            onPressed: () {},
          ),
          Spacer(),
          NavBarIconButton(
              icon: Icons.download,
              label: 'Import',
              verticalPadding: 4,
              onPressed: () async {
                await ImportExportUtil.tryImport(widget.timerProvider);
                widget.onImport?.call();
              }),
          Spacer()
        ],
      ),
    );
  }
}
