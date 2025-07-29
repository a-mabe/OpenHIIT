import 'package:flutter/material.dart';
import 'package:openhiit/features/home/ui/landscape/home_landscape.dart';
import 'package:openhiit/features/home/ui/portrait/home_portrait.dart';

class ListTimersPage extends StatefulWidget {
  const ListTimersPage({super.key});

  @override
  State<ListTimersPage> createState() => _ListTimersPageState();
}

class _ListTimersPageState extends State<ListTimersPage> {
  bool _isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // A common breakpoint for tablets is 600dp
    return size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final isTablet = _isTablet(context);

        if (isLandscape || isTablet) {
          return const ListTimersLandscape();
        } else {
          return const ListTimersPortrait();
        }
      },
    );
  }
}
