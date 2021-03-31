import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/call.dart';
import 'package:strix/business_logic/classes/chat.dart';
import 'package:strix/business_logic/classes/hex_color.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/business_logic/classes/player.dart';
import 'package:strix/business_logic/classes/person.dart';
import 'package:strix/ui/screens/briefing_screen.dart';
import 'game_doc_abstract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strix/services/service_locator.dart';
import 'package:strix/services/authorization/authorization_abstract.dart';
import 'package:strix/config/constants.dart';

// interaction with room document on Firestore
class GameDocFirestore implements GameDoc {
  final Authorization _authorization = serviceLocator<Authorization>();
  // Create a CollectionReference that references the firestore rooms and settings collections
  final CollectionReference rooms = FirebaseFirestore.instance.collection(kRoomsCollection);
  final CollectionReference settings = FirebaseFirestore.instance.collection(kSettingsReference);

  @override
  Future<String?> addNewRoom({required String roomID}) async {
    // try to get document from rooms collection with random room ID
    return await rooms.doc(roomID).get().then((docSnapshot) async {
      // check if document with roomID already exists
      if (docSnapshot.exists) {
        print('Document already exists!');
        return null;
      }
      // document does not exist yet, proceed
      else {
        // try to fetch settings document
        // TODO: replace gameData with (selectable) gameID
        DocumentSnapshot settingsSnapshot = await settings.doc('gameData').get();

        // create first player entry
        Map<String, dynamic> firstPlayerValues = settingsSnapshot[kPlayersField][0];
        Map<String, dynamic> playerEntry = {
          'uid': _authorization.getCurrentUserID(),
          'name': firstPlayerValues['name'],
          'iconNumber': firstPlayerValues['iconNumber'],
          'color': firstPlayerValues['color'],
        };

        // try to create document with roomID
        await rooms.doc(roomID).set({
          kRoomIDField: roomID,
          kGameIDField: settingsSnapshot.get(kGameIDField),
          kOpenedField: DateTime.now(),
          kPlayersField: [playerEntry],
          kGameStatusField: kWaitingStatus,
          kSettingsReference: settingsSnapshot.data(),
          kChatField: {'messages': []},
        });
        return roomID;
      }
    }).catchError((e) {
      print('Error while trying to create new room: $e');
      return null;
    });
  }

  @override
  Stream<Room?> getDocStream({required String roomID}) {
    print('trying to start stream!');
    // Stream of Document Snapshots from database
    Stream<DocumentSnapshot> docRefStream =
        FirebaseFirestore.instance.collection(kRoomsCollection).doc(roomID).snapshots();

    // return converted string
    return docRefStream.map((docSnap) => docSnapToRoom(docSnap));
  }

  Room? docSnapToRoom(DocumentSnapshot docSnap) {
    try {
      Map<String, dynamic>? snapData = docSnap.data();
      // check if snapshot has data
      if (!docSnap.exists || snapData == null) {
        return null;
      } else {
        print('CONVERTING STREAM DATA! ${snapData['gameID']}');

        // convert player list into standardized format
        List<Player> playerList = [];
        for (int i = 0; i < snapData[kPlayersField].length; i++) {
          Map<String, dynamic> currentPlayer = snapData[kPlayersField][i];

          playerList.add(
            Player(
              uid: currentPlayer['uid'],
              name: currentPlayer['name'],
              color: HexColor.fromHex(currentPlayer['color']),
              iconData: IconData(currentPlayer['iconNumber'], fontFamily: 'MaterialIcons'),
            ),
          );
        }

        // convert chat messages into standardized format
        Chat chat = _convertChatData(snapData[kChatField]);

        // convert available assets into standardized format
        List<AvailableAssetEntry> availableAssets = _convertAvailableAssets(snapData);

        // convert all values into room class
        Room currentRoomData = Room(
          gameTitle: snapData[kSettingsReference]['gameTitle'],
          roomID: snapData[kRoomIDField],
          gameProgress: snapData[kGameStatusField],
          players: playerList,
          minimumPlayers: snapData[kSettingsReference]['minimumPlayers'],
          maximumPlayers: snapData[kSettingsReference]['maximumPlayers'],
          opened: snapData['opened'].toDate(),
          chat: chat,
          started: snapData['started'],
          availableAssets: availableAssets, //snapData[kSettingsReference][kSettingsStatusField],
          host: snapData['host'],
        );
        return currentRoomData;
      }
    } catch (e) {
      print('Error while trying to create room data from stream.');
      print('Error: $e');
      return null;
    }
  }

