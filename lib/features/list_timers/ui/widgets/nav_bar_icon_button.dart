import 'package:flutter/material.dart';

class NavBarIconButton extends StatefulWidget {
  final IconData icon;
  final int iconSize;
  final String? label;
  final VoidCallback? onPressed;
  final bool isSelected;

  const NavBarIconButton({
    super.key,
    required this.icon,
    this.iconSize = 24,
    this.label,
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
          onTap: () {
            // Handle tap
          },
          borderRadius: BorderRadius.circular(10), // Optional rounded corners
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon,
                    size: widget.iconSize.toDouble(),
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                SizedBox(height: 5),
                Text(
                  widget.label ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
