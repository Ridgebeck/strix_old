import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final int numberOfCards;
  final BoxConstraints constraints;
  final String cardText;
  final Color cardColor = Colors.blueGrey;
  final double verticalMargin = 0.01;
  final double horizontalMargin = 0.04;
  CategoryCard({this.cardText, this.constraints, this.numberOfCards});

  static const cardTextStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    final cardHeight =
        (constraints.maxHeight - (numberOfCards * 2 * verticalMargin * constraints.maxHeight)) /
            (numberOfCards);
    final cardWidth = constraints.maxWidth - 2 * horizontalMargin;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth * horizontalMargin,
          vertical: constraints.maxHeight * verticalMargin),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Stack(children: [
            Container(
              height: cardHeight,
              color: cardColor.withOpacity(0.5),
            ),
            Positioned(
              left: cardHeight * 0.15,
              top: cardHeight * 0.15,
              child: Text(
                cardText,
                style: cardTextStyle,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
