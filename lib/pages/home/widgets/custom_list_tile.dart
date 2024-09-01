import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  /// Trailing widget for the list tile.
  ///
  final Widget? trailing;

  /// Cross axis alignment for the row.
  ///
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis alignment for the row.
  ///
  final MainAxisAlignment mainAxisAlignment;

  /// Title style for the list tile.
  ///
  final TextStyle titleStyle;

  /// Subtitle style for the list tile.
  ///
  final TextStyle subtitleStyle;

  /// Title for the list tile.
  ///
  final String title;

  /// Subtitle for the list tile.
  ///
  final String? subtitle;

  /// Leading widget for the list tile.
  ///
  final Widget? leading;

  const CustomListTile(
      {super.key,
      this.trailing,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.titleStyle = const TextStyle(),
      this.subtitleStyle = const TextStyle(),
      required this.title,
      this.subtitle,
      this.leading});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        leading ?? Container(),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Column(
                crossAxisAlignment: crossAxisAlignment,
                mainAxisAlignment: mainAxisAlignment,
                children: [
                  Text(
                    title,
                    style: titleStyle,
                  ),
                  Text(subtitle ?? "", style: subtitleStyle),
                ],
              )),
        ),
        trailing ?? Container()
      ],
    );
  }
}
