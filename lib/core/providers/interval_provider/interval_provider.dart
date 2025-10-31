import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/core/db/repositories/interval_repository.dart';

class IntervalProvider extends ChangeNotifier {
  List<IntervalType> _intervals = [];
  List<IntervalType> get intervals => _intervals;

  final IntervalRepository _intervalRepository = IntervalRepository();

  Future<List<IntervalType>> loadIntervals(String timerId) async {
    _intervals = await _intervalRepository.getIntervalsByTimerId(timerId);
    notifyListeners();
    return _intervals;
  }

  void setIntervals(List<IntervalType> intervals) {
    _intervals = intervals;
    notifyListeners();
  }

  Future<void> saveIntervals(List<IntervalType> intervals) async {
    await _intervalRepository.insertIntervals(intervals);
    _intervals = intervals;
    notifyListeners();
  }

  Future<void> deleteIntervals(String timerId) async {
    await _intervalRepository.deleteIntervalsByTimerId(timerId);
    _intervals.clear();
    notifyListeners();
  }
}
