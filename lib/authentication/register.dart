import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yclcounselor/userDashboard.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? errorMessage;
  final _auth = FirebaseAuth.instance;
  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  String? fcmToken;

  getToken() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  subscribeToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic("counselors");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xff252929),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Icon(
                FontAwesomeIcons.chevronLeft,
              ),
            ),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    top: 30,
                    right: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Let\'s Get Started',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 35,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Let\'s Get You Signed Up.',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        controller: emailEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          labelText: 'Email',
                          labelStyle: GoogleFonts.poppins(color: Colors.white),
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              width: 3,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        controller: firstNameEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          labelText: 'First Name',
                          labelStyle: GoogleFonts.poppins(color: Colors.white),
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              width: 3,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        controller: secondNameEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          labelText: 'Last Name',
                          labelStyle: GoogleFonts.poppins(color: Colors.white),
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              width: 3,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        controller: passwordEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          labelText: 'Password',
                          labelStyle: GoogleFonts.poppins(color: Colors.white),
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              width: 3,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ButtonTheme(
                        minWidth: 200.0,
                        height: 100.0,
                        child: ElevatedButton(
                          onPressed: () {
                            signUp(
                              emailEditingController.text.trim(),
                              passwordEditingController.text.trim(),
                            );
                            subscribeToTopic();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            minimumSize:
                                const Size(double.infinity, 60), //////// HERE
                          ),
                          child: Text(
                            'Register',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: const Color(0xff252929),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
          (value) => {
            postDetailsToFirestore(),
            saveData(),
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const UserDashboard()),
                (route) => route.isFirst),
          },
        )
        .catchError(
      (e) {
        switch (e.code) {
          case "invalid-email":
            Fluttertoast.showToast(
                msg: "Your email address appears to be malformed.");
            break;
          case "wrong-password":
            Fluttertoast.showToast(msg: "Your password is wrong.");
            break;
          case "user-not-found":
            Fluttertoast.showToast(msg: "User with this email doesn't exist.");
            break;
          case "user-disabled":
            Fluttertoast.showToast(
                msg: "User with this email has been disabled.");
            break;
          case "too-many-requests":
            Fluttertoast.showToast(msg: errorMessage = "Too many requests");
            break;
          case "operation-not-allowed":
            Fluttertoast.showToast(
                msg: "Signing in with Email and Password is not enabled.");
            break;
          default:
            Fluttertoast.showToast(msg: "An undefined Error happened.");
        }
      },
    );
  }

  saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', emailEditingController.text);
  }

  postDetailsToFirestore() async {
    FirebaseFirestore.instance.collection('userNames').add(
      {
        'deviceToken': fcmToken.toString(),
        'firstName': firstNameEditingController.text.toTitleCase(),
        'lastName': secondNameEditingController.text.toTitleCase(),
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'date': DateFormat("MMMM dd, yyyy").format(DateTime.now()),
        'time': DateFormat("hh:mm:ss a").format(DateTime.now()),
        'rating': 0,
        'donationsCompleted': 0,
        'peopleHelped': 0,
        'foodSaved': 0,
        'hoursVolunteered': 0,
      },
    ).then(
      (value) {
        Fluttertoast.showToast(msg: "Account created successfully!");
      },
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
