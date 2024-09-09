import 'package:flutter/material.dart';
import 'package:openhiit/models/timer_type.dart';

class TimerProvider extends ChangeNotifier {

  List<IntervalTimer>

  List<ExpenseData> _expenses = [];

  List<ExpenseData> get expenses => _expenses;

  Future loadExpenseData() async {
    var dbManager = DatabaseManager();
    return dbManager.getAllExpenses().then((entries) {
      if (entries != null) {
        _expenses = entries;
      }
    }).whenComplete(() {
      notifyListeners();
    });
  }

  Future updateExpense(ExpenseData e) {
    var dbManager = DatabaseManager();
    return dbManager.updateExpense(e).then((_) {
      var updated = false;
      for (var i = 0; i < _expenses.length; i++) {
        if (_expenses[i].id == e.id) {
          _expenses[i] = e.copy();
          updated = true;
          break;
        }
      }
      if (!updated) {
        throw Exception('Unable to find expense with ID: ${e.id}');
      }
    }).whenComplete(() => notifyListeners());
  }

  Future addExpense(ExpenseData e) {
    var dbManager = DatabaseManager();
    return dbManager.insertExpense(e).then((id) {
      // Populate the ID value of the object.
      e.id = id;
      _expenses.add(e);
    }).whenComplete(() => notifyListeners());
  }

  Future deleteExpense(ExpenseData e) {
    var dbManager = DatabaseManager();
    return dbManager.deleteExpense(e.id).then((_) {
      _expenses.removeWhere((expense) => expense.id == e.id);
    }).whenComplete(() => notifyListeners());
  }

  void sort<T>(
    Comparable<T> Function(ExpenseData d) getField,
    bool ascending,
  ) {
    expenses.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }
}
