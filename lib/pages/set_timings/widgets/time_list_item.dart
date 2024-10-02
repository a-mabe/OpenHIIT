import 'package:flutter/material.dart';

class TimeListItem extends StatefulWidget {
  /// Vars

  final String titleText;
  final String subtitleText;
  final bool enabled;
  final Widget? leadingWidget;
  final Widget? trailingWidget;

  const TimeListItem({
    this.titleText = "",
    this.subtitleText = "",
    this.enabled = true,
    this.leadingWidget,
    this.trailingWidget,
    super.key,
  });

  @override
  TimeListItemState createState() => TimeListItemState();
}

class TimeListItemState extends State<TimeListItem> {
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
    return ListTile(
      title: Text(widget.titleText),
      subtitle: Text(widget.subtitleText),
      leading: widget.leadingWidget ?? const Text(""),
      trailing: widget.trailingWidget ?? const Text(""),
      enabled: widget.enabled,
    );
  }
}
