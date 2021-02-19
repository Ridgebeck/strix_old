// Using an abstract class like this allows to swap concrete implementations.
// This is useful for separating architectural layers.
// It also makes testing and development easier because you can provide
// a mock implementation or fake data.
import 'package:strix/business_logic/classes/room.dart';

abstract class GameDoc {
  // create new game with given roomID
  // return docID of newly created game
  Future<String> addNewGame({String roomID});

  // try to join a Room via roomID
  // return docID if successful, otherwise null
  Future<String> joinGame({String roomID});

  // remove player from game room
  Future<void> leaveGame({String roomID});

  // return stream to room document (todo: game document content)
  Stream<Room> getDocStream({String roomID});
}
