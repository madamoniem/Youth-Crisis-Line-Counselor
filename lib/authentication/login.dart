import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yclcounselor/authentication/register.dart';
import 'package:yclcounselor/userDashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  SharedPreferences? prefs;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color(0xffD7F4E3),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/images/YCLlogo.png',
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [],
                    color: Color(0xff00b894),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 60,
                          left: 40,
                          right: 40,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Welcome Back',
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
                                'Let\'s Get You Signed In.',
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
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(20),
                                labelText: 'Email',
                                labelStyle:
                                    GoogleFonts.poppins(color: Colors.white),
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
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.white),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(color: Colors.white),
                              controller: passwordEditingController,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(20),
                                labelText: 'Password',
                                labelStyle:
                                    GoogleFonts.poppins(color: Colors.white),
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
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.white),
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
                                  subscribeToTopic();
                                  _auth
                                      .signInWithEmailAndPassword(
                                          email: emailEditingController.text,
                                          password:
                                              passwordEditingController.text)
                                      .then(
                                        (uid) async => {
                                          prefs = await SharedPreferences
                                              .getInstance(),
                                          await prefs!.setString(
                                              'isLoggedIn', 'loggedIn'),
                                          Fluttertoast.showToast(
                                              msg: "Login Successful"),
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const UserDashboard(),
                                            ),
                                          ),
                                        },
                                      )
                                      .catchError(
                                    (e) {
                                      switch (e.code) {
                                        case "invalid-email":
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Your email address appears to be malformed.");
                                          break;
                                        case "wrong-password":
                                          Fluttertoast.showToast(
                                              msg: "Your password is wrong.");
                                          break;
                                        case "user-not-found":
                                          Fluttertoast.showToast(
                                              msg:
                                                  "User with this email doesn't exist.");
                                          break;
                                        case "user-disabled":
                                          Fluttertoast.showToast(
                                              msg:
                                                  "User with this email has been disabled.");
                                          break;
                                        case "too-many-requests":
                                          Fluttertoast.showToast(
                                              msg: errorMessage =
                                                  "Too many requests");
                                          break;
                                        case "operation-not-allowed":
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Signing in with Email and Password is not enabled.");
                                          break;
                                        default:
                                          Fluttertoast.showToast(
                                              msg:
                                                  "An undefined Error happened.");
                                      }
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  onPrimary: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  minimumSize: const Size(
                                      double.infinity, 60), //////// HERE
                                ),
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: const Color(0xff252929),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Don\'t have an account? Sign up',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then(
              (uid) async => {
                saveData(),
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const UserDashboard(),
                  ),
                ),
              },
            );
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
      }
    }
  }
}

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.confirmPasswordEditingController,
  }) : super(key: key);

  final TextEditingController confirmPasswordEditingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.next,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      controller: confirmPasswordEditingController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        labelText: 'Confirm Password',
        labelStyle: GoogleFonts.poppins(color: Colors.white),
        focusColor: Colors.white,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

subscribeToTopic() async {
  await FirebaseMessaging.instance.subscribeToTopic("counselors");
}
