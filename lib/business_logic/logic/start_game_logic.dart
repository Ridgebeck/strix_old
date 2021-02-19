import 'dart:math';
import 'package:strix/services/database/game_doc_abstract.dart';
import '../../services/service_locator.dart';

// This class handles the conversion and puts it in a form convenient
// for displaying on a view (without knowing anything about any particular view).
class StartGameLogic {
  final GameDoc _gameDoc = serviceLocator<GameDoc>();
  //final LocalStorage _storage = serviceLocator<LocalStorage>();

  // add game to database, returns database reference
  // save reference to local memory
  Future<String> addGame() async {
    // create random 6 letter game ID
    String roomID = _getRandomString(6);
    String docID;

    // try maximum 3 times
    for (int i = 0; i < 3; i++) {
      // create new game with roomID
      docID = await _gameDoc.addNewGame(roomID: roomID);
      // exit for loop if docID is not null
      if (docID != null) {
        break;
      }
    }

    // save docID to local memory
    //await _storage.saveDatabaseReference(docID);

    // return database reference (docID)
    return docID;
  }

  // function to create random roomID String
  String _getRandomString(int length) {
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random _rnd = Random();
    return String.fromCharCodes(
        Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
