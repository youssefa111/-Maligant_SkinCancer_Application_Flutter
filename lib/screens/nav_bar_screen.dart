import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gp/screens/test_skin_screen.dart';
import 'package:hexcolor/hexcolor.dart';

import 'chat_screen.dart';
import 'home_screen.dart';

class NavBarScreen extends StatefulWidget {
  NavBarScreen({Key key}) : super(key: key);

  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  var pageList = [TestSkinScreen(), HomeScreen(), ChatScreen()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.virus), label: 'Test'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chat')
        ],
        backgroundColor: HexColor("#1b3260"),
        unselectedItemColor: Colors.white,
        selectedItemColor: HexColor('#a99e71'),
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}
