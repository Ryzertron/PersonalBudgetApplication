import 'package:budget/models/transactions/transaction_add_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: constant_identifier_names
const transaction_db_name = 'transaction-database';

abstract class TransactionDbFunctions {
  Future<List<TransactionModel>> getTransaction();
  addtransation(TransactionModel model);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionNotifier = ValueNotifier([]);
  @override
  addtransation(TransactionModel model) async {
    final db = await Hive.openBox<TransactionModel>(transaction_db_name);
    await db.put(model.id, model);
  }

  refresh() async {
    final list = await getTransaction();
    list.sort((first, second) => second.date.compareTo(first.date));
    transactionNotifier.value.clear();
    transactionNotifier.value.addAll(list);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    transactionNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getTransaction() async {
    final db = await Hive.openBox<TransactionModel>(transaction_db_name);
    return db.values.toList();
  }
}
