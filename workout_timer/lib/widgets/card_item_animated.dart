import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/list_tile_model.dart';

/// Displays its integer item as 'item N' on a Card whose color is based on
/// the item's value.
///
/// The text is displayed in bright green if [selected] is
/// true. This widget's height is based on the [animation] parameter, it
/// varies from 0 to 128 as the animation varies from 0.0 to 1.0.
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

  @override
  Widget build(BuildContext context) {
    // TextStyle? textStyle = Theme.of(context).textTheme;
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
              //                    <--- top side
              color: Color.fromARGB(53, 255, 255, 255),
              width: 3.0,
            ),
          ),
        ),
        // color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 75.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: SizedBox(
                  width: 85,
                  child: Text(
                    item.intervalString(),
                    style: TextStyle(
                        fontSize: 25, color: fontColor, fontWeight: fontWeight),
                  ),
                ),
              ),
              SizedBox(
                width: 225,
                child: Text(
                  item.action,
                  style: TextStyle(
                      fontSize: 25, color: fontColor, fontWeight: fontWeight),
                ),
              ),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: SizedBox(
                    width: 40,
                    child: Text(
                      "${item.seconds}s",
                      style: TextStyle(
                          fontSize: 20,
                          color: fontColor,
                          fontWeight: fontWeight),
                    ),
                  ))
            ],
          ),
        ),
        // child: Container(
        //   // color: Colors.transparent,
        //   child: Center(
        //     child: Text('$item', style: textStyle),
        //   ),
        // ),
      ),
    );
  }
}
