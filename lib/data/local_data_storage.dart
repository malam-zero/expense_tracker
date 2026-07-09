import 'package:expense_tracker/models/expense_model.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/subjects.dart';

class LocalDataStorage {
  LocalDataStorage({required this.hiveBox}) {
    _initialize();
  } // Using initializing formal here

  static const expenseCollectionKey = 'expenses_collection_key';

  final Box hiveBox;
  final _controller = BehaviorSubject<List<Expense?>>.seeded(const []);

  void _initialize() {
    // Hive returns the actual List of Expense objects directly!
    final expenses = hiveBox.get(expenseCollectionKey, defaultValue: []);
    _controller.add(List<Expense?>.from(expenses));
  }

  Future<void> saveExpense(Expense expense) async {
    final expenses = [..._controller.value];
    final expenseIndex = expenses.indexWhere((e) => e?.id == expense.id);

    if (expenseIndex != -1) {
      expenses[expenseIndex] = expense;
    } else {
      expenses.add(expense);
    }

    _controller.add(expenses);
    // Store the actual list object, no JSON strings needed
    await hiveBox.put(expenseCollectionKey, expenses);
  }

  Stream<List<Expense?>> getExpenses() => _controller.asBroadcastStream();

  Future<void> deleteExpense(String id) async {
    final expenses = [..._controller.value];
    final expenseIndex = expenses.indexWhere((e) => e?.id == id);

    if (expenseIndex == -1) throw Exception('No expense Found');

    expenses.removeAt(expenseIndex);
    _controller.add(expenses);
    await hiveBox.put(expenseCollectionKey, expenses);
  }
}
