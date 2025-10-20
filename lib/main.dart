import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_expense_tracker/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open a box (like a table)
  await Hive.openBox('expenses');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String title;
  final double amount;

  const MyApp({super.key, this.title = '', this.amount = 0.0});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const FirstPage(
        title: '',
        amount: 0.0,
        totalAdd: 0.0,
        totalCost: 0.0,
      ),
    );
  }
}
