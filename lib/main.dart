import 'package:expense_tracker/data/local_data_storage.dart';
import 'package:expense_tracker/repositories/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized;

  await Hive.initFlutter();
  final box = await Hive.openBox('expenseBox');

  final storage = LocalDataStorage(hiveBox: box);

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
