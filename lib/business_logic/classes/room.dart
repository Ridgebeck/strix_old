import 'call.dart';
import 'chat.dart';
import 'player.dart';

class Room {
  String gameTitle;
  String roomID;
  String gameProgress;
  List<Player> players;
  int minimumPlayers;
  int maximumPlayers;
  DateTime opened;
  Chat chat;
  List<AvailableAssetEntry> availableAssets;

  DateTime? started;
  String? host;

  Room({
    required this.gameTitle,
    required this.roomID,
    required this.gameProgress,
    required this.players,
    required this.minimumPlayers,
    required this.maximumPlayers,
    required this.opened,
    required this.chat,
    required this.availableAssets,
    this.started,
    this.host,
  });
}

class AvailableAssetEntry {
  String? entryName;
  Call? call;
  List<String>? pictures;
  List<String>? audioFiles;
  List<Call>? archivedCalls;

  AvailableAssetEntry({
    this.entryName,
    this.call,
    this.pictures,
    this.archivedCalls,
  });
}
