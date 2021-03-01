import 'package:flutter/material.dart';
import 'package:strix/config/constants.dart';
import 'package:strix/ui/widgets/picture_card.dart';

class PictureScreen extends StatelessWidget {
  static const String route_id = 'picture_screen';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        backgroundColor: kBackgroundColorLight,
        body: SafeArea(
          child: Stack(children: [
            ListView(
              children: [
                Container(
                  height: 55.0,
                ),
                PictureCard(
                  constraints: constraints,
                  imageString: 'pic1.jpg',
                  cardTitle: 'Fingerprints on Vase',
                  cardDescription: 'de Young Museum, Art of the Americas hall ',
                ),
                PictureCard(
                  constraints: constraints,
                  imageString: 'pic2.jpg',
                  cardTitle: 'Title 2',
                  cardDescription: 'Description 2',
                ),
                PictureCard(
                  constraints: constraints,
                  imageString: 'pic3.jpg',
                  cardTitle: 'Title 3',
                  cardDescription: 'Description 3',
                ),
              ],
            ),
            Positioned(
              top: 10.0,
              left: 10.0,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: kAccentColor,
                splashColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.navigate_before_sharp),
              ),
            ),
          ]),
        ),
      );
    });
  }
}
