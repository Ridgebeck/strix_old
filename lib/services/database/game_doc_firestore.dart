import 'package:strix/business_logic/classes/hex_color.dart';
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
  // Create a CollectionReference that references the firestore rooms and settings collections
  final CollectionReference rooms = FirebaseFirestore.instance.collection(roomsCollection);
  final CollectionReference settings = FirebaseFirestore.instance.collection(settingsCollection);

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
        String uid = _authorization.getCurrentUserID();

        // get current game settings
        final settingsQuerySnapShot =
            await settings.where(gameIDField, isEqualTo: testingGameID).get();

        // check if connection is up-to-date
        if (settingsQuerySnapShot.metadata.isFromCache == true) {
          // TODO: Error handling when connection is stale
          print('No connection to database!');
          return null;
        }
        // check if settings document is unique
        else if (settingsQuerySnapShot.size != 1) {
          return null;
        }
        // only proceed if just one document was found
        else {
          print(settingsQuerySnapShot.docs.single.data());
        }

        // add new document with generated roomID
        DocumentReference docRef = await rooms.add({
          roomIDField: roomID,
          'gameID': 1,
          'opened': DateTime.now(),
          'players': [uid],
          'gameProgress': 'waiting',
          'settings': settingsQuerySnapShot.docs.single.data(),
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
        FirebaseFirestore.instance.collection(roomsCollection).doc(roomID).snapshots();
    // return converted string
    return _createRoomIDStream(docRefStream);
  }

  // convert firestore data stream to stream of standardized data
  Stream<Room> _createRoomIDStream(Stream<DocumentSnapshot> docRefStream) async* {
    // create Stream of Strings (of roomID) and yield
    await for (DocumentSnapshot docSnap in docRefStream) {
      // convert player list into standardized format
      List<Player> playerList = [];
      for (int i = 0; i < docSnap.data()['players'].length; i++) {
        //String uid in docSnap.data()['players']) {
        playerList.add(
          Player(
            uid: docSnap.data()['players'][i],
            name: docSnap.data()['settings']['players'][i]['name'],
            color: HexColor.fromHex(docSnap.data()['settings']['players'][i]['color']),
            image: docSnap.data()['settings']['players'][i]['image'],
          ),
        );
      }

      // convert all values into game class
      Room currentRoomData = Room(
        gameTitle: docSnap.data()['settings']['gameTitle'],
        roomID: docSnap.data()[roomIDField],
        players: playerList,
        minimumPlayers: docSnap.data()['settings']['minimumPlayers'],
        maximumPlayers: docSnap.data()['settings']['maximumPlayers'],
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

          if (playersList.length >= snapshot.data()['settings']['minimumPlayers']) {
            // return error String
            return 'full';
          } else {
            // get current user ID
            String uid = _authorization.getCurrentUserID();
            // add new player
            playersList.add(uid);
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
  Future<void> leaveGame({String roomID}) async {
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
          // get current user ID
          String uid = _authorization.getCurrentUserID();
          // get player list
          List<String> playersList = List.from(snapshot.data()['players']);
          // check if last participant is leaving
          print('length ${playersList.length}');
          if (playersList.length == 1) {
            print('last player leaving');
            //TODO: warning?
            // try to delete complete document
            transaction.delete(rooms.doc(docID));
            // TODO: error handling if delete does not work
          } else {
            print('participant leaving');
            // try to remove player from list
            playersList.remove(uid);
            // TODO: error handling if uid is not found?
            // perform an update on the document
            transaction.update(rooms.doc(docID), {
              'players': playersList,
            });
          }

          print(playersList);
        }
      });
    }

    print('Leaving game room...');
  }
}
