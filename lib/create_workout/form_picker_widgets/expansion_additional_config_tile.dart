import 'package:flutter/material.dart';
import 'package:openhiit/create_workout/constants/set_timings_constants.dart';

class ExpansionRepeatTileClass extends StatefulWidget {
  /// Vars

  final Widget? trailingWidget;

  const ExpansionRepeatTileClass({
    this.trailingWidget,
    super.key,
  });

  @override
  ExpansionRepeatTileClassState createState() =>
      ExpansionRepeatTileClassState();
}

class ExpansionRepeatTileClassState extends State<ExpansionRepeatTileClass> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Additional configuration'),
      subtitle: Text('Auto restart, warm-up, and more'),
      leading: Icon(Icons.tune),
      children: <Widget>[
        ListTile(
          title: Text(additionalTimeTitles[0]),
          subtitle: Text(additionalTimeSubTitles[0]),
          leading: Icon(Icons.flag),
          trailing: widget.trailingWidget,
        ),
        ListTile(
          title: Text(additionalTimeTitles[1]),
          subtitle: Text(additionalTimeSubTitles[1]),
          leading: Icon(Icons.emoji_people),
          trailing: widget.trailingWidget,
        ),
        ListTile(
          title: Text(additionalTimeTitles[2]),
          subtitle: Text(additionalTimeSubTitles[2]),
          leading: Icon(Icons.ac_unit),
          trailing: widget.trailingWidget,
        ),
        ListTile(
          title: Text(additionalTimeTitles[3]),
          subtitle: Text(additionalTimeSubTitles[3]),
        ),
        ListTile(
          title: Text(additionalTimeTitles[4]),
          subtitle: Text(additionalTimeSubTitles[4]),
          leading: Icon(Icons.replay),
          trailing: widget.trailingWidget,
        ),
        ListTile(
          title: Text(additionalTimeTitles[5]),
          subtitle: Text(additionalTimeSubTitles[5]),
          leading: Icon(Icons.block),
          trailing: widget.trailingWidget,
        ),
      ],
    );
  }
}
