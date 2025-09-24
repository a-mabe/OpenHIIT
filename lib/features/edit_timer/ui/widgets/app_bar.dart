import 'package:flutter/material.dart';

class EditTimerAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final TabBar? bottom;

  const EditTimerAppBar({super.key, this.title = "Edit Timer", this.bottom});

  @override
  EditTimerAppBarState createState() => EditTimerAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(45 + (bottom?.preferredSize.height ?? 0));
}

class EditTimerAppBarState extends State<EditTimerAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            // Handle menu selection
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'Copy',
              child: Row(
                children: [
                  Icon(Icons.copy, size: 20),
                  SizedBox(width: 8),
                  Text('Copy'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'Delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ],
      bottom: widget.bottom,
    );
  }
}
