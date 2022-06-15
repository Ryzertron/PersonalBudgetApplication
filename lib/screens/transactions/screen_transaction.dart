import 'package:budget/db/category/category_db.dart';
import 'package:budget/db/transactions/transaction_db.dart';
import 'package:budget/models/categories/model_category.dart';
import 'package:budget/models/transactions/transaction_add_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refresh();
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newlist, Widget? _) {
          return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final value = newlist[index];
                return Slidable(
                  key: Key(value.id!),
                  startActionPane:
                      ActionPane(motion: const DrawerMotion(), children: [
                    SlidableAction(
                      onPressed: (BuildContext ctx) {
                        TransactionDB.instance.deleteTransaction(value.id!);
                      },
                      icon: Icons.delete_forever_sharp,
                      backgroundColor: Colors.red,
                    )
                  ]),
                  child: Card(
                    elevation: 0,
                    child: ListTile(
                      leading:
                          Text('${value.date.toString().characters.take(10)}'),
                      title: Text(
                        '₹.${value.amount}',
                        style: TextStyle(
                            color: typeCheck(value.transactiontype),
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(value.transactionmodel.name),
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: newlist.length);
        });
  }

  Color? typeCheck(CategoryType type) {
    if (type == CategoryType.income) {
      return Colors.green;
    }
    if (type == CategoryType.expense) {
      return Colors.red;
    } else {
      return null;
    }
  }
}
