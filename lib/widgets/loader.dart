import 'package:flutter/material.dart';

class LoaderTransparent extends StatelessWidget {
  final bool visible;
  final String loadingMessage;

  const LoaderTransparent({
    super.key,
    required this.visible,
    this.loadingMessage = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Stack(
        children: [
          // Transparent background to cover the screen
          Positioned.fill(
            child: Container(
              color: Colors.black54,
            ),
          ),
          // Centered CircularProgressIndicator with text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                const SizedBox(height: 10.0),
                Flexible(
                  child: Text(
                    loadingMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2, // Limit to 2 lines
                    overflow:
                        TextOverflow.ellipsis, // Add ellipsis for overflow
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class LoaderTransparent extends StatelessWidget {
//   /// Message to show under the loading spinner.
//   ///
//   final String? loadingMessage;

//   /// Whether to display the loading spinner.
//   ///
//   final bool visibile;

//   const LoaderTransparent(
//       {super.key, this.loadingMessage, required this.visibile});

//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//         visible: visibile,
//         child: Text(
//           loadingMessage != null ? loadingMessage! : "",
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//         )
//         // child: Center(
//         //     child:
//         //         Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         //   // const CircularProgressIndicator(strokeWidth: 7.0),
//         //   SizedBox(
//         //       height: 200,
//         //       width: 200,
//         //       child: Text(
//         //         loadingMessage != null ? loadingMessage! : "",
//         //         style:
//         //             const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//         //       ))
//         );
//   }
// }
