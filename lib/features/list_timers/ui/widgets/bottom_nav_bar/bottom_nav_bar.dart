import 'package:flutter/material.dart';
import 'package:openhiit/features/list_timers/ui/widgets/bottom_nav_bar/nav_bar_icon_button.dart';

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
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     IconButton(
          //       icon: const Icon(Icons.add),
          //       tooltip: 'New Timer',
          //       padding: EdgeInsets.zero,
          //       constraints: const BoxConstraints(),
          //       onPressed: () {
          //         // TODO: Implement new timer action
          //       },
          //     ),
          //     // const SizedBox(height: 2),
          //     const Text('New Timer', style: TextStyle(fontSize: 12)),
          //   ],
          // ),
        ],
      ),
    );
  }
}
