import 'package:flutter/material.dart';
import 'package:strix/ui/widgets/category_card.dart';
import 'package:strix/ui/widgets/screen_header.dart';

class DataScreen extends StatelessWidget {
  final int numberOfCards = 4;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 11,
          child: ScreenHeader(
            title: 'data',
            iconData: Icons.cloud_outlined,
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
