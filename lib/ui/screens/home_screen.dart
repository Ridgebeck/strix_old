import 'package:flutter/material.dart';
import 'package:strix/ui/widgets/screen_header.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 11,
          child: ScreenHeader(
            title: 'mission',
            iconData: Icons.home_outlined,
          ),
        ),
        Expanded(
          flex: 89,
          child: Container(
              //color: Colors.green,
              ),
        ),
      ],
    );
  }
}
