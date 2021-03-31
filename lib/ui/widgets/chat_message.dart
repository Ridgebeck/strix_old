import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/chat.dart';
import 'package:strix/config/constants.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    required this.fromMe,
    required this.message,
  });

  final bool fromMe;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          fromMe
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: message.author.color,
                      //boxShadow: kCardShadow,
                      // image: DecorationImage(
                      //     image: AssetImage('assets/pictures/russ.jpeg'),
                      //     fit: BoxFit.cover),
                    ),
                  ),
                ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              //boxShadow: kCardShadow,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 0.0),
                colors: fromMe
                    ? [Colors.blueGrey[100]!, Colors.blueGrey[400]!]
                    : [Colors.blueGrey[400]!, Colors.blueGrey[900]!],
              ),
            ),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                message.text,
                style: TextStyle(
                  color: fromMe ? Colors.blueGrey[900] : Colors.white,
                ),
              ),
            ),
          ),
          fromMe
              ? Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: message.author.color,
                      //boxShadow: kCardShadow,
                      // image: DecorationImage(
                      //     image: AssetImage('assets/pictures/russ.jpeg'),
                      //     fit: BoxFit.cover),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
