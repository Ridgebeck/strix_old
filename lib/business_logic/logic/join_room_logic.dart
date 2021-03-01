import 'package:flutter/material.dart';
import 'package:strix/services/database/game_doc_abstract.dart';
import 'package:strix/services/service_locator.dart';
import 'package:strix/config/constants.dart';

// This class handles the conversion and puts it in a form convenient
// for displaying on a view (without knowing anything about any particular view).
class JoinRoomLogic {
  final GameDoc _gameDoc = serviceLocator<GameDoc>();
  //final LocalStorage _storage = serviceLocator<LocalStorage>();

  // add game to database, returns database reference
  // save reference to local memory
  Future<void> joinRoom({BuildContext context, String roomID}) async {
    String docID = await _gameDoc.joinRoom(roomID: roomID);
    // display error or join room
    if (docID == 'full') {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Warning'),
          content: Text('Could not join room. Room was already full.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else if (docID == null) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Warning'),
          content: Text('Could not join room. Room ID was not found.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      // navigate to waiting room
      //Navigator.of(context).pushNamed(WaitingRoomScreen.route_id, arguments: docID);
    }
  }
}
