import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/core/db/repositories/interval_repository.dart';

class IntervalProvider extends ChangeNotifier {
  List<IntervalType> _intervals = [];
  List<IntervalType> get intervals => _intervals;

  final IntervalRepository _intervalRepository = IntervalRepository();

  Future<List<IntervalType>> loadIntervals(String timerID) async {
    return _intervalRepository.getIntervalsByTimerId(timerID).then((intervals) {
      _intervals = intervals;
      return _intervals;
    }).whenComplete(() {
      notifyListeners();
    });
  }
}
