import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strix/config/route_generator.dart';
import 'package:strix/services/service_locator.dart';
import 'package:strix/services/authorization/authorization_abstract.dart';
import 'package:strix/ui/screens/main_game_screen.dart';
import 'package:strix/ui/screens/start_join_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // fix app orientation to portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // initialize all services (database, auth, storage)
  await setupServices();

  // sign in user anonymously
  await serviceLocator<Authorization>().signInUserAnonymous();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: StartJoinScreen.route_id, //MainGameScreen.route_id,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
