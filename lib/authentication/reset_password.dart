import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();

  ResetScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              textInputAction: TextInputAction.next,
              style: const TextStyle(color: Colors.white),
              controller: email,
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
                  borderSide: const BorderSide(width: 3, color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                auth.sendPasswordResetEmail(email: email.text).then((value) =>
                    Fluttertoast.showToast(msg: "Instructions Sent"));
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                minimumSize: const Size(double.infinity, 60), //////// HERE
              ),
              child: Text(
                'Send Instructions',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: const Color(0xff252929),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
