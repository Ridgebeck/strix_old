import 'package:flutter/material.dart';
import 'package:strix/services/database/game_doc_abstract.dart';
import '../../services/service_locator.dart';
import 'package:strix/business_logic/classes/room.dart';

// This class handles the conversion and puts it in a form convenient
// for displaying on a view (without knowing anything about any particular view).
class WaitingRoomLogic {
  WaitingRoomLogic() {
    print('WAITING ROOM LOGIC CALLED');
  }

  final GameDoc _gameDoc = serviceLocator<GameDoc>();

  // provide stream of game room to UI
  Stream<Room> roomDocStream(String roomID) {
    // check if returned data from stream makes sense
    print('ROOM DOC STREAM CALLED');
    return _gameDoc.getDocStream(roomID: roomID);
  }

  // try to start a game if start button is pushed
  Future<void> startGame(
      {BuildContext context, int numberPlayers, int minimumPlayers, String roomID}) async {
    // check if enough players are in room
    if (numberPlayers < minimumPlayers) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Warning'),
          content: Text('You need at least $minimumPlayers players to start the game.'),
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
      bool start = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Warning'),
          content: Text('You become the host if you start the game. Proceed?'),
          actions: [
            TextButton(
              child: Text('BACK'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text('START'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
        barrierDismissible: false,
      );

      // only start game if user clicked START
      if (start == true) {
        print('starting game...');
        //TODO: need return value for verification?
        await _gameDoc.startGame(roomID: roomID);
        // save player as host if start is successful (local and online?)
        // TODO: Save player as host locally
      }
    }
  }

  // try to leave game room if back button is pushed
  Future<bool> leaveRoom({BuildContext context, String roomID, int numberPlayers}) async {
    bool leaving = true;
    if (numberPlayers == 1) {
      leaving = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Warning'),
          content:
              Text('You are the last player in this room. If you leave the room will be closed.'),
          actions: [
            TextButton(
              child: Text('BACK'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
    // only try to leave if not last player or user hit okay
    if (leaving == true) {
      // remove player entry from document or
      // delete document if player is last player in room
      bool canLeave = await _gameDoc.leaveRoom(roomID: roomID);
      // don't leave if game was already started
      if (canLeave == false) {
        print('Cannot leave room. Game was already started.');
        return false;
      }
      // leave room even if error occurred
      else {
        // check for error while trying to leave room
        if (canLeave == null) {
          print('Error while trying to leave room.');
        }
        // go back to previous page
        return true;
      }
    } else {
      return false;
    }
  }
}
