import 'package:flutter/material.dart';
import 'package:strix/ui/widgets/category_card.dart';

class DataScreen extends StatelessWidget {
  final int numberOfCards = 4;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          CategoryCard(
            cardText: 'PICTURES',
            constraints: constraints,
            numberOfCards: numberOfCards,
          ),
          CategoryCard(
            cardText: 'AUDIO FILES',
            constraints: constraints,
            numberOfCards: numberOfCards,
          ),
          CategoryCard(
            cardText: 'VIDEOS',
            constraints: constraints,
            numberOfCards: numberOfCards,
          ),
          CategoryCard(
            cardText: 'others',
            constraints: constraints,
            numberOfCards: numberOfCards,
          ),
        ],
      );
    });
  }
}
