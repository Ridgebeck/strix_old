import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:strix/config/constants.dart';
import 'package:strix/ui/screens/picture_screen.dart';
import 'package:strix/ui/widgets/screen_header.dart';

class DataScreen extends StatefulWidget {
  final AvailableAssetEntry assets;
  DataScreen({required this.assets});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final int numberOfCards = 4;
  String selection = "Menu";

  void changeSelection(String value) {
    setState(() {
      selection = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 11,
          child: ScreenHeader(
            title: 'data',
            iconData: Icons.cloud_outlined,
          ),
        ),
        Expanded(
          flex: 89,
          child: Row(
            children: [
              Expanded(flex: 5, child: Container()),
              Expanded(
                flex: 90,
                child: displaySelection(selection, changeSelection, widget.assets),
              ),
              Expanded(flex: 5, child: Container()),
            ],
          ),
        ),
      ],
    );
  }
}

Widget displaySelection(String selection, Function changeSelection, AvailableAssetEntry assets) {
  switch (selection) {
    case "Menu":
      {
        return DataScreenMenu(changeSelection: changeSelection, data: assets.data);
      }
    case "Reports":
      {
        //return ReportsScreen(changeSelection: changeSelection);
        return DataSelectionScreen(changeSelection: changeSelection, data: assets.data!.reports!);
      }
    case "Messages":
      {
        return DataSelectionScreen(changeSelection: changeSelection, data: assets.data!.messages!);
      }
    case "Images":
      {
        return DataSelectionScreen(changeSelection: changeSelection, data: assets.data!.pictures!);
      }
    case "Videos":
      {
        return DataSelectionScreen(changeSelection: changeSelection, data: assets.data!.videos!);
      }
    case "Audio":
      {
        return DataSelectionScreen(
            changeSelection: changeSelection, data: assets.data!.audioFiles!);
      }
    default:
      {
        return DataScreenMenu(changeSelection: changeSelection, data: assets.data);
      }
  }
}

class ReportsScreen extends StatefulWidget {
  final Function changeSelection;
  const ReportsScreen({
    required this.changeSelection,
  });

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  static const List<String> headers = [
    'City',
    'Population',
    'Land Area',
    'Density',
  ];

  static const List<String> cities = [
    'New York',
    'Los Angles',
    'Chicago',
  ];

  static const List<double> population = [
    1,
    2,
    3,
  ];

  static const List<double> area = [
    100,
    200,
    300,
  ];

  static const List<double> density = [
    1000,
    2000,
    3000,
  ];

  List<bool> selected = List<bool>.generate(cities.length, (int index) => false);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.greenAccent,
      child: Column(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                widget.changeSelection('Menu');
              },
              child: Center(child: Text('Back')),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              //color: Colors.red,
              child: RotatedBox(
                quarterTurns: 0,
                child: DataTable(
                  showCheckboxColumn: false,
                  columnSpacing: 20.0,
                  columns: List<DataColumn>.generate(
                    headers.length,
                    (int index) => DataColumn(label: Text(headers[index]), numeric: false),
                  ),

                  // [
                  //   DataColumn(label: Text('City'), numeric: false),
                  //   // DataColumn(label: Text('Population'), numeric: true),
                  //   // DataColumn(label: Text('Area'), numeric: true),
                  //   // DataColumn(label: Text('Density'), numeric: true),
                  // ],
                  rows: List<DataRow>.generate(
                    cities.length,
                    (int index) => DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                        // All rows will have the same selected color.
                        if (states.contains(MaterialState.selected)) {
                          return Colors.greenAccent;
                        }
                        // Even rows will have a grey color.
                        if (index.isEven) {
                          return Colors.grey.withOpacity(0.3);
                        }
                        return null; // Use default value for other states and odd rows.
                      }),
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            cities[index],
                            style: selected[index]
                                ? TextStyle(decoration: TextDecoration.lineThrough)
                                : TextStyle(),
                          ),
                        ),
                        DataCell(Text(population[index].toString())),
                        DataCell(Text(area[index].toString())),
                        DataCell(Text(density[index].toString())),
                      ],
                      selected: selected[index],
                      onSelectChanged: (bool? value) {
                        setState(() {
                          selected[index] = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DataSelectionScreen extends StatelessWidget {
  final Function changeSelection;
  final List<String> data;
  const DataSelectionScreen({
    required this.changeSelection,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () {
                changeSelection('Menu');
              },
              child: Text('BACK'),
            ),
          ),
          Expanded(
            flex: 9,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                childAspectRatio: 0.65,
                //crossAxisSpacing: 20,
                //mainAxisSpacing: 20,
              ),
              itemCount: data.length,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        PictureScreen.route_id,
                        arguments: data[index],
                      );
                    },
                    child: Neumorphic(
                      style: (NeumorphicStyle(
                        depth: 3.0,
                        intensity: 1.0,
                        color: kBackgroundColorLight,
                      )),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/pictures/' + data[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DataScreenMenu extends StatelessWidget {
  final Function changeSelection;
  final DataEntry? data;
  const DataScreenMenu({
    required this.changeSelection,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blue,
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(),
          ),
          Expanded(
            flex: 80,
            child: data == null
                ? Container() // TODO: What to show when no data at all is present?
                : Column(
                    children: [
                      data!.messages == null
                          ? Container()
                          : MenuTile(
                              title: 'Messages',
                              iconData: Icons.message,
                              changeSelection: changeSelection,
                            ),
                      data!.pictures == null
                          ? Container()
                          : MenuTile(
                              title: 'Images',
                              iconData: Icons.camera_alt,
                              changeSelection: changeSelection,
                            ),
                      data!.videos == null
                          ? Container()
                          : MenuTile(
                              title: 'Videos',
                              iconData: Icons.video_collection,
                              changeSelection: changeSelection,
                            ),
                      data!.audioFiles == null
                          ? Container()
                          : MenuTile(
                              title: 'Audio',
                              iconData: Icons.audiotrack_outlined,
                              changeSelection: changeSelection,
                            ),
                      data!.reports == null
                          ? Container()
                          : MenuTile(
                              title: 'Reports',
                              iconData: Icons.folder_open,
                              changeSelection: changeSelection,
                            ),
                      Expanded(
                        flex: data!.categories() - data!.length(),
                        child: Container(),
                      ),
                    ],
                  ),
          ),
          Expanded(
            flex: 10,
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function changeSelection;
  const MenuTile({
    Key? key,
    required this.iconData,
    required this.title,
    required this.changeSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FractionallySizedBox(
        widthFactor: 0.85,
        heightFactor: 0.8,
        child: NeumorphicButton(
          style: NeumorphicStyle(
            color: kBackgroundColorLight,
            depth: 5.0,
            intensity: 0.8,
          ),
          onPressed: () {
            changeSelection(title);
          },
          provideHapticFeedback: true,
          child: Column(
            children: [
              Expanded(child: Container()),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          color: kBackgroundColorLight,
                          depth: -2.0,
                          intensity: 1.0,
                        ),
                        child: FractionallySizedBox(
                          heightFactor: 0.7,
                          widthFactor: 0.7,
                          child: FittedBox(
                            child: Icon(
                              iconData,
                              size: 150.0,
                              color: Colors.blueGrey[300],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Expanded(
                      flex: 10,
                      child: Container(
                        child: Column(
                          children: [
                            Expanded(child: Container()),
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 50.0,
                                      color: Colors.blueGrey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
