import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yclcounselor/messages/chatscreen.dart';
import 'package:yclcounselor/pageviewer.dart';
import 'dart:io' show Platform;

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);
  static const String routeName = '/userdashboard';

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

String? firstName;

class _UserDashboardState extends State<UserDashboard>
    with WidgetsBindingObserver {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    FirebaseFirestore.instance
        .collection("userNames")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen(
      (result) {
        for (var result in result.docs) {
          setState(() {
            firstName = result["firstName"];
          });
        }
      },
    );
    _requestPermissions();
    subscribeToTopic();
    initializeFCM();
    super.initState();
  }

  void _requestPermissions() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
  }

  void initializeFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'Crisis Help Notifications', // title
        importance: Importance.max,
        enableVibration: true,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        AppleNotification? apple = message.notification?.apple;
        if (notification != null && !kIsWeb) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: 'launch_background',
              ),
              iOS: const IOSNotificationDetails(
                presentAlert: true,
                presentSound: true,
              ),
            ),
          );
        }
      },
    );
  }

  subscribeToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic("counselors");
  }

  signInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously();
    if (kDebugMode) {
      print("Signed in with temporary account.");
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    const secondaryColor = Color(0xff00b894);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: Platform.isAndroid
              ? const EdgeInsets.only(left: 25)
              : const EdgeInsets.only(left: 0),
          child: Text(
            'Youth Crisis Line',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ChatScreen(),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.message,
          color: secondaryColor,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 37, 41, 41),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 40, right: 40, bottom: 40),
                child: Bounceable(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PageViewer(
                          title: "Log Call",
                          url: "https://www.tfaforms.com/4975994",
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: secondaryColor,
                    ),
                    child: Center(
                      child: Text(
                        'Log Call',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40, right: 40, left: 40),
                child: Bounceable(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PageViewer(
                          title: "Log Intervention",
                          url: "http://www.tfaforms.com/4976397",
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Log Intervention',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
