import 'package:flutter/material.dart';

class WaitingRoomScreen extends StatelessWidget {
  static const String route_id = 'waiting_room_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Game ID: ABCDEF'),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('back')),
                  FlatButton(
                    onPressed: () {
                      print('Start Game');
                    },
                    child: Text('start game'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
