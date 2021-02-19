import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/business_logic/classes/player.dart';
import 'game_doc_abstract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strix/services/service_locator.dart';
import 'package:strix/services/authorization/authorization_abstract.dart';
import 'package:strix/config/constants.dart';

// interaction with room document on Firestore
class GameDocFirestore implements GameDoc {
  final Authorization _authorization = serviceLocator<Authorization>();
  // Create a CollectionReference called that references the firestore games collection
  final CollectionReference rooms = FirebaseFirestore.instance.collection(roomCollection);

  @override
  Future<String> addNewGame({String roomID}) async {
    // try to get document from rooms collection with random room ID
    final querySnapShot = await rooms.where(roomIDField, isEqualTo: roomID).get();

    // check if connection is up-to-date
    if (querySnapShot.metadata.isFromCache == true) {
      // TODO: Error handling when connection is stale
      print('No connection to database!');
      return null;
    }
    // check if a document with roomID already exists
    else if (querySnapShot.size != 0) {
      return null;
    }
    // only proceed if document with roomID does not yet exist
    else {
      // try to create new document
      try {
        // get current user ID
        String uid = await _authorization.getCurrentUserID();

        // get current game settings

        // add new document with generated roomID
        DocumentReference docRef = await rooms.add({
          roomIDField: roomID,
          'gameID': 1,
          'opened': DateTime.now(),
          'players': [uid],
          'gameProgress': 'waiting',
          // add title from settings
          'gameTitle': 'The Stolen Painting',
          //maximumPlayers: add from settings .players.length
        });

        // return ID of room document
        return docRef.id;
      } catch (e) {
        print('Error while creating new document with roomID $roomID');
        print('Error: $e');
        return null;
      }
    }
  }

  @override
  Stream<Room> getDocStream({String roomID}) {
    // Stream of Document Snapshots from database
    Stream<DocumentSnapshot> docRefStream =
        FirebaseFirestore.instance.collection(roomCollection).doc(roomID).snapshots();
    // return converted string
    return _createRoomIDStream(docRefStream);
  }

  // convert firestore data stream to stream of standardized data
  Stream<Room> _createRoomIDStream(Stream<DocumentSnapshot> docRefStream) async* {
    // create Stream of Strings (of roomID) and yield
    await for (DocumentSnapshot docSnap in docRefStream) {
      // convert player list into standardized format
      List<Player> playerList = [];
      for (String uid in docSnap.data()['players']) {
        playerList.add(Player(
          uid: uid,
          name: 'ulli',
          color: Colors.blue,
          image: 'agent1.jpeg',
        ));
      }

      // convert all values into game class
      Room currentRoomData = Room(
        gameTitle: docSnap.data()['gameTitle'],
        roomID: docSnap.data()[roomIDField],
        players: playerList,
        opened: docSnap.data()['opened'].toDate(),
        started: docSnap.data()['started'],
      );
      yield currentRoomData;
    }
  }

  @override
  Future<String> joinGame({String roomID}) async {
    // try to get document from rooms collection with value from text field
    final querySnapShot = await rooms.where(roomIDField, isEqualTo: roomID).get();
    // check if only one document exists
    if (querySnapShot.size != 1) {
      // no or more than 1 document was found
      return null;
    }
    // one document exists
    else {
      // read document ID
      String docID = querySnapShot.docs.single.id;
      // change document safely in a transaction
      return await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Get the document
        DocumentSnapshot snapshot = await transaction.get(rooms.doc(docID));
        // check if document exists
        if (!snapshot.exists) {
          return null;
        } else {
          // check if player count is below limit
          List<String> playersList = List.from(snapshot.data()['players']);

          if (playersList.length >= maximumPlayerCount) {
            // return error String
            return 'full';
          } else {
            // add new player
            playersList.add('test UID');
            // perform an update on the document
            transaction.update(rooms.doc(docID), {
              'players': playersList,
            });
            return docID;
          }
        }
      }).then((value) {
        // return docID if everything works out
        // otherwise return null
        return value;
      }).catchError((error) {
        print('Caught Error!');
        return null;
      });
    }
  }

  @override
  Future<void> leaveGame({String roomID, String uid}) async {
    // try to get document from games collection with typed in game ID
    final querySnapShot = await rooms.where(roomIDField, isEqualTo: roomID).get();
    // check if gameID exists
    if (querySnapShot.size != 1) {
      print('less or more than one document found');
      print(querySnapShot.size);
      return null;
    } else {
      print('GAME FOUND!!!');
      // read document ID
      String docID = querySnapShot.docs.single.id;
      // change document safely in a transaction
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Get the document
        DocumentSnapshot snapshot = await transaction.get(rooms.doc(docID));
        // check if document exists
        if (!snapshot.exists) {
          // TODO: Error handling when game does not exist
          //throw Exception("Game does not exist!");
          print("Game does not exist!");
          return null;
        } else {
          // find player entry
          List<String> playersList = List.from(snapshot.data()['players']);
          print(playersList);
        }
      });
    }

    print('Leaving game room...');
  }
}
