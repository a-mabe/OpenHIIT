import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../models/list_tile_model.dart';

class CardItemAnimated extends StatelessWidget {
  /// Color of the font used in each card.
  ///
  final Color fontColor;

  /// Weight of the font used in each card.
  ///
  final FontWeight fontWeight;

  /// Background color of each card.
  ///
  final Color backgroundColor;

  /// Animation to used when removing a list item.
  ///
  final Animation<double> animation;

  /// Object that contains all interval data to display
  /// in the ListTile.
  ///
  final ListTileModel item;

  /// Function to invoke on ListTile tap.
  ///
  final VoidCallback? onTap;

  const CardItemAnimated({
    super.key,
    this.onTap,
    required this.fontColor,
    required this.backgroundColor,
    required this.fontWeight,
    required this.animation,
    required this.item,
  });

  /// Calculate padding to place around text depending on the device orientation.
  ///
  double calcPadding(context) {
    return MediaQuery.of(context).orientation == Orientation.portrait ? 15 : 5;
  }

  @override
  Widget build(BuildContext context) {
    /// Minimum height that each ListTile can be.
    ///
    double minHeight = 20;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
          reverseCurve: Curves.easeOut)),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          // Set top border.
          border: const Border(
            top: BorderSide(
              color: Color.fromARGB(53, 255, 255, 255),
              width: 3.0,
            ),
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: minHeight,
              maxHeight:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.height / 10
                      : MediaQuery.of(context).size.height / 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Interval number, e.g. 1/8.
              Expanded(
                  flex: 20,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 8, 0),
                      child: AutoSizeText(
                        item.intervalString().isEmpty
                            ? ""
                            : item.interval.toString(),
                        maxLines: 1,
                        minFontSize: 14,
                        maxFontSize: 500,
                        style: TextStyle(
                          color: fontColor,
                          fontSize: 500,
                        ),
                      ))
                  // child: Padding(
                  //     padding: const EdgeInsets.fromLTRB(15, 0, 12, 0),
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //           flex: 28,
                  //           child: Align(
                  //               alignment: Alignment.bottomRight,
                  //               child: AutoSizeText(
                  //                 item.intervalString().isEmpty
                  //                     ? ""
                  //                     : item.interval.toString(),
                  //                 maxLines: 1,
                  //                 minFontSize: 14,
                  //                 maxFontSize: 500,
                  //                 style: const TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 500,
                  //                     height: 2),
                  //               )),
                  //         ),
                  //         Expanded(
                  //           flex: 2,
                  //           child: Align(
                  //               alignment: Alignment.bottomLeft,
                  //               child: AutoSizeText(
                  //                 item.intervalString().isEmpty
                  //                     ? ""
                  //                     : "/${item.total}",
                  //                 maxLines: 1,
                  //                 minFontSize: 1,
                  //                 maxFontSize: 500,
                  //                 style: const TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 500,
                  //                     height: 3),
                  //               )
                  //               // Padding(
                  //               //     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  //               //     child: AutoSizeText(
                  //               //       item.intervalString().isEmpty
                  //               //           ? ""
                  //               //           : "/${item.total}",
                  //               //       maxLines: 1,
                  //               //       minFontSize: 14,
                  //               //       maxFontSize: 500,
                  //               //       style: const TextStyle(
                  //               //           color: Colors.white, fontSize: 500),
                  //               //     ))
                  //               ),
                  //         ),
                  //       ],
                  //     ))
                  ),
              // Current interval text, "Work" if no exercise provided.
              Expanded(
                  flex: 60,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          8, calcPadding(context), 8.0, calcPadding(context)),
                      child: AutoSizeText(
                        item.action.padRight(50, " "),
                        maxLines: 2,
                        minFontSize: 20,
                        maxFontSize: 20000,
                        style: TextStyle(fontSize: 20000, color: fontColor),
                      ))),
              // Time allotted to the interval.
              Expanded(
                flex: 20,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        8.0, calcPadding(context), 15, calcPadding(context)),
                    child: AutoSizeText(
                      item.timeString(),
                      maxLines: 1,
                      minFontSize: 0,
                      maxFontSize: 20000,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 20000, color: fontColor),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
