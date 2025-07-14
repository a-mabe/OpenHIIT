import 'package:flutter/material.dart';
import 'package:openhiit/features/list_timers/ui/widgets/nav_bar_icon_button.dart';

class ListTimersBottomNavigationBar extends StatefulWidget {
  const ListTimersBottomNavigationBar({super.key});

  @override
  ListTimersBottomNavigationBarState createState() =>
      ListTimersBottomNavigationBarState();
}

class ListTimersBottomNavigationBarState
    extends State<ListTimersBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
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
