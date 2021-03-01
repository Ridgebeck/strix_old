import 'package:flutter/material.dart';
import 'package:strix/business_logic/logic/start_room_logic.dart';
import 'package:strix/config/constants.dart';

class StartJoinScreen extends StatelessWidget {
  //static const String route_id = 'start_join_screen';
  final Function changeStatus;
  final Function changeDocID;
  StartJoinScreen({this.changeStatus, this.changeDocID});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FlatButton(
              onPressed: () async {
                String roomID = await StartRoomLogic().addRoom();
                if (roomID == null || roomID == 'exists') {
                  print('ERROR: could not add new game');
                  changeDocID(null);
                  // TODO: show error pop up when game cannot be created
                } else {
                  changeDocID(roomID);
                  changeStatus(statusType.waiting);
                  //Navigator.of(context).pushNamed(WaitingRoomScreen.route_id, arguments: roomID);

                }
              },
              child: Text('Start a Mission')),
          FlatButton(
              onPressed: () {
                print('JOINING A MISSION');
                changeStatus(statusType.joining);
                //Navigator.of(context).pushNamed(JoinRoomScreen.route_id);
              },
              child: Text('Join a Mission')),
        ],
      ),
    );
  }
}
