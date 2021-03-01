import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 150.0,
                color: Colors.green,
                child: Center(child: Text('INDEX: $index')),
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(child: TextField()),
            FlatButton(onPressed: () {}, child: Text('SEND')),
          ],
        ),
      ],
    );
  }
}
