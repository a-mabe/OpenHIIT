import 'package:flutter/material.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:openhiit/features/edit_timer/ui/portrait/edit_timer_portrait.dart';

class ViewTimerPage extends StatefulWidget {
  final TimerType? timer;

  const ViewTimerPage({super.key, required this.timer});

  @override
  State<ViewTimerPage> createState() => _ViewTimerPageState();
}

class _ViewTimerPageState extends State<ViewTimerPage> {
  bool _isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // A common breakpoint for tablets is 600dp
    return size.shortestSide >= 600;
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final isTablet = _isTablet(context);

        if (isLandscape || isTablet) {
          return Container();
          // return const ViewTimerLandscape();
        } else {
          return EditTimerPortrait(timer: widget.timer!, formKey: formKey);
        }
      },
    );
  }
}
