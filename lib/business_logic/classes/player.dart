import 'package:flutter/material.dart';

class Player {
  String name;
  String uid;
  Color color;
  IconData iconData;

  Player({
    @required this.name,
    this.uid,
    this.color,
    this.iconData,
  });
}
