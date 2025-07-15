import 'package:flutter/material.dart';
import 'package:openhiit/features/list_timers/ui/constants.dart';
import 'package:openhiit/features/list_timers/ui/widgets/nav_bar_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 25),
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
          SizedBox(height: 50),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: NavBarIconButton(
                  icon: Icons.share_outlined,
                  iconSize: 25,
                  label: 'Share',
                  verticalPadding: 8,
                  onPressed: () {})),
          Spacer(),
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
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
