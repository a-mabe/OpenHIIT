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
}
