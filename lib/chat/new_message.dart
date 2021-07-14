import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

class NewMessage extends StatefulWidget {
  NewMessage({Key key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _enteredMessage = '';
  final _controller = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection("Communitychat").add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Send a message...',
                  labelStyle: TextStyle(color: HexColor('#1b3260'))),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
              controller: _controller,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: HexColor('#1b3260')),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
