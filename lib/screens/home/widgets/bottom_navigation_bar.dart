import 'package:budget/screens/home/screen_home.dart';
import 'package:flutter/material.dart';

class BottomNavigatorWidget extends StatelessWidget {
  const BottomNavigatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedindex,
      builder: (BuildContext ctx, int updatedindex, Widget? _) {
        return BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            currentIndex: updatedindex,
            onTap: (newIndex) {
              ScreenHome.selectedindex.value = newIndex;
            },
            items: const [
               BottomNavigationBarItem(
                  icon: Icon(Icons.currency_exchange), label: 'Transactions'),
               BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Categories')
            ]);
      },
    );
  }
}
