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
  final CollectionReference settings = FirebaseFirestore.instance.collection(settingsReference);

  @override
  Future<String> addNewRoom({String roomID}) async {
    // try to get document from rooms collection with random room ID
    return await rooms.doc(roomID).get().then((docSnapshot) async {
      // check if document with roomID already exists
      if (docSnapshot.exists) {
        print('Document already exists!');
        return 'exists';
      }
      // document does not exist yet, proceed
      else {
        // try to fetch settings document
        DocumentSnapshot settingsSnapshot = await settings.doc('gameData').get();
        // TODO: replace gameData with gameID

        // try to create document with roomID
        await rooms.doc(roomID).set({
          roomIDField: roomID, // TODO: remove
          gameIDField: settingsSnapshot.get(gameIDField),
          openedField: DateTime.now(),
          playersField: [_authorization.getCurrentUserID()],
          gameStatusField: waitingStatus,
          settingsReference: settingsSnapshot.data(),
        });
        return roomID;
      }
    }).catchError((e) {
      print('Error while trying to create new room: $e');
      return null;
    });
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
      // try to create room data from snapshot
      try {
        // convert player list into standardized format
        List<Player> playerList = [];
        for (int i = 0; i < docSnap.data()[playersField].length; i++) {
          Map<String, dynamic> currentPlayerRef =
              docSnap.data()[settingsReference][playersField][i];
          playerList.add(
            Player(
              uid: docSnap.data()[playersField][i],
              name: currentPlayerRef['name'],
              color: HexColor.fromHex(currentPlayerRef['color']),
              image: currentPlayerRef['image'],
            ),
          );
        }

        // convert all values into room class
        Room currentRoomData = Room(
          gameTitle: docSnap.data()['settings']['gameTitle'],
          roomID: docSnap.data()[roomIDField],
          gameProgress: docSnap.data()['gameProgress'],
          players: playerList,
          minimumPlayers: docSnap.data()['settings']['minimumPlayers'],
          maximumPlayers: docSnap.data()['settings']['maximumPlayers'],
          opened: docSnap.data()['opened'].toDate(),
          started: docSnap.data()['started'],
        );
        yield currentRoomData;
      } catch (e) {
        print('Error while trying to create room data from stream.');
        print('Error: $e');
      }
    }
  }

  @override
  Future<String> joinRoom({String roomID}) async {
    // change document safely in a transaction
    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(rooms.doc(roomID));
      // check if document exists
      if (!snapshot.exists) {
        return null;
      } else {
        // check if player count is below limit
        List<String> playersList = List.from(snapshot.data()['players']);

        if (playersList.length >= snapshot.data()['settings']['maximumPlayers']) {
          // return error String
          return 'full';
        } else {
          // get current user ID
          String uid = _authorization.getCurrentUserID();

          // check if player (uid) is already in the room
          if (playersList.contains(uid)) {
            print('Player already in room. Joining.');
            return roomID;
          }
          // if player is not in the room
          else if (snapshot.data()[gameStatusField] == waitingStatus) {
            // add new player
            playersList.add(uid);
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
      // return docID if everything works out
      return value;
      // otherwise return null
    }).catchError((error) {
      print('Error while trying to join a room.');
      print(error);
      return null;
    });
  }

  @override
  Future<bool> leaveRoom({String roomID}) async {
    // change document safely in a transaction
    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(rooms.doc(roomID));

      // check if document exists
      if (!snapshot.exists) {
        print("Error: game does not exist!");
        return null;
      }
      // check if game has already been started
      else if (snapshot.data()[gameStatusField] != waitingStatus) {
        // return false (cannot leave room)
        return false;
      }
      // otherwise leave the room
      else {
        // get current user ID
        String uid = _authorization.getCurrentUserID();
        // get player list
        List<String> playersList = List.from(snapshot.data()['players']);
        // check if last participant is leaving
        print('length ${playersList.length}');
        if (playersList.length == 1) {
          print('last player leaving');
          // try to delete complete document
          transaction.delete(rooms.doc(roomID));
          // TODO: error handling if delete does not work?
        } else {
          print('participant leaving');
          // try to remove player from list
          playersList.remove(uid);
          // TODO: error handling if uid is not found?
          // perform an update on the document
          transaction.update(rooms.doc(roomID), {
            'players': playersList,
          });
        }
        return true;
      }
    }).then((value) {
      // return value if everything works out
      return value;
      // otherwise return null
    }).catchError((error) {
      print('Error while trying to leave game.');
      print(error);
      return null;
    });
  }

  @override
  Future<void> startGame({String roomID}) async {
    // change document safely in a transaction
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(rooms.doc(roomID));
      // check if document exists
      if (!snapshot.exists) {
        print("Error: game does not exist!");
        return false;
      }
      // check if game has already been started
      else if (snapshot.data()[gameStatusField] != waitingStatus) {
        // fail silently?
        return null;
      } else {
        // check if enough players are in room
        int numberPlayers;
        int minimumPlayers;
        try {
          numberPlayers = snapshot.data()['players'].length;
          minimumPlayers = snapshot.data()['settings']['minimumPlayers'];

          // start game if enough players are present
          if (numberPlayers >= minimumPlayers) {
            // update room document
            transaction.update(rooms.doc(roomID), {
              // change status to first milestone
              gameStatusField: snapshot.data()['settings'][settingsStatusField][0].keys.first,
              // save UID of host
              hostField: _authorization.getCurrentUserID(),
            });
          }
        } catch (e) {
          print('No players found. Error: $e');
        }
      }
    });
  }
}
