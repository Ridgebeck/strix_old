import 'package:flutter/material.dart';

class Player {
  String name;
  String uid;
  Color color;
  String image;

  Player({
    @required this.name,
    this.uid,
    this.color,
    this.image,
  });
}
