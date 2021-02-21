import 'package:flutter/material.dart';

class BottomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function onItemTapped;
  BottomTabBar({
    @required this.selectedIndex,
    @required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cloud),
          label: 'Data',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Tools',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: (value) {
        onItemTapped(value);
      },
    );
  }
}
