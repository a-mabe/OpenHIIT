import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatefulWidget {
  final List<Widget> children;

  const CustomBottomAppBar({super.key, required this.children});

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBottomAppBarColor = theme.bottomAppBarTheme.color ??
        (theme.useMaterial3
            ? theme.colorScheme.surface
            : (theme.brightness == Brightness.dark
                ? const Color(0xFF424242)
                : Colors.white));

    return Material(
        elevation: 4, // Adjust as needed
        color: defaultBottomAppBarColor,
        child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.25),
                    width: 1),
              ),
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: widget.children,
            )));
  }
}
