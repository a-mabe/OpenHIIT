import 'package:flutter/material.dart';
import 'package:openhiit/features/home/ui/widgets/about_button.dart';

class ListTimersAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ListTimersAppBar({super.key});

  @override
  State<ListTimersAppBar> createState() => _ListTimersAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ListTimersAppBarState extends State<ListTimersAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        AboutButton(),
      ],
    );
  }
}
