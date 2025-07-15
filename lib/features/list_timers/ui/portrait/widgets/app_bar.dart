import 'package:flutter/material.dart';
import 'package:openhiit/features/list_timers/ui/constants.dart';
import 'package:url_launcher/url_launcher.dart';

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
      ],
    );
  }
}
