import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/ui/widgets/bottom_tab_bar.dart';
import 'home_screen.dart';
import 'data_screen.dart';
import 'tools_screen.dart';
import 'chat_screen.dart';

import 'package:strix/business_logic/logic/waiting_room_logic.dart';

class MainGameScreen extends StatefulWidget {
  static const String route_id = 'main_game_screen';
  final String docID;
  MainGameScreen({@required this.docID});

  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  List<Widget> listScreens;
  Stream<Room> roomStream;

  @override
  void initState() {
    super.initState();
    roomStream = WaitingRoomLogic().roomDocStream(widget.docID);
    listScreens = [
      HomeScreen(),
      DataScreen(),
      ToolsScreen(),
      ChatScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return

        //   Scaffold(
        //   body: StreamBuilder(
        //     stream:
        //         roomStream, //FirebaseFirestore.instance.collection('activeRooms').doc('KQPMEU').snapshots(),
        //     builder: (BuildContext context, AsyncSnapshot<Room> snapshot) {
        //       // check if stream is waiting for connection
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         // TODO: IMPLEMENT LOADING SCREEN
        //         return Center(child: Text('LOADING!'));
        //       }
        //       // check if stream has no data
        //       else if (snapshot.data == null) {
        //         return Center(child: Text('NO DATA!'));
        //       } else {
        //         return Container(
        //           color: Colors.green,
        //           child: Center(child: Text('TEST DATA: ${snapshot.data.roomID}')),
        //         );
        //       }
        //     },
        //   ),
        // );

        DefaultTabController(
      length: 4,
      child: Scaffold(
        body: SafeArea(child: TabBarView(children: listScreens)),
        bottomNavigationBar: BottomTabBar(),
        backgroundColor: Colors.grey[300],
      ),
    );
  }
}
