import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/business_logic/logic/waiting_room_logic.dart';

class WaitingRoomScreen extends StatelessWidget {
  static const String route_id = 'waiting_room_screen';
  final String docID;
  WaitingRoomScreen({@required this.docID});

  @override
  Widget build(BuildContext context) {
    String roomID;

    return WillPopScope(
      // prevent going back via system
      onWillPop: () async => false,
      child: Scaffold(
        body: StreamBuilder(
            stream: WaitingRoomLogic().roomDocStream(docID),
            builder: (BuildContext context, AsyncSnapshot<Room> snapshot) {
              if (snapshot.data == null) {
                return Center(child: Text('NO DATA!'));
              } else {
                return Center(
                    child: Column(
                  children: [
                    Expanded(child: Container()),
                    Expanded(child: Text('Game: ${snapshot.data.gameTitle}')),
                    Expanded(child: Text('Room ID: ${snapshot.data.roomID}')),
                    Expanded(child: Text('Players: ${snapshot.data.players.length} / 4')),
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
                            // TODO: display warning pop up
                            // remove player entry from document
                            await WaitingRoomLogic().leaveGame(roomID, 'UID');
                            // go back to page
                            Navigator.pop(context);
                          },
                          child: Text('back'),
                        ),
                        Container(),
                        //Expanded(child: Text('back')),
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
