import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/config/constants.dart';
import 'package:strix/services/service_locator.dart';
import 'package:strix/services/authorization/authorization_abstract.dart';
import 'package:strix/ui/screens/icoming_call_screen.dart';
import 'package:strix/ui/widgets/bottom_tab_bar.dart';
import 'mission_screen.dart';
import 'data_screen.dart';
import 'chat_screen.dart';

import 'package:strix/business_logic/logic/waiting_room_logic.dart';

class MainGameScreen extends StatefulWidget {
  static const String route_id = 'main_game_screen';
  final String roomID;

  MainGameScreen({required this.roomID});

  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> with SingleTickerProviderStateMixin {
  late Stream<Room?> roomStream;
  late TabController _tabController;
  final Authorization _authorization = serviceLocator<Authorization>();
  AvailableAssetEntry lastEntry = AvailableAssetEntry(entryName: "lastEntry");
  BuildContext? dialogContext;
  int currentMessages = 0;
  bool newMessage = false;

  @override
  void initState() {
    super.initState();
    roomStream = WaitingRoomLogic().roomDocStream(widget.roomID);
    _tabController = TabController(length: 3, vsync: this);

    // update all widgets that are listening to the animation value
    _tabController.animation?.addListener(() {
      // minimize keyboard when not on chat screen
      if (_tabController.index != 3) {
        FocusScope.of(context).unfocus();
      }
      //setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: roomStream,
        builder: (BuildContext context, AsyncSnapshot<Room?> snapshot) {
          Room? snapData = snapshot.data;
          if (snapData == null) {
            print('ERROR - data is null');
            // todo:error handling when data is null
            return Container();
          } else {
            // check if new message was added
            if (currentMessages != snapData.chat.messages.length) {
              currentMessages = snapData.chat.messages.length;
              newMessage = true;
            } else {
              newMessage = false;
            }

            // find current progress entry
            AvailableAssetEntry currentEntry = snapData.availableAssets
                .singleWhere((element) => element.entryName == snapData.gameProgress);
            // check if currentEntry is different from lastEntry
            // prevents opening calls multiple times
            if (currentEntry != lastEntry) {
              //set last entry to current one
              lastEntry = currentEntry;
              // check if current entry is a call
              if (currentEntry.call != null) {
                // add callback to check for gamProgress change
                // after every frame and move to call screen
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  print(currentEntry.call!.callFile);
                  if (snapData.host == _authorization.getCurrentUserID()) {
                    Navigator.of(context)
                        .pushNamed(IncomingCallScreen.route_id, arguments: snapData);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        dialogContext = context;
                        return AlertDialog(
                          title: Text('Please Stand By'),
                          content: Text('Incoming call on other device.'),
                        );
                      },
                      barrierDismissible: false,
                    );
                  }
                });
              }
              // when entry is not a call close dialog box
              // if context exists
              else if (dialogContext != null) {
                Navigator.pop(dialogContext!);
                dialogContext = null;
              }
            }

            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                body: SafeArea(
                  child: TabBarView(
                    controller: _tabController,
                    physics: BouncingScrollPhysics(),
                    children: [
                      MissionScreen(missionData: currentEntry.mission),
                      DataScreen(assets: currentEntry),
                      //ToolsScreen(),
                      ChatScreen(roomData: snapData, newMessage: newMessage),
                    ],
                  ),
                ),
                bottomNavigationBar: BottomTabBar(_tabController),
                backgroundColor: kBackgroundColorLight,
              ),
            );
          }
        });
  }
}
