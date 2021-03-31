import 'package:flutter/material.dart';
import 'package:strix/ui/screens/briefing_screen.dart';
import 'package:strix/ui/screens/icoming_call_screen.dart';
import 'package:strix/ui/screens/join_room_screen.dart';
import 'package:strix/ui/screens/landing_screen.dart';
import 'package:strix/ui/screens/picture_screen.dart';
import 'package:strix/ui/screens/standby_screen.dart';
import 'package:strix/ui/screens/start_join_screen.dart';
import 'package:strix/ui/screens/video_background.dart';
import 'package:strix/ui/screens/waiting_room_screen.dart';
import 'package:strix/ui/screens/main_game_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case VideoBackground.route_id:
        return MaterialPageRoute(
          builder: (_) => VideoBackground(),
        );

      case LandingScreen.route_id:
        return PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) {
            return (LandingScreen());
          },
          transitionDuration: Duration(milliseconds: 1400),
        );

      case BriefingScreen.route_id:
        return PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) {
            return BriefingScreen();
          },
          transitionDuration: Duration(milliseconds: 1400),
        );

      case StartJoinScreen.route_id:
        return PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) {
            return (StartJoinScreen());
          },
        );

      case WaitingRoomScreen.route_id:
        if (arguments is String) {
          return PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) {
              return WaitingRoomScreen(roomID: arguments);
            },
            transitionDuration: Duration(milliseconds: 1400),
          );
        }
        return _errorRoute();

      case JoinRoomScreen.route_id:
        return PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) {
            return (JoinRoomScreen());
          },
          transitionDuration: Duration(milliseconds: 1400),
        );

      case MainGameScreen.route_id:
        if (arguments is String) {
          return PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, _, __) {
              return (MainGameScreen(
                roomID: arguments,
              ));
            },
          );

          //MaterialPageRoute(builder: (_) => MainGameScreen(docID: args));
        }
        return // _errorRoute();
            // TODO: remove
            PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) {
            return (MainGameScreen(
              roomID: 'XOJKVE',
            ));
          },
        );

      case PictureScreen.route_id:
        return MaterialPageRoute(
          builder: (_) => PictureScreen(),
        );

      case StandbyScreen.route_id:
        return MaterialPageRoute(
          builder: (_) => StandbyScreen(),
        );

      case IncomingCallScreen.route_id:
        return MaterialPageRoute(
          builder: (_) => IncomingCallScreen(),
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

class FadeRoute extends PageRouteBuilder {
  final Widget? page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page!,
          opaque: false,
          transitionDuration: Duration(milliseconds: 500),
          reverseTransitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
