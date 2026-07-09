import 'package:expense_tracker/data/local_data_storage.dart';
import 'package:expense_tracker/repositories/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized;

  final storage = LocalDataStorage(
    preferences: await SharedPreferences.getInstance(),
  );

  final expenseRepository = ExpenseRepository(storage: storage);
  runApp(ExpenseTrackerApp(expenseRepository: expenseRepository));
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key, required this.expenseRepository});
  final ExpenseRepository expenseRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: expenseRepository,
      child: const MaterialApp(
        home: Scaffold(body: Center(child: Text('Hello World!'))),
      ),
    );
  }
}
