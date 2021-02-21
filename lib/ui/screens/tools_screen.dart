import 'package:flutter/material.dart';
import 'package:strix/ui/widgets/category_card.dart';

class ToolsScreen extends StatelessWidget {
  final int numberOfCards = 4;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          CategoryCard(
            cardText: 'browser',
            constraints: constraints,
            numberOfCards: numberOfCards,
          ),
          CategoryCard(
            cardText: 'map',
            constraints: constraints,
            numberOfCards: numberOfCards,
          ),
          CategoryCard(
            cardText: 'enhancer',
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
