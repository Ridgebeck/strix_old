import 'dart:ui' show Color;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String kRoomsCollection = 'activeRooms';
const String kSettingsReference = 'settings'; // used for collection name and field name
const String kRoomIDField = 'roomID';
const String kGameIDField = 'gameID';
const String kHostField = 'host';
const String kPlayersField = 'players';
const String kGameStatusField = 'gameProgress';
const String kSettingsStatusField = 'availableAssets'; // change to gameProgress
const String kOpenedField = 'opened';
const String kChatField = 'chat';
const String kChatMessagesField = 'messages';

// TODO: replace with enum?
const String kWaitingStatus = 'waiting';

// TODO: replace with selectable ID from UI (for more than one game)?
const selectedGameID = 1;

const Color kBackgroundColor = Color.fromRGBO(230, 230, 235, 1.0);
const Color kBackgroundColorLight = Color.fromRGBO(238, 238, 245, 1.0);
const Color kCardColorLight = Color.fromRGBO(255, 255, 255, 1.0);
const Color kAccentColor = Color.fromRGBO(252, 3, 173, 1.0);
const Color kSplashColor = Color.fromRGBO(252, 3, 173, 1.0);
const Color kTextColorDark = Color.fromRGBO(60, 60, 60, 1.0);
const TextStyle kTextStyle = TextStyle(fontSize: 15, color: Colors.white);

const List<BoxShadow> kCardShadow = [
  BoxShadow(
    color: Colors.blueGrey,
    blurRadius: 3.0,
    spreadRadius: 1.0,
    offset: Offset(0.5, 0.5),
  ),
  BoxShadow(
    color: Colors.white,
    blurRadius: 3.0,
    spreadRadius: 1.0,
    offset: Offset(-0.5, -0.5),
  ),
];

enum canLeave {
  yes,
  no,
  lastPlayer,
  error,
}
