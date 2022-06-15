import 'package:budget/models/categories/model_category.dart';
import 'package:hive_flutter/adapters.dart';
part 'transaction_add_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  final String purpose;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final CategoryType transactiontype;
  @HiveField(4)
  final CategoryModel transactionmodel;
  @HiveField(5)
  String? id;

  TransactionModel( 
     { required this.transactionmodel,
      required this.purpose,
      required this.amount,
      required this.date,
      required this.transactiontype}){id = DateTime.now().millisecondsSinceEpoch.toString();}
}
