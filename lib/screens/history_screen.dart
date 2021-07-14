import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp/constants/back_button.dart';
import 'package:hexcolor/hexcolor.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key key}) : super(key: key);
  static const route = "/history";

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => new HistoryWidget(
              date: doc['test_date'],
              result: doc['result'],
              image: doc['image_url'],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ClipPath(
          child: new Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 4.5,
            decoration: BoxDecoration(
              color: HexColor("#1b3260"),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Your History',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Here you can check test history',
                      style: TextStyle(
                        color: HexColor('#a99e71'),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                MyBackButton(context),
              ],
            ),
          ),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('userHistory')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data == null) {
              return Text(
                'There is no History yet!',
                style: Theme.of(context).textTheme.headline6,
              );
            } else {
              return Container(
                child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 5.5),
                    child: ListView(
                      children: getExpenseItems(snapshot),
                    )),
              );
            }
          },
        ),
      ],
    ));
  }
}

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({
    // ignore: non_constant_identifier_names
    this.history_id,
    // ignore: non_constant_identifier_names
    this.user_id,
    this.date,
    this.result,
    this.image,
  });
  // ignore: non_constant_identifier_names
  final int history_id;
  // ignore: non_constant_identifier_names
  final int user_id;
  final String date;
  final String result;
  final String image;
  @override
  Widget build(BuildContext context) {
    Color resultColor = Colors.red;
    return Card(
      elevation: 3,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(width: 50, height: 50, child: Image.network(image)),
              Text(
                result,
                style: TextStyle(
                  color: result == 'Malignant'
                      ? resultColor
                      : resultColor = Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(date),
            ],
          )),
    );
  }
}
