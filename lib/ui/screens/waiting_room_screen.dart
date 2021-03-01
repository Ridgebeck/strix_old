import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/player.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/business_logic/logic/waiting_room_logic.dart';
import 'package:strix/services/service_locator.dart';
import 'package:strix/services/authorization/authorization_abstract.dart';
import 'package:strix/config/constants.dart';

import 'main_game_screen.dart';

class WaitingRoomScreen extends StatelessWidget {
  final String docID;
  final Function changeStatus;
  WaitingRoomScreen({
    @required this.docID,
    @required this.changeStatus,
  });

  final Authorization _authorization = serviceLocator<Authorization>();

  @override
  Widget build(BuildContext context) {
    final Stream<Room> roomStream = WaitingRoomLogic().roomDocStream(docID);
    bool leave = false;

    return StreamBuilder(
        stream: roomStream,
        builder: (BuildContext context, AsyncSnapshot<Room> snapshot) {
          // add callback to check for gamProgress change
          // after every frame and move to game screen
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (snapshot.data != null && snapshot.data.gameProgress != kWaitingStatus) {
                // pop complete stack and move to the main game screen
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MainGameScreen.route_id, (Route<dynamic> route) => false,
                    arguments: docID);
              }
            },
          );

          // check if stream is waiting for connection
          if (snapshot.connectionState == ConnectionState.waiting) {
            // TODO: IMPLEMENT LOADING SCREEN
            return Center(child: Text('LOADING!'));
          }
          // check if stream has no data
          else if (snapshot.data == null) {
            if (leave == true) {
              changeStatus(statusType.landing);
              return Container();
            } else {
              // TODO: show popup when data is null accidentally
              print('NO DATA COULD BE FETCHED!');
              changeStatus(statusType.landing);
              return Container();
            }
          } else {
            Player thisPlayer;
            try {
              for (Player player in snapshot.data.players) {
                if (player.uid == _authorization.getCurrentUserID()) {
                  thisPlayer = player;
                  break;
                }
              }
            } catch (e) {
              print('Stream already closed. Player data error: $e');
            }
            return SafeArea(
              child: Row(
                children: [
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                    flex: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 1, child: Container()),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/pictures/owl_logo.png'),
                              ),
                            ),
                          ),
                        ),
                        Expanded(flex: 1, child: Container()),
                        Expanded(flex: 1, child: Text('Welcome, Agent ${thisPlayer.name}')),
                        Expanded(flex: 1, child: Text('Your Mission: ${snapshot.data.gameTitle}')),
                        Expanded(flex: 1, child: Text('Mission Code: ${snapshot.data.roomID}')),
                        Expanded(
                            flex: 1,
                            child: Text(' ${snapshot.data.players.length} of '
                                '${snapshot.data.maximumPlayers} Agents online')),
                        Expanded(
                          flex: 5,
                          child: ListView.builder(
                            itemCount: snapshot.data.players.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final player = snapshot.data.players[index];
                              return Row(
                                children: [
                                  Expanded(flex: 1, child: Container()),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Icon(
                                          player.iconData,
                                          color: player.color,
                                        ),
                                        SizedBox(width: 10.0),
                                        Text(
                                          player.name,
                                          style: TextStyle(
                                            fontWeight:
                                                player.uid == _authorization.getCurrentUserID()
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.left,
                                          //style: TextStyle(color: player.color),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              onPressed: () async {
                                // leave the room
                                leave = await WaitingRoomLogic().leaveRoom(
                                  context: context,
                                  roomID: snapshot.data.roomID,
                                  numberPlayers: snapshot.data.players.length,
                                );
                                if (leave == true) {
                                  changeStatus(statusType.landing);
                                  // TODO: delete document after leaving page
                                  print('DELETE ROOM DATA HERE!');
                                }
                              },
                              child: Text('back'),
                            ),
                            FlatButton(
                              onPressed: () async {
                                // try to start the game
                                await WaitingRoomLogic().startGame(
                                  context: context,
                                  numberPlayers: snapshot.data.players.length,
                                  minimumPlayers: snapshot.data.minimumPlayers,
                                  roomID: snapshot.data.roomID,
                                );
                              },
                              child: Text(
                                'start',
                                style: TextStyle(
                                    color:
                                        snapshot.data.players.length >= snapshot.data.minimumPlayers
                                            ? Colors.green
                                            : Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Expanded(flex: 1, child: Container()),
                      ],
                    ),
                  ),
                  Expanded(flex: 1, child: Container()),
                ],
              ),
            );
          }
        });
  }
}

