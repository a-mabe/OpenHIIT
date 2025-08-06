import 'package:flutter/material.dart';
import 'package:openhiit/features/home/ui/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutButton extends StatelessWidget {
  const AboutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
    );
  }
}
