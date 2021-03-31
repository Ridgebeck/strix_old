import 'package:flutter/material.dart';

class TopIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Container()),
        Expanded(
          flex: 5,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.maxHeight, // + constraints.maxWidth * 0.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/pictures/owl_strix_v4.png'),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
