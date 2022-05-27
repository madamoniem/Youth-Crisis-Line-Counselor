import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yclcounselor/authentication/login.dart';
import 'package:yclcounselor/messages/chatscreen.dart';
import 'package:yclcounselor/userDashboard.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn = (prefs.getString('isLoggedIn') == null)
      ? "loggedOut"
      : prefs.getString('isLoggedIn');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // routes: <String, WidgetBuilder>{
      //   UserDashboard.routeName: (_) => const UserDashboard(),
      //   ChatScreen.routeName: (_) => const ChatScreen(),
      // },
      home:
          isLoggedIn == "loggedIn" ? const UserDashboard() : const LoginPage(),
    ),
  );
}

initState(void initState, void print) {
  throw Exception("This is a crash!");
}
