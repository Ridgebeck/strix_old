// Using an abstract class like this allows to swap concrete implementations.
// This is useful for separating architectural layers.
// It also makes testing and development easier because you can provide
// a mock implementation or fake data.
abstract class GameDoc {
  // create new game with given gameID
  // return docID of newly created game
  Future<String> addNewGame({String gameID});

  // return reference to game document
  //Future<String> getDocRef({String gameID});
}
