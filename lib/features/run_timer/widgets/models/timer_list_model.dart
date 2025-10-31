import 'package:flutter/cupertino.dart';
import 'package:openhiit/features/run_timer/widgets/models/timer_list_tile_model.dart';

/// Keeps a Dart [List] in sync with an [AnimatedList].
///
/// The [insert] and [removeAt] methods apply to both the internal list and
/// the animated list that belongs to [listKey].
///
/// This class only exposes as much of the Dart List API as is needed by the
/// sample app. More list methods are easily added, however methods that
/// mutate the list must make the same changes to the animated list in terms
/// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
///

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class TimerListModel<E> {
  TimerListModel({
    required this.listKey,
    Iterable<TimerListTileModel>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <TimerListTileModel>[]);

  final GlobalKey<AnimatedListState> listKey;
  final List<E> _items;

  AnimatedListState? get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}
