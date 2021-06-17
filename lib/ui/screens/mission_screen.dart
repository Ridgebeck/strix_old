import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/person.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/config/constants.dart';
import 'package:strix/ui/screens/profile_screen.dart';
import 'package:expandable/expandable.dart';

class MissionScreen extends StatelessWidget {
  final MissionEntry? missionData;
  MissionScreen({required this.missionData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expanded(
        //   flex: 11,
        //   child: ScreenHeader(
        //     title: 'mission',
        //     iconData: Icons.folder_open,
        //   ),
        // ),
        Expanded(
          flex: 89,
          child: missionData == null
              ? Container(
                  child: Center(
                    child: Text('No mission data available yet.'),
                  ),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  child: FractionallySizedBox(
                    widthFactor: 0.85,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.0),
                          Center(
                            child: FittedBox(
                              child: Text(
                                'Mission Objective: Find Derek',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            //color: Colors.green,
                            child: Column(
                              children: [
                                ExpandablePanel(
                                  header: Text(
                                    '1. Find the PIN for the tablet',
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  collapsed: Container(),
                                  expanded: Row(
                                    children: [
                                      SizedBox(width: 25.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('\u2022 help agent X to get access to the tablet'),
                                            Text('\u2022 it is a 6 digit code'),
                                            Text('\u2022 it might have to do with chess'),
                                            Text('\u2022 check the date on the chess trophy'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  theme: ExpandableThemeData(
                                    iconColor: Colors.blueGrey,
                                    iconSize: 20.0,
                                    iconPadding: EdgeInsets.all(0.0),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                ExpandablePanel(
                                  header: Text(
                                    '2. Find the location Derek went to',
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  collapsed: Container(),
                                  expanded: Row(
                                    children: [
                                      SizedBox(width: 25.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '\u2022 find the location Derek went to from his apartment'),
                                            Text(
                                                '\u2022 it might be related to one of his hobbies'),
                                            Text('\u2022 check the calendar from the tablet'),
                                            Text(
                                                '\u2022 the calendar entry seems to be a team name'),
                                            Text('\u2022 he might be going to a board game meetup'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  theme: ExpandableThemeData(
                                    iconColor: Colors.blueGrey,
                                    iconSize: 20.0,
                                    iconPadding: EdgeInsets.all(0.0),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                ExpandablePanel(
                                  header: Text(
                                    '3. Find the coffee shop',
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  collapsed: Container(),
                                  expanded: Row(
                                    children: [
                                      SizedBox(width: 25.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '\u2022 find the location Derek went to from his apartment'),
                                            Text(
                                                '\u2022 it might be related to one of his hobbies'),
                                            Text('\u2022 check the calendar from the tablet'),
                                            Text(
                                                '\u2022 the calendar entry seems to be a team name'),
                                            Text('\u2022 he might be going to a board game meetup'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  theme: ExpandableThemeData(
                                    iconColor: Colors.blueGrey,
                                    iconSize: 20.0,
                                    iconPadding: EdgeInsets.all(0.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 50.0),
                          missionData!.profileEntries == null
                              ? Container()
                              : Column(
                                  children: [
                                    Center(
                                      child: FittedBox(
                                        child: Text(
                                          'Profiles',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.0),
                                    Container(
                                      height: MediaQuery.of(context).size.width / 6,
                                      child: Center(
                                        child: ListView(
                                          physics: BouncingScrollPhysics(
                                              parent: AlwaysScrollableScrollPhysics()),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: List.generate(
                                            missionData!.profileEntries!.length,
                                            (index) => ProfileButton(
                                                person: missionData!.profileEntries![index]),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 50.0),
                                  ],
                                ),
                          Center(
                            child: FittedBox(
                              child: Text(
                                'Mission Briefing',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          missionData!.briefing == null
                              ? Text('No briefing available yet.')
                              : Text(
                                  missionData!.briefing!.replaceAll("\\n", "\n"),
                                  textAlign: TextAlign.justify,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    Key? key,
    required this.person,
  }) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Container(
          height: MediaQuery.of(context).size.width / 6,
          width: MediaQuery.of(context).size.width / 6,
          decoration: BoxDecoration(
            //color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(150.0),
            image: DecorationImage(
              image: AssetImage(
                'assets/profile_pictures/' + person.profileImage,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: RawMaterialButton(
            splashColor: kSplashColor,
            onPressed: () {
              Navigator.of(context).pushNamed(
                ProfileScreen.route_id,
                arguments: person,
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget buildProfileList(List<String> profileData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('\u2022 ' + profileData[0]),
      Text('\u2022 Age: 32'),
      Text('\u2022 Profession: Senior Programmer'),
      Text('\u2022 Hobbies: ?'), // Chess, Boardgames'),
      Text('\u2022 Instagram: ?'), // @McFlinty'),
    ],
  );
}
