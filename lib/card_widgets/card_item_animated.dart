import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../models/list_tile_model.dart';

class CardItemAnimated extends StatelessWidget {
  const CardItemAnimated({
    super.key,
    this.onTap,
    this.selected = false,
    required this.fontColor,
    required this.fontWeight,
    required this.animation,
    required this.item,
  });

  final Color fontColor;
  final FontWeight fontWeight;
  final Animation<double> animation;
  final VoidCallback? onTap;
  final ListTileModel item;
  final bool selected;

  double calcPadding(context) {
    return MediaQuery.of(context).orientation == Orientation.portrait ? 15 : 5;
  }

  @override
  Widget build(BuildContext context) {
    double height = 20;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
          reverseCurve: Curves.easeOut)),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(
            top: BorderSide(
              // <--- top side
              color: Color.fromARGB(53, 255, 255, 255),
              width: 3.0,
            ),
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: height,
              maxHeight: MediaQuery.of(context).size.height / 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 20,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, calcPadding(context),
                          8.0, calcPadding(context)),
                      child: AutoSizeText(
                        item.intervalString().isEmpty
                            ? "       "
                            : item.intervalString(),
                        maxLines: 1,
                        minFontSize: 0,
                        maxFontSize: 20000,
                        style: TextStyle(fontSize: 20000, color: fontColor),
                      ))),
              Expanded(
                  flex: 60,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          8.0, calcPadding(context), 8.0, calcPadding(context)),
                      child: AutoSizeText(
                        item.action.padRight(50, " "),
                        maxLines: 2,
                        minFontSize: 20,
                        maxFontSize: 20000,
                        style: TextStyle(fontSize: 20000, color: fontColor),
                      ))),
              Expanded(
                flex: 20,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        8.0, calcPadding(context), 10.0, calcPadding(context)),
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
