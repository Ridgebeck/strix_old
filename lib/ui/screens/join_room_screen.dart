import 'package:flutter/material.dart';
import 'package:strix/business_logic/logic/join_room_logic.dart';
import 'package:strix/ui/screens/waiting_room_screen.dart';

class JoinRoomScreen extends StatelessWidget {
  // TODO: give status change function to class
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Enter Mission ID:'),
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
                    //Navigator.pop(context);
                    // TODO: replace with status change
                  },
                  child: Text('back')),
              FlatButton(
                onPressed: () async {
                  // try to join game
                  // todo: replace Navigator in function
                  //await JoinRoomLogic().joinRoom(roomID: textController.text, context: context);
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