  List<AvailableAssetEntry> _convertAvailableAssets(Map<String, dynamic> snapData) {
    List<AvailableAssetEntry> availableAssets = [];

    List<dynamic> availableAssetsRaw = snapData[kSettingsReference][kSettingsStatusField];
    // go through all entries in list
    for (Map<String, dynamic> milestone in availableAssetsRaw) {
      AvailableAssetEntry assetEntry = AvailableAssetEntry();

      milestone.forEach((name, value) {
        // save entry name
        assetEntry.entryName = name;

        // convert call if there is one
        if (value.containsKey('call')) {
          Map<String, dynamic> callMap = snapData[kSettingsReference]['calls'][value['call']];
          Map<String, dynamic> callerMap =
              snapData[kSettingsReference]['protagonists'][callMap['person']];
          Person caller = Person(
            firstName: callerMap['firstName'],
            lastName: callerMap['lastName'],
            profileImage: callerMap['profileImage'],
            title: callerMap['title'],
          );
          Call currentCall = Call(
            callFile: callMap['callFile'],
            person: caller,
          );
          assetEntry.call = currentCall;
        }

        // convert picture list if there is one
        if (value.containsKey('pictures')) {
          assetEntry.pictures = List.from(value['pictures']);
        }

        // convert audio file list if there is one
        if (value.containsKey('audioFiles')) {
          assetEntry.audioFiles = List.from(value['audioFiles']);
        }

        // convert archived calls if there are any
        if (value.containsKey('archivedCalls')) {
          print('archived calls found!');
          //assetEntry.pictures = List.from(value['pictures']);
          // todo: convert to List<Call>
        }
      });
      availableAssets.add(assetEntry);
    }
    return availableAssets;
  }

  Chat _convertChatData(Map<String, dynamic> chatData) {
    List<Message> chatList = [];
    print('CONVERTING CHAT');

    print('messages: ${chatData[kChatMessagesField].length}');

    for (int i = 0; i < chatData[kChatMessagesField].length; i++) {
      try {
        Map<String, dynamic> currentMessage = chatData[kChatMessagesField][i];
        Map<String, dynamic> currentAuthor = currentMessage['author'];

        Person? currentPerson;
        Player? currentPlayer;

        // check if author is player or person
        if (currentAuthor['uid'] != null) {
          currentPlayer = Player(
            name: currentAuthor['name'],
            uid: currentAuthor['uid'],
            color: HexColor.fromHex(currentAuthor['color']),
            iconData: IconData(currentAuthor['iconNumber'], fontFamily: 'MaterialIcons'),
          );
        } else {
          currentPerson = Person(
            firstName: 'Russ',
            //currentAuthor['firstName'],
            lastName: 'Hanneman',
            //currentAuthor['lastName'],
            title: 'Field Agent',
            //currentAuthor['title'],
            profileImage: 'test.jpg',
            //currentAuthor['profileImage'],
            color: Colors.red, //HexColor.fromHex(currentAuthor['color']),
          );
        }

        chatList.add(
          Message(
            text: currentMessage['text'],
            author: currentPlayer != null ? currentPlayer : currentPerson,
            time: currentMessage['time'].toDate(),
          ),
        );
      } catch (e) {
        print('Could not convert message. Error: $e');
      }
    }
    return Chat(messages: chatList);
  }

