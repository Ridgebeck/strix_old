import 'game_doc_abstract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strix/services/service_locator.dart';
import 'package:strix/services/authorization/authorization_abstract.dart';

// interaction with game document on Firestore
class GameDocFirestore implements GameDoc {
  final Authorization _authorization = serviceLocator<Authorization>();
  // Create a CollectionReference called that references the firestore games collection
  final CollectionReference games = FirebaseFirestore.instance.collection('games');

  @override
  Future<String> addNewGame({String gameID}) async {
    // try to get document from games collection with random game ID
    final querySnapShot = await games.where('gameID', isEqualTo: gameID).get();

    // check if connection is up-to-date
    if (querySnapShot.metadata.isFromCache == true) {
      // TODO: Error handling when connection is stale
      print('No connection to database!');
      return null;
    }
    // check if a document with gameID already exists
    else if (querySnapShot.size != 0) {
      return null;
    }
    // only proceed if document with gameID does not yet exist
    else {
      // try to create new document
      try {
        // get current user ID
        String uid = await _authorization.getCurrentUserID();

        // add new document with generated gameID
        DocumentReference docRef = await games.add({
          'gameID': gameID,
          'game': 'Test Version',
          'opened': DateTime.now(),
          'players': [uid],
          // TODO: get names from game settings
          'names': [
            'Agent 1',
            'Agent 2',
            'Agent 3',
            'Agent 4',
          ],
          'joinedPlayers': 1,
          //'gameProgress': 'waiting',
        });

        // return ID of game document
        return docRef.id;
      } catch (e) {
        print('Error while creating new document with gameID $gameID');
        print('Error: $e');
        return null;
      }
    }
  }
}

//   // check if connection is up-to-date
//   if (querySnapShot.metadata.isFromCache == true) {
//   // TODO: Error handling when connection is stale
//     print('No connection to database!');
//     return '000000';
//   }
//   // check if gameID already exists
//   else if (querySnapShot.size == 0) {
//     print('Successfully created new gameID: $gameID');
//     // try to create new document
//     try {
//       DocumentReference docRef = await games.add({
//         'gameID': gameID,
//         'game': 'Test Version',
//         'opened': DateTime.now(),
//         'player1': FirebaseAuth.instance.currentUser.uid,
//         'joinedPlayers': 1,
//         'gameProgress': -1,
//       });
//
//
//   return 'Test Doc ID 123456789';
// }catch (e) {
//   // TODO: error handling while creating new gameID document
//   print('Error while creating new document with gameID $gameID');
//   print('Error: $e');
//   return '000000';
//     }
