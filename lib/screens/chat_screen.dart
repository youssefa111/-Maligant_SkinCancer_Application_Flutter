import 'package:gp/chat/doctor_messages.dart';
import 'package:gp/chat/new_doctor_message.dart';

import '../chat/messages.dart';
import '../chat/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isCommunity = true;
  String x = 'doctor';
  String y = 'community';
  String head = 'community';
  // @override
  // void initState() {
  //   final fbm = FirebaseMessaging();
  //   fbm.requestNotificationPermissions();
  //   fbm.configure(onResume: (message) {
  //     return;
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          head,
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          DropdownButton(
            underline: Container(),
            items: [
              DropdownMenuItem(
                value: isCommunity ? x : y,
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text(isCommunity ? x : y),
                    ],
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                if (value == 'doctor') {
                  isCommunity = false;
                  head = value;
                  print(value + '1');
                } else if (value == 'community') {
                  isCommunity = true;
                  head = value;
                  print(value);
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: isCommunity ? Messages() : DoctorMessages(),
            ),
            isCommunity ? NewMessage() : NewDoctorMessage(),
          ],
        ),
      ),
    );
  }
}
