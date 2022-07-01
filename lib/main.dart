import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:manabisnis/modules/env.dart';
import 'package:manabisnis/pages/start.dart';

import 'package:manabisnis/pages/website/dashboard.dart';
import 'package:manabisnis/pages/website/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Widget firstWidget;// = null;
    Map<String, Widget Function(BuildContext)> _Routes;
    /*
    Map<String, Widget Function(BuildContext)> webRoutes = {
      // When navigating to the "/" route,
      '/': (context) => WebStartPage(),
      '/login': (context) => WebLoginPage(),
      '/register': (context) => WebRegisterPage(),
    };
    Map<String, Widget Function(BuildContext)> mobRoutes = {
      // When navigating to the "/" route,
      '/': (context) => MobStartPage(),
    };
    */

    // Get the firebase user
    User? user = FirebaseAuth.instance.currentUser;
    // Assign widget based on availability of currentUser

    if (Env.getPlatform() == 'WEB') {
      //firstWidget = WebStartPage();
      if (user != null) {
        firstWidget = WebDashboardPage(user: user);
      } else {
        firstWidget = WebLoginPage();
      }
      //_Routes = webRoutes;
    } else { // MOBILE PLATFORM
      firstWidget = StartPage(title: 'Flutter Demo Home Page');
      //if (user != null) {
      //  firstWidget = MobDashboardPage(user: user);
      //} else {
      //  firstWidget = MobLoginPage();
      //}
      //_Routes = mobRoutes;
    }


    // app themes
    bool _isDark = false;
    ThemeData _light = ThemeData.light().copyWith(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      backgroundColor: Colors.white10,
      appBarTheme: AppBarTheme(
        color: Colors.white70,
        foregroundColor: Colors.white54,
        titleTextStyle: TextStyle(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      iconTheme: IconThemeData(color: Colors.black54),

      //appBarTheme: const AppBarTheme()
    );
    ThemeData _dark = ThemeData.dark().copyWith(
      brightness: Brightness.light,
      primaryColor: Colors.black,
      backgroundColor: Colors.black12,
      appBarTheme: AppBarTheme(
        color: Colors.black87,
        foregroundColor: Colors.black54,
        titleTextStyle: TextStyle(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white70),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: _dark,
      theme: _light,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home:  firstWidget, //const StartPage(title: 'Flutter Demo Home Page'),
    );
  }
}
