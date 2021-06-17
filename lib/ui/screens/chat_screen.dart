import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/chat.dart';
import 'package:strix/business_logic/classes/player.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/business_logic/logic/chat_room_logic.dart';
import 'package:strix/services/service_locator.dart';
import 'package:strix/services/authorization/authorization_abstract.dart';
import 'package:strix/ui/widgets/chat_message.dart';

class ChatScreen extends StatelessWidget {
  final Room roomData;
  final bool newMessage;
  ChatScreen({required this.roomData, required this.newMessage});

  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Authorization _authorization = serviceLocator<Authorization>();

  @override
  Widget build(BuildContext context) {
    Chat chatData = roomData.chat;
    return SafeArea(
      child: Column(
        children: [
          // Expanded(
          //   flex: 12,
          //   child: ScreenHeader(
          //     title: 'chat',
          //     iconData: Icons.chat_bubble_outline,
          //   ),
          // ),
          Expanded(
            flex: 88,
            child: Column(
              children: [
                Expanded(
                  flex: 95,
                  child: ListView.builder(
                    itemCount: chatData.messages.length,
                    reverse: true,
                    shrinkWrap: true,
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      List<Message> reversedList = chatData.messages.reversed.toList();
                      Message message = reversedList[index];
                      bool fromTeam = message.author is Player;
                      bool fromMe = fromTeam
                          ? _authorization.getCurrentUserID() == message.author.uid
                          : false;
                      bool delay =
                          (index == 0 && fromTeam == false && reversedList.length > 1 && newMessage)
                              ? true
                              : false;

                      return ChatMessage(
                        fromTeam: fromTeam,
                        fromMe: fromMe,
                        message: message,
                        delay: delay,
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
              ],
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: TextField(
                        controller: _textController,
                        textAlignVertical: TextAlignVertical.center,
                        expands: true,
                        maxLines: null,
                        maxLength: roomData.maximumInputCharacters,
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
