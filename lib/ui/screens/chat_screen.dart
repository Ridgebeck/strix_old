import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:strix/business_logic/classes/chat.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/business_logic/logic/chat_room_logic.dart';
import 'package:strix/config/constants.dart';
import 'package:strix/services/service_locator.dart';
import 'package:strix/services/authorization/authorization_abstract.dart';
import 'package:strix/ui/widgets/chat_message.dart';
import 'package:strix/ui/widgets/screen_header.dart';

class ChatScreen extends StatelessWidget {
  final Room roomData;
  ChatScreen({required this.roomData});

  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Authorization _authorization = serviceLocator<Authorization>();

  @override
  Widget build(BuildContext context) {
    Chat chatData = roomData.chat;
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 12,
            child: ScreenHeader(
              title: 'chat',
              iconData: Icons.chat_bubble_outline,
            ),
          ),
          Expanded(
            flex: 88,
            child: ListView.builder(
              itemCount: chatData.messages.length,
              reverse: true,
              shrinkWrap: true,
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                List<Message> reversedList = chatData.messages.reversed.toList();
                Message message = reversedList[index];
                bool fromMe = message.author.uid == _authorization.getCurrentUserID();

                return ChatMessage(fromMe: fromMe, message: message);
              },
            ),
          ),
          SizedBox(
            height: 55,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Container()),
                  Expanded(
                    flex: 40,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        color: kBackgroundColorLight,
                        intensity: 0.9,
                        depth: -2.0,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100.0)),
                      ),
                      child: TextField(
                        controller: _textController,
                        textAlignVertical: TextAlignVertical.center,
                        expands: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Your message here.',
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  TextButton(
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        ChatRoomLogic().addMessage(room: roomData, text: _textController.text);
                        _textController.clear();
                        _scrollController.animateTo(
                          0.0,
                          curve: Curves.easeOut,
                          duration: Duration(milliseconds: 300),
                        );
                      }
                    },
                    child: FittedBox(
                      child: Icon(
                        Icons.send,
                        color: Colors.blueGrey,
                        size: 35.0,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
