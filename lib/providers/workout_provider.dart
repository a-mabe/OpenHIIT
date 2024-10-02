import 'package:flutter/material.dart';
import 'package:openhiit/models/workout_type.dart';
import 'package:openhiit/utils/database/database_manager.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Workout> _workouts = [];

  List<Workout> get workouts => _workouts;

  Future<List<Workout>> loadWorkoutData() async {
    var dbManager = DatabaseManager();
    return dbManager.getWorkouts().then((workouts) {
      _workouts = workouts;
      return _workouts;
    }).whenComplete(() {
      notifyListeners();
    });
  }

  Future updateWorkout(Workout workout) async {
    var dbManager = DatabaseManager();
    return dbManager.updateWorkout(workout).then((_) {
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

  Future addWorkout(Workout workout) async {
    var dbManager = DatabaseManager();
    return dbManager.insertWorkout(workout).then((val) {
      _workouts.add(workout);
    }).whenComplete(() => notifyListeners());
  }

  Future deleteWorkout(Workout workout) async {
    var dbManager = DatabaseManager();
    return dbManager.deleteWorkout(workout.id).then((_) {
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

  void updateWorkoutIndices(int start) {
    for (var i = 0; i < _workouts.length; i++) {
      _workouts[i] = _workouts[i].copyWith(workoutIndex: start + i);
    }
    notifyListeners();
  }
}
