import 'package:flutter/material.dart';
import 'player.dart';

class Room {
  String gameTitle;
  String roomID;
  List<Player> players;
  DateTime opened;
  DateTime started;

  Room({
    @required this.gameTitle,
    @required this.roomID,
    this.players,
    this.opened,
    this.started,
  });
}
