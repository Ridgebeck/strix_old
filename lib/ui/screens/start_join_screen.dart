import 'package:flutter/material.dart';
import 'package:strix/business_logic/logic/start_room_logic.dart';
import 'package:strix/ui/screens/join_room_screen.dart';
import 'package:strix/ui/screens/waiting_room_screen.dart';

class StartJoinScreen extends StatelessWidget {
  static const String route_id = 'start_join_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton(
                onPressed: () async {
                  String roomID = await StartRoomLogic().addRoom();
                  if (roomID == null || roomID == 'exists') {
                    print('ERROR: could not add new game');
                    // TODO: show error pop up when game cannot be created
                  } else {
                    Navigator.of(context).pushNamed(WaitingRoomScreen.route_id, arguments: roomID);
                  }
                },
                child: Text('start new game')),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(JoinRoomScreen.route_id);
                },
                child: Text('join game')),
          ],
        ),
      ),
    );
  }
}
