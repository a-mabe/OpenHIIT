import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StartButton extends StatelessWidget {
  /// Called on button tap.
  ///
  final VoidCallback? onTap;

  const StartButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    /// Device screen height, used to calculate text and
    /// icon sizes.
    ///
    double sizeHeight = MediaQuery.of(context).size.height;

    /// Device screen width, used to calculate text and
    /// icon sizes.
    ///
    double sizeWidth = MediaQuery.of(context).size.width;

    return Padding(
        padding: const EdgeInsets.fromLTRB(35, 15, 35, 15),
        child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular((sizeHeight * sizeWidth) * .0005),
                color: Colors.green,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(140, 72, 129, 74),
                    spreadRadius: 5,
                    blurRadius: 3,
                    offset: Offset(-1, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: const Color.fromARGB(255, 155, 187, 162),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(sizeHeight / 50),
                          child: AutoSizeText(
                            'Start',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: sizeHeight / 10,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          )),
                      Icon(
                        Icons.arrow_forward,
                        size: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? sizeHeight * .05
                            : sizeHeight * .07,
                        color: Colors.white,
                      )
                    ],
                  )),
            )));
  }
}
