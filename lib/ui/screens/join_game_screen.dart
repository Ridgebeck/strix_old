import 'package:flutter/material.dart';

class JoinGameScreen extends StatelessWidget {
  static const String route_id = 'join_game_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Enter Game ID:'),
          TextField(
            decoration: InputDecoration(hintText: 'e.g. XBYTRQ'),
          ),
          FlatButton(
              onPressed: () {
                print('Join Game');
              },
              child: Text('join game')),
        ],
      ),
    );
  }
}
