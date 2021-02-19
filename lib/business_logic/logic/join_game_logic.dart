import 'package:strix/services/database/game_doc_abstract.dart';
import '../../services/service_locator.dart';

// This class handles the conversion and puts it in a form convenient
// for displaying on a view (without knowing anything about any particular view).
class JoinGameLogic {
  final GameDoc _gameDoc = serviceLocator<GameDoc>();
  //final LocalStorage _storage = serviceLocator<LocalStorage>();

  // add game to database, returns database reference
  // save reference to local memory
  Future<String> joinGame({String roomID}) async {
    return _gameDoc.joinGame(roomID: roomID);
  }
}
