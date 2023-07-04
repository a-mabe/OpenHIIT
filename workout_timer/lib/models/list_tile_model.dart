class ListTileModel<E> {
  ListTileModel(
      {required this.action,
      required this.interval,
      required this.total,
      required this.seconds});

  String action;
  int interval;
  int total;
  int seconds;

  String intervalString() {
    return interval == 0 ? "" : "$interval/$total";
  }

  // final GlobalKey<AnimatedListState> listKey;
  // final List<E> _items;

  // AnimatedListState? get _animatedList => listKey.currentState;

  // void insert(int index, E item) {
  //   _items.insert(index, item);
  //   _animatedList!.insertItem(index);
  // }

  // E removeAt(int index) {
  //   final E removedItem = _items.removeAt(index);
  //   if (removedItem != null) {
  //     _animatedList!.removeItem(
  //       index,
  //       (BuildContext context, Animation<double> animation) {
  //         return removedItemBuilder(removedItem, context, animation);
  //       },
  //     );
  //   }
  //   return removedItem;
  // }

  // int get length => _items.length;

  // E operator [](int index) => _items[index];

  // int indexOf(E item) => _items.indexOf(item);
}
