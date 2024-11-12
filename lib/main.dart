import 'dart:io';

import 'package:flutter/material.dart';

import 'package:nirmiti_app/Screens/Call_access.dart';
import 'package:nirmiti_app/Screens/Call_access_contact.dart';
import 'package:nirmiti_app/Screens/Dashboard.dart';
import 'package:nirmiti_app/Screens/DefaultappSet.dart';
import 'package:nirmiti_app/Screens/Splash.dart';
import 'package:nirmiti_app/Screens/login.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/contactScreen': (context) => contactAccess(),
        '/callScreen': (context) => callAccess(),
        '/calllogScreen': (context) => dashboard(),
        '/login': (context) => Login(),
        '/deault': (context) => defaultAPP(),
      },
      title: 'Nirmiti App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: splash(),
    );
  }
}