  @override
  Future<String?> joinRoom({required String roomID}) async {
    // change document safely in a transaction
    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(rooms.doc(roomID));
      Map<String, dynamic>? snapData = snapshot.data();
      // check if document exists and data is not null
      if (snapData == null || !snapshot.exists) {
        return null;
      } else {
        // check if player count is below limit
        List<Map<String, dynamic>> playersList = List.from(snapData['players']);

        print('PLAYER LIST: $playersList');
        print('UID: ${_authorization.getCurrentUserID()}');

        if (playersList.length >= snapData['settings']['maximumPlayers']) {
          // return error String
          return 'full';
        } else {
          // get current user ID
          String uid = _authorization.getCurrentUserID();

          // check if player (uid) is already in the room
          for (Map<String, dynamic> playerEntry in playersList) {
            if (playerEntry['uid'] == uid) {
              print('Player already in room. Joining.');
              return roomID;
            }
          }

          // if player is not in the room and status is waiting
          if (snapData[kGameStatusField] == kWaitingStatus) {
            // find corresponding player data
            Map<String, dynamic> playerData =
                snapData[kSettingsReference][kPlayersField][playersList.length];

            // add new player with uid and copied player data
            Map<String, dynamic> playerEntry = {
              'uid': uid,
              'name': playerData['name'],
              'iconNumber': playerData['iconNumber'],
              'color': playerData['color'],
            };
            playersList.add(playerEntry);

            // update player list on the document
            transaction.update(rooms.doc(roomID), {
              'players': playersList,
            });
            return roomID;
          } else {
            return null;
          }
        }
      }
    }).then((value) {
      // return roomID if everything works out
      return value;
      // otherwise return null
    }).catchError((e) {
      print('Error while trying to join a room: $e');
      return null;
    });
  }

  @override
  leaveRoom({
    required String roomID,
    required BuildContext context,
    required AnimationController animationController,
  }) async {
    // change document safely in a transaction
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(rooms.doc(roomID));
      Map<String, dynamic>? snapData = snapshot.data();

      // check if document exists
      if (!snapshot.exists || snapData == null) {
        print("Error: game does not exist or has no data!");
        // todo: error handling?
      }
      // check if game has already been started
      else if (snapData[kGameStatusField] != kWaitingStatus) {
        print("Game has been started already!");
      }
      // otherwise leave the room
      else {
        // get current user ID
        String uid = _authorization.getCurrentUserID();
        // get list of players
        List<Map<String, dynamic>> playersList = List.from(snapData['players']);

        // check if last participant is leaving
        if (playersList.length == 1) {
          print('last player leaving');
          // leave page
          animationController.animateTo(0.0);
          Navigator.of(context).pushReplacementNamed(BriefingScreen.route_id);

          // delete complete document after page has been left
          await Future.delayed(Duration(seconds: 3));
          // todo: delete after leaving room
          transaction.delete(rooms.doc(roomID));
        } else {
          print('participant leaving');
          // remove player from list
          playersList.removeWhere((playerEntry) => playerEntry['uid'] == uid);
          // TODO: error handling if uid is not found?

          // update other player data in case the order changed
          List<Map<String, dynamic>> playerDataList =
              List.from(snapData[kSettingsReference][kPlayersField]);

          for (int i = 0; i < playersList.length; i++) {
            playersList[i] = {
              'uid': playersList[i]['uid'],
              'name': playerDataList[i]['name'],
              'iconNumber': playerDataList[i]['iconNumber'],
              'color': playerDataList[i]['color'],
            };
          }
          // leave page
          animationController.animateTo(0.0);
          Navigator.of(context).pushReplacementNamed(BriefingScreen.route_id);

          // perform an update on the document after page has been left
          await Future.delayed(Duration(seconds: 2));
          transaction.update(rooms.doc(roomID), {
            'players': playersList,
          });
        }
      }
    });
  }

  @override
  Future<bool> startGame({required String roomID}) async {
    // change document safely in a transaction
    //todo: return value to logic?
    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(rooms.doc(roomID));
      Map<String, dynamic>? snapData = snapshot.data();

      // check if document exists and data is not null
      if (!snapshot.exists || snapData == null) {
        print("Error: game does not exist!");
        return false;
      }
      // check if game has already been started
      else if (snapData[kGameStatusField] != kWaitingStatus) {
        // todo: return specific value?
        return true;
      } else {
        // check if enough players are in the room
        try {
          int numberPlayers = snapData['players'].length;
          int minimumPlayers = snapData['settings']['minimumPlayers'];

          // start game if enough players are present
          if (numberPlayers >= minimumPlayers) {
            // update room document
            transaction.update(rooms.doc(roomID), {
              // save UID of host
              kHostField: _authorization.getCurrentUserID(),
              // change status to first milestone
              kGameStatusField: snapData['settings'][kSettingsStatusField][0].keys.first,
            });
          }
          return true;
        } catch (e) {
          print('No players found. Error: $e');
          return false;
        }
      }
    });
  }

  @override
  void addMessage({required Message message, required String roomID}) {
    Color authorColor = message.author.color;
    List<dynamic> messageList = [
      {
        'text': message.text,
        'author': {
          'name': message.author.name,
          'uid': message.author.uid,
          'color': authorColor.toHex(),
          'iconNumber': message.author.iconData.codePoint,
        },
        'time': DateTime.now(),
      },
    ];

    // todo: have to use set with merge:true due to update not working
    rooms
        .doc(roomID)
        .set({
          'chat': {'messages': FieldValue.arrayUnion(messageList)},
        }, SetOptions(merge: true))
        .then((value) => print('Updated'))
        .catchError((e) => print('Error while sending message: $e'));
  }
}
