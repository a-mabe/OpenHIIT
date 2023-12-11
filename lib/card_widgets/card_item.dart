import 'package:flutter/material.dart';
import '../models/list_tile_model.dart';

/// Displays its integer item as 'item N' on a Card whose color is based on
/// the item's value.
///
/// The text is displayed in bright green if [selected] is
/// true. This widget's height is based on the [animation] parameter, it
/// varies from 0 to 128 as the animation varies from 0.0 to 1.0.
class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    this.onTap,
    this.selected = false,
    required this.item,
  });

  final VoidCallback? onTap;
  final ListTileModel item;
  final bool selected;

  String timeString(showMinutes, seconds) {
    if (showMinutes == 1) {
      int secondsRemainder = seconds % 60;
      int minutes = ((seconds - secondsRemainder) / 60).round();

      if (minutes == 0) {
        return "${seconds.toString()}s";
      }

      String secondsString = secondsRemainder.toString();
      if (secondsRemainder < 10) {
        secondsString = "0$secondsRemainder";
      }

      return "$minutes:$secondsString";
    } else {
      return ("${seconds.toString()}s");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: SizedBox(
              width: 50,
              child: Text(
                item.intervalString(),
              ),
            ),
          ),
          SizedBox(
            child: Text(
              item.action,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 60,
            child: Text(
              timeString(item.showMinutes, item.seconds),
            ),
          ),
        ],
      ),
    );
  }
}
