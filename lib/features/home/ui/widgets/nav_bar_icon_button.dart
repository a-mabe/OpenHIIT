import 'package:flutter/material.dart';

class NavBarIconButton extends StatefulWidget {
  final IconData icon;
  final int? iconSize;
  final String? label;
  final double fontSize;
  final double spacing;
  final double verticalPadding;
  final VoidCallback? onPressed;
  final bool isSelected;

  const NavBarIconButton({
    super.key,
    required this.icon,
    this.iconSize,
    this.label,
    this.fontSize = 12,
    this.spacing = 5.0,
    this.verticalPadding = 4,
    this.onPressed,
    this.isSelected = false,
  });

  @override
  NavBarIconButtonState createState() => NavBarIconButtonState();
}

class NavBarIconButtonState extends State<NavBarIconButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Use a background color if needed
      child: InkWell(
          key: Key(widget.label.toString()),
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(10), // Optional rounded corners
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: widget.verticalPadding,
              horizontal: 4.0,
            ),
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon,
                      size: widget.iconSize?.toDouble(),
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  SizedBox(height: widget.spacing),
                  Text(
                    widget.label ?? '',
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