//
//
// class WaitingRoomScreen2 extends StatefulWidget {
//   static const String route_id = 'waiting_room_screen';
//   final String docID;
//   WaitingRoomScreen({@required this.docID});
//
//   @override
//   _WaitingRoomScreenState createState() => _WaitingRoomScreenState();
// }
//
// class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
//   final Authorization _authorization = serviceLocator<Authorization>();
//   VideoPlayerController _controller;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final Stream<Room> roomStream = WaitingRoomLogic().roomDocStream(widget.docID);
//     bool leave = false;
//
//     return WillPopScope(
//       // prevent going back via system
//       onWillPop: () async => false,
//       child: Scaffold(
//         //backgroundColor: Colors.transparent,
//         body: Stack(
//           children: [
//             SizedBox.expand(
//               child: FittedBox(
//                 fit: BoxFit.cover,
//                 child: SizedBox(
//                   width: _controller.value.size?.width ?? 0,
//                   height: _controller.value.size?.height ?? 0,
//                   child: _controller.value.initialized
//                       ? AspectRatio(
//                           aspectRatio: _controller.value.aspectRatio,
//                           child: VideoPlayer(_controller),
//                         )
//                       : Container(),
//                 ),
//               ),
//             ),
//             StreamBuilder(
//                 stream: roomStream,
//                 builder: (BuildContext context, AsyncSnapshot<Room> snapshot) {
//                   // add callback to check for gamProgress change
//                   // after every frame and move to game screen
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     if (snapshot.data != null && snapshot.data.gameProgress != kWaitingStatus) {
//                       // pop complete stack and move to the main game screen
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                           MainGameScreen.route_id, (Route<dynamic> route) => false,
//                           arguments: widget.docID);
//                     }
//                   });
//
//                   // check if stream is waiting for connection
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     // TODO: IMPLEMENT LOADING SCREEN
//                     return Center(child: Text('LOADING!'));
//                   }
//                   // check if stream has no data
//                   else if (snapshot.data == null) {
//                     return Center(child: Text('NO DATA!'));
//                   } else {
//                     Player thisPlayer;
//                     try {
//                       for (Player player in snapshot.data.players) {
//                         if (player.uid == _authorization.getCurrentUserID()) {
//                           thisPlayer = player;
//                           break;
//                         }
//                       }
//                     } catch (e) {
//                       print('Stream already closed. Player data error: $e');
//                     }
//                     return SafeArea(
//                       child: Row(
//                         children: [
//                           Expanded(flex: 1, child: Container()),
//                           Expanded(
//                             flex: 15,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Expanded(flex: 1, child: Container()),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         image: AssetImage('assets/pictures/owl_logo.png'),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(flex: 1, child: Container()),
//                                 Expanded(flex: 1, child: Text('Welcome, Agent ${thisPlayer.name}')),
//                                 Expanded(
//                                     flex: 1,
//                                     child: Text('Your Mission: ${snapshot.data.gameTitle}')),
//                                 Expanded(
//                                     flex: 1, child: Text('Mission Code: ${snapshot.data.roomID}')),
//                                 Expanded(
//                                     flex: 1,
//                                     child: Text(' ${snapshot.data.players.length} of '
//                                         '${snapshot.data.maximumPlayers} Agents online')),
//                                 Expanded(
//                                   flex: 5,
//                                   child: ListView.builder(
//                                     itemCount: snapshot.data.players.length,
//                                     physics: NeverScrollableScrollPhysics(),
//                                     itemBuilder: (context, index) {
//                                       final player = snapshot.data.players[index];
//                                       return Row(
//                                         children: [
//                                           Expanded(flex: 1, child: Container()),
//                                           Expanded(
//                                             flex: 2,
//                                             child: Row(
//                                               children: [
//                                                 Icon(
//                                                   player.iconData,
//                                                   color: player.color,
//                                                 ),
//                                                 SizedBox(width: 10.0),
//                                                 Text(
//                                                   player.name,
//                                                   style: TextStyle(
//                                                     fontWeight: player.uid ==
//                                                             _authorization.getCurrentUserID()
//                                                         ? FontWeight.bold
//                                                         : FontWeight.normal,
//                                                   ),
//                                                   textAlign: TextAlign.left,
//                                                   //style: TextStyle(color: player.color),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     FlatButton(
//                                       onPressed: () async {
//                                         // leave the room
//                                         leave = await WaitingRoomLogic().leaveRoom(
//                                           context: context,
//                                           roomID: snapshot.data.roomID,
//                                           numberPlayers: snapshot.data.players.length,
//                                         );
//                                         if (leave == true) {
//                                           Navigator.pop(context);
//                                           // TODO: delete document after leaving page
//                                           print('DELETE ROOM DATA HERE!');
//                                         }
//                                       },
//                                       child: Text('back'),
//                                     ),
//                                     FlatButton(
//                                       onPressed: () async {
//                                         // try to start the game
//                                         await WaitingRoomLogic().startGame(
//                                           context: context,
//                                           numberPlayers: snapshot.data.players.length,
//                                           minimumPlayers: snapshot.data.minimumPlayers,
//                                           roomID: snapshot.data.roomID,
//                                         );
//                                       },
//                                       child: Text(
//                                         'start',
//                                         style: TextStyle(
//                                             color: snapshot.data.players.length >=
//                                                     snapshot.data.minimumPlayers
//                                                 ? Colors.green
//                                                 : Colors.black),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Expanded(flex: 1, child: Container()),
//                               ],
//                             ),
//                           ),
//                           Expanded(flex: 1, child: Container()),
//                         ],
//                       ),
//                     );
//                   }
//                 }),
//           ],
//         ),
//       ),
//     );
//   }
// }
