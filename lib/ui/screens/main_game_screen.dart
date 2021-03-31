import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/config/constants.dart';
import 'package:strix/services/service_locator.dart';
import 'package:strix/services/authorization/authorization_abstract.dart';
import 'package:strix/ui/screens/icoming_call_screen.dart';
import 'package:strix/ui/screens/standby_screen.dart';
import 'package:strix/ui/widgets/bottom_tab_bar.dart';
import 'home_screen.dart';
import 'data_screen.dart';
import 'tools_screen.dart';
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

  @override
  void initState() {
    super.initState();
    roomStream = WaitingRoomLogic().roomDocStream(widget.roomID);
    _tabController = TabController(length: 4, vsync: this);

    // update all widgets that are listening to the animation value
    _tabController.animation?.addListener(() {
      // minimize keyboard when not on chat screen
      if (_tabController.index != 4) {
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
          // find current progress entry
          AvailableAssetEntry currentEntry = snapData.availableAssets
              .singleWhere((element) => element.entryName == snapData.gameProgress);

          // check if current entry is a call
          if (currentEntry.call != null) {
            // add callback to check for gamProgress change
            // after every frame and move to game screen
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              print(currentEntry.call!.callFile);
              if (snapData.host == _authorization.getCurrentUserID()) {
                print('Call detected on host device!');
                Navigator.of(context).pushNamed(IncomingCallScreen.route_id);
              } else {
                print('Call detected - standby!');
                Navigator.of(context).pushNamed(StandbyScreen.route_id);
              }
            });
          }

          if (currentEntry.audioFiles != null) {
            print('Audio files found!');
            print(currentEntry.audioFiles);
          }

          if (currentEntry.pictures != null) {
            print('Pictures found!');
            print(currentEntry.pictures);
          }

          if (currentEntry.archivedCalls != null) {
            print('Archived calls found!');
            print(currentEntry.archivedCalls);
          }

          return Scaffold(
            body: SafeArea(
              child: TabBarView(
                controller: _tabController,
                physics: BouncingScrollPhysics(),
                children: [
                  HomeScreen(),
                  DataScreen(),
                  ToolsScreen(),
                  ChatScreen(roomData: snapData),
                ],
              ),
            ),
            bottomNavigationBar: BottomTabBar(_tabController),
            backgroundColor: kBackgroundColorLight,
          );
        }
      },
    );
  }
}
