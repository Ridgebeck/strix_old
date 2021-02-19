import 'package:strix/services/database/game_doc_abstract.dart';
import 'package:strix/services/authorization//authorization_abstract.dart';
import '../../services/service_locator.dart';
import 'package:strix/business_logic/classes/room.dart';

// This class handles the conversion and puts it in a form convenient
// for displaying on a view (without knowing anything about any particular view).
class WaitingRoomLogic {
  final GameDoc _gameDoc = serviceLocator<GameDoc>();

  // provide stream of game room to UI
  Stream<Room> roomDocStream(String roomID) {
    // check if returned data from stream makes sense

    return _gameDoc.getDocStream(roomID: roomID);
  }

  // leave game room if back button is pushed
  Future<void> leaveGame(String roomID) async {
    await _gameDoc.leaveGame(roomID: roomID);
  }

  // check if enough players are in game room to start
  Future<bool> enoughPlayers(String roomID) async {
    await _gameDoc.leaveGame(roomID: roomID);
  }
}
