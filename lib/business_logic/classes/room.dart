import 'package:flutter/material.dart';
import 'player.dart';

class Room {
  String gameTitle;
  String roomID;
  String gameProgress;
  List<Player> players;
  int minimumPlayers;
  int maximumPlayers;
  DateTime opened;
  DateTime started;

  Room({
    @required this.gameTitle,
    @required this.roomID,
    @required this.gameProgress,
    @required this.players,
    @required this.minimumPlayers,
    @required this.maximumPlayers,
    this.opened,
    this.started,
  });
}
