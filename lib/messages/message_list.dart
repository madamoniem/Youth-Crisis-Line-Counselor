import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yclcounselor/messages/chatscreen.dart';
import 'package:yclcounselor/messages/message.dart';
import 'message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class MessageList extends StatefulWidget {
  const MessageList({
    Key? key,
    required this.name,
    required this.uid,
    required this.docID,
  }) : super(key: key);
  final String name;
  final String uid;
  final String docID;
  @override
  MessageListState createState() => MessageListState();
}

class MessageListState extends State<MessageList> {
  var secondaryColor = const Color(0xff00b894);
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? data;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref("messages/${widget.uid}");
    starCountRef.onValue.listen(
      (DatabaseEvent event) async {
        await Future.delayed(const Duration(milliseconds: 100));

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: secondaryColor,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: GestureDetector(
              onTap: () async {
                await FirebaseFirestore.instance
                    .collection("calls")
                    .doc(widget.docID)
                    .set(
                  {
                    'status': "Completed",
                    'completedTime': DateFormat('MM-dd-yyyy, hh:mm a')
                        .format(DateTime.now())
                        .toString(),
                    'msSinceEpochDone': DateTime.now().millisecondsSinceEpoch,
                  },
                  SetOptions(merge: true),
                );

                await FirebaseDatabase.instance
                    .ref("messages/${widget.uid}")
                    .push()
                    .set({
                  'date': DateTime.now().toString(),
                  'text': "Counselor has left the chat.",
                  'uid': FirebaseAuth.instance.currentUser!.uid,
                });

                _messageController.clear();
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Icon(
                  FontAwesomeIcons.circleCheck,
                ),
              ),
            ),
          ),
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ChatScreen(),
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
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.name,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 37, 41, 41),
      body: SafeArea(
        child: Column(
          children: [
            _getMessageList(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 11,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(color: Colors.white),
                    controller: _messageController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      labelText: 'Enter message',
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
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    iconSize: 30,
                    color: Colors.white,
                    icon: Icon(
                      _canSendMessage()
                          ? CupertinoIcons.arrow_right_circle_fill
                          : CupertinoIcons.arrow_right_circle,
                    ),
                    onPressed: () {
                      _sendMessage();
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_canSendMessage()) {
      final message = Message(_messageController.text, DateTime.now(), 'ee');
      await FirebaseDatabase.instance
          .ref("messages/${widget.uid}")
          .push()
          .set(message.toJson());

      _messageController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      setState(() {});
    }
  }

  Widget _getMessageList() {
    return Expanded(
      child: FirebaseAnimatedList(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        query: FirebaseDatabase.instance
            .ref("messages/${widget.uid}")
            .orderByChild("date"),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Message.fromJson(json);
          return MessageWidget(message.text, message.date, message.uid);
        },
      ),
    );
  }

  bool _canSendMessage() => _messageController.text.isNotEmpty;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
