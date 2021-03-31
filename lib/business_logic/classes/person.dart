import 'package:flutter/material.dart';

class Person {
  String firstName;
  String lastName;
  String title;
  String profileImage;
  Color? color;

  Person({
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.profileImage,
    this.color,
  });
}
