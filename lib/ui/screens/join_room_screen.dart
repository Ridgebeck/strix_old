import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strix/business_logic/logic/join_room_logic.dart';
import 'package:strix/ui/screens/waiting_room_screen.dart';

class JoinRoomScreen extends StatelessWidget {
  static const String route_id = 'join_room_screen';

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Enter Room ID:'),
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
                  await JoinRoomLogic().joinRoom(roomID: textController.text, context: context);
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
