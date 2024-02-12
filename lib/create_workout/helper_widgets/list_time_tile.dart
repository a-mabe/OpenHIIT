import 'package:flutter/material.dart';

class ListTimeTileClass extends StatefulWidget {
  /// Vars

  final String? title;

  final String? subtitle;

  final Widget? leadingWidget;

  final Widget? trailingWidget;

  const ListTimeTileClass({
    this.title,
    this.subtitle,
    this.leadingWidget,
    this.trailingWidget,
    super.key,
  });

  @override
  ListTimeTileClassState createState() => ListTimeTileClassState();
}

class ListTimeTileClassState extends State<ListTimeTileClass> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title!),
      subtitle: Text(widget.subtitle!),
      leading: widget.leadingWidget ?? const Text(""),
      trailing: widget.trailingWidget ?? const Text(""),
    );
  }
}
