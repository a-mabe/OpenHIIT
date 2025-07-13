import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/list_timers/ui/widgets/tile.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';
import 'package:provider/provider.dart';

class ListTimersReorderableList extends StatefulWidget {
  final List<TimerType> items;
  final void Function(List<TimerType>)? onReorderCompleted;

  const ListTimersReorderableList({
    super.key,
    required this.items,
    this.onReorderCompleted,
  });

  @override
  State<ListTimersReorderableList> createState() =>
      _ListTimersReorderableListState();
}

class _ListTimersReorderableListState extends State<ListTimersReorderableList> {
  late List<TimerType> _items;
  TimerProvider? _timerProvider;

  var logger = Logger(
    printer: JsonLogPrinter('ReorderableList'),
    level: Level.info,
  );

  @override
  void initState() {
    super.initState();
    _items = List<TimerType>.from(widget.items);
    _timerProvider = Provider.of<TimerProvider>(context, listen: false);
  }

  void _onReorder(int oldIndex, int newIndex) {
    logger.i("Reordering item from $oldIndex to $newIndex");

    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
      _timerProvider?.updateTimerOrder(_items);
    });
    if (widget.onReorderCompleted != null) {
      widget.onReorderCompleted!(_items);
    }
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(scale: scale, child: child);
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: _onReorder,
      proxyDecorator: proxyDecorator,
      children: [
        for (final item in _items)
          ListTimersTile(
            key: ValueKey(item.id),
            timer: item,
            // onTap: () => _onItemTap(item), // Uncomment if you want to handle taps
          ),
      ],
    );
  }
}
