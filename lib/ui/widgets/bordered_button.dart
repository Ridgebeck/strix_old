import 'package:flutter/material.dart';

class BorderedButton extends StatelessWidget {
  final String? buttonText;
  final double fontSize;
  final Color buttonColor;
  BorderedButton({this.buttonText, this.fontSize = 15.0, this.buttonColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 110.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1), border: Border.all(color: buttonColor)),
      child: Text(
        buttonText!,
        style: TextStyle(
          color: buttonColor,
          fontSize: fontSize,
          fontFamily: 'Raleway',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
