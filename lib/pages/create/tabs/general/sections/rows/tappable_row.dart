import 'package:flutter/material.dart';

class TappableRow extends StatefulWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final Function? onTap;
  final EdgeInsetsGeometry? padding;

  const TappableRow({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.onTap,
    this.padding,
  });

  @override
  TappableRowState createState() => TappableRowState();
}

class TappableRowState extends State<TappableRow> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.leading != null) widget.leading!,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
            widget.trailing,
          ],
        ),
      ),
    );
  }
}
