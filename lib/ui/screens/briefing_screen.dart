import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:strix/business_logic/logic/start_room_logic.dart';
import 'package:strix/config/test_styles.dart';
import 'package:strix/ui/screens/waiting_room_screen.dart';
import 'package:strix/ui/widgets/bordered_button.dart';
import 'package:strix/ui/widgets/top_icon.dart';

import 'join_room_screen.dart';

class BriefingScreen extends StatefulWidget {
  static const String route_id = 'briefing_screen';

  @override
  _BriefingScreenState createState() => _BriefingScreenState();
}

class _BriefingScreenState extends State<BriefingScreen> with SingleTickerProviderStateMixin {
  int _index = 0;
  late Animation _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // build TextStyles based on screen size
    TextStyles textStyles = TextStyles(context: context);

    List<Map<String, dynamic>> stringList = [
      {
        'title': 'the agency',
        'text': RichText(
          text: TextSpan(
            style: textStyles.stdTextStyle,
            children: [
              TextSpan(text: 'STRIX, the leading global agency to '),
              TextSpan(
                text: 'fight digital crime',
                style: textStyles.boldTextStyle,
              ),
              TextSpan(text: ', has recruited you as an ISA - Intelligence Support Agent.'),
            ],
          ),
        ),
      },
      {
        'title': 'your team',
        'text': RichText(
          text: TextSpan(
            style: textStyles.stdTextStyle,
            children: [
              TextSpan(text: 'You need to assemble a team of '),
              TextSpan(
                text: '2-4 ISAs',
                style: textStyles.boldTextStyle,
              ),
              TextSpan(text: '. Your team will remotely support our field agent.'),
            ],
          ),
        ),
      },
      {
        'title': 'cooperation',
        'text': RichText(
          text: TextSpan(
            style: textStyles.stdTextStyle,
            children: [
              TextSpan(
                text: 'The key to mission success will be collaboration. '
                    'All support agents should therefore be in the ',
              ),
              TextSpan(
                text: 'same location.',
                style: textStyles.boldTextStyle,
              ),
            ],
          ),
        ),
      },
      {
        'title': 'estimated time',
        'text': RichText(
          text: TextSpan(
            style: textStyles.stdTextStyle,
            children: [
              TextSpan(text: 'We heard good things about you. This mission should take about '),
              TextSpan(
                text: '60-90 minutes',
                style: textStyles.boldTextStyle,
              ),
              TextSpan(text: ', but we believe you can be quicker than that.'),
            ],
          ),
        ),
      },
      {
        'title': 'setup',
        'text': RichText(
          text: TextSpan(
            style: textStyles.stdTextStyle,
            children: [
              TextSpan(text: 'One of you needs to start a session to create a '),
              TextSpan(
                text: 'session ID',
                style: textStyles.boldTextStyle,
              ),
              TextSpan(
                  text: '. The other agents can then join the session to synchronize your data.'),
            ],
          ),
        ),
      },
      {
        'title': 'mission details',
        'text': RichText(
          text: TextSpan(
            style: textStyles.stdTextStyle,
            children: [
              TextSpan(
                  text:
                      'Once everybody is in and your apps are synchronized, you will receive further '
                      'instructions through the '),
              TextSpan(
                text: 'STRIX mission control app.', // todo: change to actual app name
                style: textStyles.boldTextStyle,
              ),
            ],
          ),
        ),
      },
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'strixIcon',
                          child: TopIcon(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                    flex: 12,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.translationValues(_animation.value * 500, 0.0, 0.0),
                          child: PageView.builder(
                            itemCount: stringList.length,
                            controller: PageController(viewportFraction: 0.8),
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (int index) {
                              setState(() {
                                _index = index;
                              });
                            },
                            itemBuilder: (BuildContext context, int i) {
                              return AnimatedContainer(
                                margin: EdgeInsets.symmetric(
                                  vertical: i == _index ? 0.0 : 15.0,
                                  horizontal: 10.0,
                                ),
                                //padding: EdgeInsets.all(15.0),
                                duration: Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: i == _index
                                      ? Colors.grey.shade200.withOpacity(0.3)
                                      : Colors.greenAccent
                                          .withOpacity(max(0.0, 0.5 * (1 - _animation.value * 5))),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                    child: Row(
                                      children: [
                                        Expanded(child: Container()),
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            children: [
                                              Expanded(flex: 2, child: Container()),
                                              Expanded(
                                                flex: 3,
                                                child: FittedBox(
                                                  child: Text(
                                                    stringList[i]['title'] ?? 'title',
                                                    style: textStyles.headerTextStyle,
                                                  ),
                                                ),
                                              ),
                                              Expanded(flex: 1, child: Container()),
                                              Expanded(flex: 16, child: stringList[i]['text']),
                                              Expanded(flex: 2, child: Container()),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(flex: 2, child: Container()),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        String? roomID = await StartRoomLogic().addRoom();
                        if (roomID == null) {
                          print('ERROR: could not add new game');
                          // TODO: show error pop up when game cannot be created
                        } else {
                          _animationController.animateTo(0.0);
                          Navigator.of(context).pushReplacementNamed(
                            WaitingRoomScreen.route_id,
                            arguments: roomID,
                          );
                        }
                      },
                      child: Hero(
                        tag: 'button1',
                        child: Material(
                          color: Colors.transparent,
                          child: BorderedButton(
                            buttonText: 'start session',
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: Container()),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _animationController.animateTo(0.0);
                        Navigator.of(context).pushReplacementNamed(JoinRoomScreen.route_id);
                      },
                      child: Hero(
                        tag: 'button2',
                        child: Material(
                          color: Colors.transparent,
                          child: BorderedButton(
                            buttonText: 'join session',
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: Container()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
