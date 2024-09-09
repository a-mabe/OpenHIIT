import 'package:flutter/material.dart';
import 'package:openhiit/models/workout_type.dart';
import 'package:openhiit/utils/database/database_manager.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Workout> _workouts = [];

  List<Workout> get workouts => _workouts;

  Future loadWorkoutData() async {
    var dbManager = DatabaseManager();
    return dbManager.lists(dbManager.initDB()).then((entries) {
      _workouts = workouts;
    }).whenComplete(() {
      notifyListeners();
    });
  }

  Future updateExpense(Workout workout) async {
    var dbManager = DatabaseManager();
    return dbManager
        .updateList(workout, await DatabaseManager().initDB())
        .then((_) {
      var updated = false;
      for (var i = 0; i < _workouts.length; i++) {
        if (_workouts[i].id == workout.id) {
          _workouts[i] = workout.copy();
          updated = true;
          break;
        }
      }
      if (!updated) {
        throw Exception('Unable to find workout with ID: ${workout.id}');
      }
    }).whenComplete(() => notifyListeners());
  }

  Future addExpense(Workout workout) async {
    var dbManager = DatabaseManager();
    return dbManager
        .insertList(workout, await DatabaseManager().initDB())
        .then((val) {
      _workouts.add(workout);
    }).whenComplete(() => notifyListeners());
  }

  Future deleteExpense(Workout workout) async {
    var dbManager = DatabaseManager();
    return dbManager
        .deleteList(workout.id, DatabaseManager().initDB())
        .then((_) {
      _workouts.removeWhere((workout) => workout.id == workout.id);
    }).whenComplete(() => notifyListeners());
  }

  void sort<T>(
    Comparable<T> Function(Workout workout) getField,
    bool ascending,
  ) {
    workouts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }
}
