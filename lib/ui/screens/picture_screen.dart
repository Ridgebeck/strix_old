import 'package:flutter/material.dart';
import 'package:strix/config/constants.dart';
import 'package:photo_view/photo_view.dart';

class PictureScreen extends StatelessWidget {
  static const String route_id = 'picture_screen';
  final String pictureString;

  PictureScreen({
    required this.pictureString,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     fit: BoxFit.scaleDown,
          //     image: AssetImage('assets/pictures/' + pictureString),
          //   ),
          // ),
          child: PhotoView(
            minScale: PhotoViewComputedScale.contained * 1.0,
            maxScale: PhotoViewComputedScale.covered * 2.5,
            initialScale: PhotoViewComputedScale.covered * 1.0,
            imageProvider: AssetImage('assets/data/' + pictureString),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10.0,
          left: MediaQuery.of(context).padding.left + 10.0,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: kAccentColor,
            splashColor: kBackgroundColorLight,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.navigate_before_sharp,
              color: Colors.black,
            ),
          ),
        ),
      ]),
    );
  }
}
