import 'package:flutter/material.dart';
import 'package:strix/config/constants.dart';

class PictureCard extends StatelessWidget {
  final BoxConstraints constraints;
  final String imageString;
  final String cardTitle;
  final String cardDescription;
  final double cardHeight = 120.0;
  final double verticalMargin = 0.01;
  final double horizontalMargin = 0.04;
  PictureCard({
    @required this.constraints,
    @required this.imageString,
    @required this.cardTitle,
    @required this.cardDescription,
  });

  static const cardTextStyle = TextStyle(color: kTextColorDark);

  @override
  Widget build(BuildContext context) {
    // final cardHeight =
    //     (constraints.maxHeight - (numberOfCards * 2 * verticalMargin * constraints.maxHeight)) /
    //         (numberOfCards);
    // final cardWidth = constraints.maxWidth - 2 * horizontalMargin;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth * horizontalMargin,
          vertical: constraints.maxHeight * verticalMargin),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          color: kCardColorLight,
          height: cardHeight,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: kSplashColor,
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    width: cardHeight,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/pictures/$imageString'),
                        fit: BoxFit.cover,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Expanded(
                    flex: 10,
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Text(cardTitle),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Text(cardDescription),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
