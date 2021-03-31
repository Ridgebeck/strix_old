import 'package:flutter/material.dart';
import 'package:strix/config/constants.dart';

class BottomTabBar extends StatelessWidget {
  final TabController tabController;
  BottomTabBar(this.tabController);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: kAccentColor,
      controller: tabController,
      tabs: [
        Tab(
          text: 'Home',
          icon: Icon(Icons.home_outlined),
        ),
        Tab(
          text: 'Data',
          icon: Icon(Icons.cloud_outlined),
        ),
        Tab(
          text: 'Tools',
          icon: Icon(Icons.handyman_outlined),
        ),
        Tab(
          text: 'Chat',
          icon: Icon(Icons.chat_bubble_outline),
        ),
      ],
    );
  }
}
