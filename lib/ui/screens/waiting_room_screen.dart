import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/business_logic/logic/waiting_room_logic.dart';
import 'package:strix/services/service_locator.dart';
import 'package:strix/services/authorization/authorization_abstract.dart';
import 'package:strix/config/constants.dart';
import 'main_game_screen.dart';

class WaitingRoomScreen extends StatelessWidget {
  static const String route_id = 'waiting_room_screen';
  final String docID;
  WaitingRoomScreen({@required this.docID});

  final Authorization _authorization = serviceLocator<Authorization>();

  @override
  Widget build(BuildContext context) {
    final Stream<Room> roomStream = WaitingRoomLogic().roomDocStream(docID);

    return WillPopScope(
      // prevent going back via system
      onWillPop: () async => false,
      child: Scaffold(
        body: StreamBuilder(
            stream: roomStream,
            builder: (BuildContext context, AsyncSnapshot<Room> snapshot) {
              // add callback to check for gamProgress change
              // after every frame and move to game screen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (snapshot.data != null && snapshot.data.gameProgress != kWaitingStatus) {
                  // pop complete stack and move to the main game screen
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MainGameScreen.route_id, (Route<dynamic> route) => false,
                      arguments: docID);
                }
              });

              // check if stream is waiting for connection
              if (snapshot.connectionState == ConnectionState.waiting) {
                // TODO: IMPLEMENT LOADING SCREEN
                return Center(child: Text('LOADING!'));
              }
              // check if stream has no data
              else if (snapshot.data == null) {
                return Center(child: Text('NO DATA!'));
              } else {
                return Center(
                    child: Column(
                  children: [
                    Expanded(child: Container()),
                    Expanded(child: Text('Game: ${snapshot.data.gameTitle}')),
                    Expanded(child: Text('Room ID: ${snapshot.data.roomID}')),
                    Expanded(
                        child: Text(
                            'Players: ${snapshot.data.players.length} / ${snapshot.data.maximumPlayers}')),
                    Expanded(
                      flex: 4,
                      child: ListView.builder(
                        itemCount: snapshot.data.players.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final player = snapshot.data.players[index];
                          return ListTile(
                            tileColor: player.color,
                            title: Center(
                              child: Text(
                                'Player ${index + 1}: ${player.name}',
                                style: TextStyle(
                                  fontWeight: player.uid == _authorization.getCurrentUserID()
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                //style: TextStyle(color: player.color),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          onPressed: () async {
                            // leave the room
                            bool leave = await WaitingRoomLogic().leaveRoom(
                              context: context,
                              roomID: snapshot.data.roomID,
                              numberPlayers: snapshot.data.players.length,
                            );
                            if (leave == true) {
                              Navigator.pop(context);
                            }
                          },
                          child: Text('back'),
                        ),
                        FlatButton(
                          onPressed: () async {
                            // try to start the game
                            await WaitingRoomLogic().startGame(
                              context: context,
                              numberPlayers: snapshot.data.players.length,
                              minimumPlayers: snapshot.data.minimumPlayers,
                              roomID: snapshot.data.roomID,
                            );
                          },
                          child: Text('start'),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                  ],
                ));
              }
            }),
      ),
    );
  }
}
