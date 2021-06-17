import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:strix/business_logic/classes/call.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/config/constants.dart';
import 'package:wakelock/wakelock.dart';
import 'call_screen.dart';

class IncomingCallScreen extends StatefulWidget {
  static const String route_id = 'incoming_call_screen';

  final Room room;
  IncomingCallScreen({required this.room});

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  late Call call;

  @override
  void initState() {
    // enable wakelock to prevent screen turning off
    Wakelock.enable();
    // find current progress entry
    AvailableAssetEntry currentEntry = widget.room.availableAssets
        .singleWhere((element) => element.entryName == widget.room.gameProgress);
    // get call of current entry
    call = currentEntry.call!; //has been null checked on main screen
    FlutterRingtonePlayer.playRingtone(asAlarm: true);
    super.initState();
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kBackgroundColorLight,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(flex: 4, child: Container()),
              Expanded(
                flex: 3,
                child: FractionallySizedBox(
                  widthFactor: 0.75,
                  child: FittedBox(
                    child: Text(
                      'incoming call'.toUpperCase(),
                      style: TextStyle(fontSize: 75.0),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: FittedBox(
                    child: Text(
                      'via secured line',
                      style: TextStyle(fontSize: 75.0),
                    ),
                  ),
                ),
              ),
              Expanded(flex: 3, child: Container()),
              Expanded(
                flex: 20,
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 4.0,
                    intensity: 0.9,
                    boxShape: NeumorphicBoxShape.circle(),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return MirrorAnimation<double>(
                          tween: Tween<double>(
                            begin: constraints.maxHeight,
                            end: 0.96 * constraints.maxHeight,
                          ),
                          duration: Duration(milliseconds: 500),
                          builder: (context, child, animatedSize) {
                            return Container(
                              width: animatedSize,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/profile_pictures/${call.person.profileImage}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
              Expanded(flex: 3, child: Container()),
              Expanded(
                flex: 3,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: FittedBox(
                    child: Text(
                      (call.person.firstName + ' ' + call.person.lastName).toUpperCase(),
                      style: TextStyle(fontSize: 75.0),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: FittedBox(
                    child: Text(
                      call.person.title,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              Expanded(flex: 6, child: Container()),
              Expanded(
                flex: 5,
                child: Container(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CallButton(
                            iconData: Icons.call,
                            iconColor: Colors.green,
                            onTapFunction: () {
                              FlutterRingtonePlayer.stop();
                              Navigator.of(context).pushReplacementNamed(CallScreen.route_id,
                                  arguments: widget.room);
                            },
                          ),
                          CallButton(
                            iconData: Icons.call_end,
                            iconColor: Colors.red,
                            onTapFunction: () {},
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Expanded(flex: 3, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}

class CallButton extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Function onTapFunction;
  CallButton({
    required this.iconData,
    required this.iconColor,
    required this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        color: kBackgroundColorLight,
        depth: 3.0,
        intensity: 0.9,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      onPressed: () => onTapFunction(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxHeight,
            child: FractionallySizedBox(
              heightFactor: 0.65,
              child: FittedBox(
                child: Icon(
                  iconData,
                  size: 50.0,
                  color: iconColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
