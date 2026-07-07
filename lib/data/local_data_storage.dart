import 'dart:convert';

import 'package:expense_tracker/models/expense_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataStorage {
  LocalDataStorage({required this._preferences}) {
    _initialize();
  } // Using initializing formal here

  static const expenseCollectionKey = 'expenses_collection_key';

  final SharedPreferences _preferences;
  final _controller = BehaviorSubject<List<Expense?>>.seeded(const []);

  void _initialize() {
    final expenseJson = _preferences.getString(expenseCollectionKey);
    if (expenseJson != null) {
      final expenseList = List<dynamic>.from(jsonDecode(expenseJson) as List);
      final expenses = expenseList
          .map((expense) => Expense.fromJson(expense))
          .toList();
      _controller.add(expenses);
    } else {
      _controller.add(const []);
    }
  }

  //get expenses List
  Stream<List<Expense?>> getExpenses() => _controller.asBroadcastStream();

  //save or update an expense
  Future<void> saveExpense(Expense expense) async {
    final expenses = [..._controller.value];
    final expenseIndex = expenses.indexWhere(
      (currentExpense) => currentExpense?.id == expense.id,
    );

    if (expenseIndex > 0) {
      expenses[expenseIndex] = expense;
    } else {
      expenses.add(expense);
    }
    // expenses.add(expense);

    _controller.add(expenses);

    await _preferences.setString(expenseCollectionKey, jsonEncode(expenses));
  }

  Future<void> deleteExpense(String id) async {
    final expenses = [..._controller.value];
    final expenseIndex = expenses.indexWhere(
      (currentExpense) => currentExpense?.id == id,
    );
    if (expenseIndex == -1) {
      throw Exception('Noexpense Found');
    } else {
      expenses.removeAt(expenseIndex);
      _controller.add(expenses);
      await _preferences.setString(expenseCollectionKey, jsonEncode(expenses));
    }
  }
}
