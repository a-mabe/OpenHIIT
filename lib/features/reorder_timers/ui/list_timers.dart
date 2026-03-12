import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/reorder_timers/ui/widgets/tile.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:provider/provider.dart';

typedef TimerTapCallback = void Function(TimerType timer);

/// Given a list of timers, this widget displays them and allows reordering.

class ListTimersReorderableList extends StatefulWidget {
  final List<TimerType> items;
  final TimerTapCallback? onTap;
  final void Function(List<TimerType>)? onReorderCompleted;
  final void Function(TimerType)? onDelete;

  const ListTimersReorderableList({
    super.key,
    required this.items,
    this.onTap,
    this.onReorderCompleted,
    this.onDelete,
  });

  @override
  State<ListTimersReorderableList> createState() =>
      _ListTimersReorderableListState();
}

class _ListTimersReorderableListState extends State<ListTimersReorderableList> {
  late List<TimerType> _items;
  TimerProvider? _timerProvider;

  @override
  void initState() {
    super.initState();
    Log.debug(
        "initializing ListTimersReorderableList with ${widget.items.length} items");
    _items = List<TimerType>.from(widget.items);
    _timerProvider = Provider.of<TimerProvider>(context, listen: false);
  }

  void _onReorder(int oldIndex, int newIndex) {
    Log.debug("reordering item from $oldIndex to $newIndex");

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

  void _onDelete(TimerType item) {
    Log.debug("deleting item ${item.name}");

    bool undone = false;

    setState(() {
      _items.remove(item);
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('${item.name} deleted'),
            duration: const Duration(seconds: 2),
            persist: false,
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                undone = true;
                setState(() {
                  _items.insert(item.timerIndex, item);
                  _timerProvider?.updateTimerOrder(_items);
                });
              },
            ),
          ),
        )
        .closed
        .then((_) {
      if (!undone) {
        _timerProvider?.deleteTimer(item);
        widget.onDelete?.call(item);
      }
    });
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
          Dismissible(
            key: ValueKey("${item.name}-${item.timerIndex}"),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _onDelete(item),
            background: Card(
              color: Colors.red,
              margin: const EdgeInsets.all(4.0),
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
            ),
            child: ListTimersTile(
              key: ValueKey("tile-${item.name}-${item.timerIndex}"),
              timer: item,
              onTap: widget.onTap != null ? () => widget.onTap!(item) : null,
            ),
          ),
      ],
    );
  }
}
