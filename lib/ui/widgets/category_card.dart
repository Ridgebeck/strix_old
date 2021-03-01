import 'package:flutter/material.dart';
import 'package:strix/config/constants.dart';
import 'package:strix/ui/screens/picture_screen.dart';

class CategoryCard extends StatelessWidget {
  final int numberOfCards;
  final BoxConstraints constraints;
  final String cardText;
  final double verticalMargin = 0.01;
  final double horizontalMargin = 0.04;
  CategoryCard({this.cardText, this.constraints, this.numberOfCards});

  static const cardTextStyle = TextStyle(color: kTextColorDark);

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
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            decoration: BoxDecoration(
              color: kCardColorLight,
            ),
            height: cardHeight,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: kSplashColor,
                onTap: () {
                  print('clicked');
                  Navigator.of(context).pushNamed(PictureScreen.route_id);
                },
              ),
            ),
          ),
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
    );
  }
}
