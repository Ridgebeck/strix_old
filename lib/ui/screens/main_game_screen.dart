import 'package:flutter/material.dart';

import 'package:strix/ui/widgets/bottom_tab_bar.dart';
import 'home_screen.dart';
import 'data_screen.dart';
import 'tools_screen.dart';

class MainGameScreen extends StatefulWidget {
  static const String route_id = 'main_game_screen';

  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    DataScreen(),
    ToolsScreen(),
  ];

  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomTabBar(
        selectedIndex: _selectedIndex,
        onItemTapped: changeIndex,
      ),
    );
  }
}
