import 'package:budget/db/category/category_db.dart';
import 'package:budget/db/transactions/transaction_db.dart';
import 'package:budget/models/categories/model_category.dart';
import 'package:budget/models/transactions/transaction_add_model.dart';
import 'package:flutter/material.dart';

class ScreenAddTransaction extends StatefulWidget {
  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

String? hinter;
CategoryModel? selectedModel;

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _dateSelected;
  final purposeControl = TextEditingController();
  final amountControl = TextEditingController();

  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              TextFormField(
                controller: amountControl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'Amount ₹',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: purposeControl,
                decoration: const InputDecoration(
                  hintText: 'Purpose of Transaction',
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                TextButton.icon(
                  onPressed: () async {
                    var selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 39)),
                      lastDate: DateTime.now(),
                    );
                    setState(() {
                      _dateSelected = selectedDate;
                      _dateSelected ??= DateTime.now();
                    });
                  },
                  // ignore: prefer_const_constructors
                  icon: Icon(size: 30, Icons.calendar_month),
                  label: Text(
                      style: const TextStyle(fontSize: 20),
                      _dateSelected == null
                          ? 'Select Date of Transaction'
                          : _dateSelected
                              .toString()
                              .characters
                              .take(10)
                              .toString()),
                ),
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: const [            
                  
                  TransactionRadioButton(
                      title: 'Income', type: CategoryType.income),
                      SizedBox(width: 50,),
                  TransactionRadioButton(
                      title: 'Expense', type: CategoryType.expense),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const SizedBox(width: 20,),
                  ValueListenableBuilder(
                          valueListenable: transactionCategory,
                          builder:
                              (BuildContext ctx, CategoryType newvalue, Widget? _) {
                            if (transactionCategory.value == CategoryType.income) {
                              return DropdownButton(
                                  hint: Text(
                                      hinter == null ? 'Select Category' : hinter!),
                                  items: CategoryDB
                                      .instance.incomeCategoryList.value
                                      .map((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name),
                                    );
                                  }).toList(),
                                  onChanged: (CategoryModel? selectedvalue) {
                                    setState(() {
                                      selectedModel = selectedvalue;
                                      hinter = selectedvalue?.name;
                                    });
                                  });
                            } else {
                              return DropdownButton(
                                  hint: Text(
                                      hinter == null ? 'Select Category' : hinter!),
                                  items: CategoryDB
                                      .instance.expenseCategoryList.value
                                      .map((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name),
                                    );
                                  }).toList(),
                                  onChanged: (CategoryModel? selectedvalue) {
                                    setState(() {
                                      selectedModel = selectedvalue;
                                      hinter = selectedvalue?.name;
                                    });
                                  });
                            }
                          }),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        addTransaction(cxt);
                        
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Submit')),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }

  addTransaction(BuildContext cxt) async {
    final purposeText = purposeControl.text.trim();
    final amountText = amountControl.text.trim();
    final parsed = double.tryParse(amountText);
    if (purposeText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.red,
          content: Text('Please Enter a Valid Purpose of Transaction')));
      return;
    }
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.red,
          content: Text('Please Enter a Valid Amount')));
      return;
    }
    if (_dateSelected == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.red,
          content: Text('Please Choose the Date of Transaction')));
      return;
    }
    if (selectedModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.red,
          content: Text('Please Select A Category')));
      return;
    }
    if (parsed == null ||
        parsed.isNaN ||
        parsed.isNegative ||
        parsed.isInfinite) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.red,
          content: Text('Please Enter a Valid Amount')));
      return;
    }
    final model = TransactionModel(
      amount: parsed,
      date: _dateSelected!,
      purpose: purposeText,
      transactiontype: transactionCategory.value,
      transactionmodel: selectedModel!,
    );
    TransactionDB.instance.addtransation(model);
    Navigator.pop(cxt);
    TransactionDB.instance.refresh();
  }
}

ValueNotifier<CategoryType> transactionCategory =
    ValueNotifier(CategoryType.income);

class TransactionRadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  const TransactionRadioButton(
      {Key? key, required this.title, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: transactionCategory,
          builder: (BuildContext ctx, CategoryType newcategory, _) {
            return Radio<CategoryType>(
              value: type,
              groupValue: transactionCategory.value,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedModel = null;
                hinter = null;
                transactionCategory.value = value;
              },
            );
          },
        ),
        Text(title),
      ],
    );
  }
}
