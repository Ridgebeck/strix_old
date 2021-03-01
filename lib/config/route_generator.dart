import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/ui/screens/game_setup.dart';
import 'package:strix/ui/screens/join_room_screen.dart';
import 'package:strix/ui/screens/picture_screen.dart';
import 'package:strix/ui/screens/start_join_screen.dart';
import 'package:strix/ui/screens/waiting_room_screen.dart';
import 'package:strix/ui/screens/main_game_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      // case StartJoinScreen.route_id:
      //   return MaterialPageRoute(
      //     builder: (_) => StartJoinScreen(),
      //   );
      // case WaitingRoomScreen.route_id:
      //   if (args is String) {
      //     return MaterialPageRoute(
      //       builder: (_) => WaitingRoomScreen(docID: args),
      //     );
      //   }
      //   return _errorRoute();
      // case JoinRoomScreen.route_id:
      //   return MaterialPageRoute(
      //     builder: (_) => JoinRoomScreen(),
      //   );
      case MainGameScreen.route_id:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => MainGameScreen(docID: args),
          );
        }
        return _errorRoute();
      case PictureScreen.route_id:
        return MaterialPageRoute(
          builder: (_) => PictureScreen(),
        );
      case GameSetup.route_id:
        return MaterialPageRoute(
          builder: (_) => GameSetup(),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
