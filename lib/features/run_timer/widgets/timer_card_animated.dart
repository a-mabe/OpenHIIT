import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/features/run_timer/widgets/models/timer_list_tile_model.dart';

class TimerCardItemAnimated extends StatelessWidget {
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
  final TimerListTileModel item;

  /// Function to invoke on ListTile tap.
  ///
  final VoidCallback? onTap;

  final double sizeMultiplier;

  const TimerCardItemAnimated({
    super.key,
    this.onTap,
    required this.fontColor,
    required this.backgroundColor,
    required this.fontWeight,
    required this.animation,
    required this.item,
    required this.sizeMultiplier,
  });

  /// Calculate padding to place around text depending on the device orientation.
  ///
  double calcPadding(context) {
    // return MediaQuery.of(context).orientation == Orientation.portrait ? 15 : 5;
    return 10;
  }

  double calcHeight(String action) {
    // Leave room for the "Next: Set x of y" line under the action.
    final subtitle = item.nextSetString().isNotEmpty ? 20 * sizeMultiplier : 0;
    return _actionHeight(action) + subtitle;
  }

  double _actionHeight(String action) {
    if (action.length > 20) {
      if (action.length > 30) {
        return 110 * sizeMultiplier;
      }
      return 100 * sizeMultiplier;
    } else {
      return 75 * sizeMultiplier;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Minimum height that each ListTile can be.
    ///
    double minHeight = 75;

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
            maxHeight: calcHeight(item.action),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Interval number, e.g. 1/8.
              Expanded(
                  flex: 20,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(15, calcPadding(context) + 5,
                          8, calcPadding(context) + 5),
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 50,
                            maxHeight: 100,
                          ),
                          child: AutoSizeText(
                            item.interval != 0 ? item.interval.toString() : "",
                            maxLines: 1,
                            minFontSize: 14,
                            maxFontSize: 500,
                            style: TextStyle(
                              color: fontColor,
                              fontSize: 500,
                            ),
                          )))),
              // Current interval text, "Work" if no exercise provided.
              Expanded(
                  flex: 60,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          8, calcPadding(context), 8.0, calcPadding(context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: AutoSizeText(
                              item.action,
                              maxLines: 2,
                              minFontSize: 14,
                              maxFontSize: 28,
                              overflow: TextOverflow.ellipsis,
                              stepGranularity: 1,
                              style: TextStyle(fontSize: 28, color: fontColor),
                            ),
                          ),
                          if (item.nextSetString().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                item.nextSetString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: fontColor.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                        ],
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
                      minFontSize: 14,
                      maxFontSize: 32,
                      overflow: TextOverflow.ellipsis,
                      stepGranularity: 1,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 32, color: fontColor),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
