import 'package:budget/models/categories/model_category.dart';
import 'package:budget/models/transactions/transaction_add_model.dart';
import 'package:budget/screens/home/screen_home.dart';
import 'package:budget/screens/transactions/add_transaction.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lodogo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: ScreenHome(),
      routes: {
       'AddTransaction' : (ctx) =>const ScreenAddTransaction()
      },
    );
  }
}
