import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yclcounselor/messages/message_list.dart';

import '../userDashboard.dart';
import '../userDashboard.dart' as dashboard_vars;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const String routeName = '/chatScreen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var secondaryColor = const Color(0xff00b894);

    final List<Widget> widgetOptions = <Widget>[
      SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
                right: 50,
              ),
              child: AutoSizeText(
                'Awaiting Tickets',
                maxLines: 2,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('calls')
                    .where('status', isEqualTo: 'Awaiting')
                    .orderBy('msSinceEpoch', descending: false)
                    .snapshots(), // async work
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Expanded(
                        child: Center(
                          child: Text(
                            "Loading Tickets",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          children: snapshot.data!.size == 0
                              ? [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "No Awaiting Tickets",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                              : snapshot.data!.docs.map(
                                  (DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: const Color.fromARGB(
                                              120, 99, 110, 114),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              top: 30,
                                              bottom: 20,
                                              right: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                data["name"].toString(),
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                data["whatsBothering"]
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                data["modeOfContact"],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                data["time"],
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: secondaryColor,
                                                  onPrimary: Colors.white,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            140.0),
                                                  ),
                                                  minimumSize: const Size(
                                                      double.infinity,
                                                      50), //////// HERE
                                                ),
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("calls")
                                                      .doc(document.id)
                                                      .update(
                                                    {
                                                      'status': "InProgress",
                                                      'counselorName':
                                                          dashboard_vars
                                                              .firstName,
                                                    },
                                                  ).then(
                                                    (value) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Request placed');
                                                    },
                                                  );
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MessageList(
                                                        name: data["name"],
                                                        uid: data["uid"],
                                                        docID: document.id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Accept',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
                right: 50,
              ),
              child: AutoSizeText(
                'In Progress Tickets',
                maxLines: 2,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('calls')
                    .where('status', isEqualTo: 'InProgress')
                    .orderBy('msSinceEpoch', descending: true)
                    .snapshots(), // async work
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Expanded(
                        child: Center(
                          child: Text(
                            "Loading Tickets",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          children: snapshot.data!.size == 0
                              ? [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "No In Progress Tickets",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                              : snapshot.data!.docs.map(
                                  (DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: const Color.fromARGB(
                                              120, 99, 110, 114),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              top: 30,
                                              bottom: 20,
                                              right: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                data["name"].toString(),
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                data["whatsBothering"]
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                data["modeOfContact"],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                data["time"],
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: secondaryColor,
                                                  onPrimary: Colors.white,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            140.0),
                                                  ),
                                                  minimumSize: const Size(
                                                      double.infinity,
                                                      50), //////// HERE
                                                ),
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("calls")
                                                      .doc(document.id)
                                                      .update(
                                                    {
                                                      'status': "InProgress",
                                                      'counselorName':
                                                          dashboard_vars
                                                              .firstName,
                                                    },
                                                  ).then(
                                                    (value) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Request placed');
                                                    },
                                                  );
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MessageList(
                                                        name: data["name"],
                                                        uid: data["uid"],
                                                        docID: document.id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Join',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
                right: 50,
              ),
              child: AutoSizeText(
                'Completed Tickets',
                maxLines: 2,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('calls')
                    .where('status', isEqualTo: 'Completed')
                    .orderBy('msSinceEpochDone', descending: true)
                    .snapshots(), // async work
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Expanded(
                        child: Center(
                          child: Text(
                            "Loading Tickets",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          children: snapshot.data!.size == 0
                              ? [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "No Completed Tickets",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                              : snapshot.data!.docs.map(
                                  (DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: const Color.fromARGB(
                                              120, 99, 110, 114),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              top: 30,
                                              bottom: 20,
                                              right: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                data["name"].toString(),
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                data["whatsBothering"]
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                data["modeOfContact"],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                data["completedTime"],
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: secondaryColor,
                                                  onPrimary: Colors.white,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            140.0),
                                                  ),
                                                  minimumSize: const Size(
                                                      double.infinity, 50),
                                                ),
                                                onPressed: () async {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MessageList(
                                                        name: data["name"],
                                                        uid: data["uid"],
                                                        docID: document.id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'View Chat',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ];
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const UserDashboard(),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Icon(
              FontAwesomeIcons.chevronLeft,
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 37, 41, 41),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.watch,
                  size: 30,
                ),
              ),
              label: 'Awaiting',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.list),
              ),
              label: 'In Progress',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  FontAwesomeIcons.listCheck,
                  size: 25,
                ),
              ),
              label: 'Completed',
            ),
          ],
          unselectedItemColor: const Color(0xffb2bec3),
          fixedColor: Colors.white,
          currentIndex: _selectedIndex,
          backgroundColor: const Color(0xff2d3436),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
