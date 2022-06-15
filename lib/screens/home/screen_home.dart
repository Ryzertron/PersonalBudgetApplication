import 'package:budget/screens/categories/category_add_popup.dart';
import 'package:budget/screens/categories/screen_category.dart';
import 'package:budget/screens/home/widgets/bottom_navigation_bar.dart';
import 'package:budget/screens/transactions/add_transaction.dart';
import 'package:budget/screens/transactions/screen_transaction.dart';
import 'package:flutter/material.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedindex = ValueNotifier(0);
  final _pages = [
    const ScreenTransaction(),
    const ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        appBar: AppBar(
          title: const Text('Lodogo'),
          centerTitle: true,
          toolbarHeight: 80,
        ),
        bottomNavigationBar: const BottomNavigatorWidget(),
        body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: selectedindex,
              builder: (BuildContext context, int updatedindex, _) {
                return _pages[updatedindex];
              }),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (selectedindex.value == 0) {
                Navigator.pushNamed(context, 'AddTransaction');
                hinter = null;
              } else {
                showCategoryAdd(context);
              }
            },
            child: const Icon(Icons.add)),
      ),
    );
  }
}
