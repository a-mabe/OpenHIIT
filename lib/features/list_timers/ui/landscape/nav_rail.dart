import 'package:flutter/material.dart';
import 'package:openhiit/features/list_timers/ui/widgets/nav_bar_icon_button.dart';

class ListTimersNavRail extends StatefulWidget {
  const ListTimersNavRail({super.key});

  @override
  ListTimersNavRailState createState() => ListTimersNavRailState();
}

class ListTimersNavRailState extends State<ListTimersNavRail> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavBarIconButton(
              icon: Icons.share_outlined,
              iconSize: 22,
              label: 'Share Timers',
              onPressed: () {}),
          NavBarIconButton(
              icon: Icons.add_circle,
              iconSize: 22,
              label: 'New Timer',
              onPressed: () {}),
        ],
      ),
    );
  }
}
