import 'package:flutter/material.dart';

class LoaderTransparent extends StatelessWidget {
  /// Message to show under the loading spinner.
  ///
  final String? loadingMessage;

  /// Whether to display the loading spinner.
  ///
  final bool visibile;

  const LoaderTransparent(
      {super.key, this.loadingMessage, required this.visibile});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visibile,
        child: SizedBox.expand(
            child: Container(
                color: const Color.fromARGB(165, 0, 0, 0),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      const SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: CircularProgressIndicator(strokeWidth: 7.0)),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        loadingMessage != null ? loadingMessage! : "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ])))));
  }
}
