import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strix/business_logic/logic/join_game_logic.dart';
import 'package:strix/ui/screens/waiting_room_screen.dart';

class JoinGameScreen extends StatelessWidget {
  static const String route_id = 'join_game_screen';

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Enter Game ID:'),
          TextFormField(
            maxLength: 6,
            textCapitalization: TextCapitalization.characters,
            autofocus: true,
            controller: textController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('back')),
              FlatButton(
                onPressed: () async {
                  // try to join game
                  String docID = await JoinGameLogic().joinGame(roomID: textController.text);

                  // display error or join room
                  if (docID == 'full') {
                    print('Could not join room. Room is full.');
                  } else if (docID == null) {
                    print('Error, can not join room!');
                  } else {
                    // navigate to waiting room
                    Navigator.of(context).pushNamed(WaitingRoomScreen.route_id, arguments: docID);
                  }
                },
                child: Text('join game'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
