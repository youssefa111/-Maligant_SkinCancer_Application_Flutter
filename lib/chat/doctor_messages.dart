import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'message_bubble.dart';

class DoctorMessages extends StatelessWidget {
  const DoctorMessages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Doctorchat")
          .doc('${user.uid}')
          .collection("myChat")
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (BuildContext context, int index) => MessageBubble(
            chatDocs[index]['text'],
            chatDocs[index]['username'],
            chatDocs[index]['userImage'],
            chatDocs[index]['userId'] == FirebaseAuth.instance.currentUser.uid,
          ),
        );
      },
    );
  }
}
