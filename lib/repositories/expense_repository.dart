import 'package:expense_tracker/data/local_data_storage.dart';
import 'package:expense_tracker/models/expense_model.dart';

class ExpenseRepository {
  final LocalDataStorage _storage;

  const ExpenseRepository({required this._storage});

  Future<void> createExpense(Expense expense) => _storage.saveExpense(expense);

  Future<void> deleteExpense(String id) => _storage.deleteExpense(id);

  Stream<List<Expense?>> getAllExpenses() => _storage.getExpenses();
}
