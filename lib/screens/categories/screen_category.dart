import 'package:budget/screens/categories/expense_category_list.dart';
import 'package:budget/screens/categories/income_category_list.dart';
import 'package:flutter/material.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({Key? key}) : super(key: key);

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabcontroller;

  @override
  void initState() {
    _tabcontroller = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          controller: _tabcontroller,
          tabs: [
          Tab(
            text: 'Income',
          ),
          Tab(
            text: 'Expense',
          ),
        ],),
        Expanded(
          child: TabBarView(
            controller: _tabcontroller,
            children: const [
            IncomeList(),
            ExpenseList()
          ],),
        )
        
      ],
    );
  }
}
