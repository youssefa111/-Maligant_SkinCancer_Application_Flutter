import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hexcolor/hexcolor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _emailEditingController = new TextEditingController();
  var _passwordEditingController = new TextEditingController();
  final _userFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _loginFocusNode = FocusNode();
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  // submit() {
  //   if (usernameEditingController.text.trim() == "123" ||
  //       passwordEditingController.text.trim() == "123") {
  //     usernameEditingController.clear();
  //     passwordEditingController.clear();
  //     Navigator.pushNamed(context, '/home');
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //         title: Text('There is something is wrong!'),
  //         content: Text('Please check your username or password'),
  //         actions: [
  //           ElevatedButton(
  //             style: ButtonStyle(
  //               backgroundColor:
  //                   MaterialStateProperty.all<Color>(HexColor("#1b3260")),
  //             ),
  //             onPressed: () => Navigator.pop(context),
  //             child: Text(
  //               'Okay',
  //             ),
  //           )
  //         ],
  //       ),
  //     );
  //   }
  // }

  Future<void> _login() async {
    // ignore: unused_local_variable
    UserCredential authResult;
    FocusScope.of(context).unfocus();
    try {
      setState(() {
        _isLoading = true;
      });
      authResult = await _auth.signInWithEmailAndPassword(
          email: _emailEditingController.text.trim(),
          password: _passwordEditingController.text.trim());
      // ignore: unused_catch_clause
    } on PlatformException catch (err) {
      var message =
          "An error occurred, please check your E-mail or password is correct!";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      var message =
          "An error occurred, please check your E-mail or password is correct!";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        ClipPath(
          child: new Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.6,
            decoration: BoxDecoration(
              color: HexColor("#1b3260"),
            ),
          ),
        ),
        UpperOfPage(),
        Positioned(
          top: MediaQuery.of(context).size.height * .4,
          left: MediaQuery.of(context).size.width * .2,
          child: Container(
            decoration: BoxDecoration(),
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width * .7,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'E-mail',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  focusNode: _userFocusNode,
                  controller: _emailEditingController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    filled: true,
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Password',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  obscureText: true,
                  focusNode: _passwordFocusNode,
                  controller: _passwordEditingController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    filled: true,
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_loginFocusNode);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                if (_isLoading) CircularProgressIndicator(),
                if (!_isLoading)
                  ElevatedButton(
                    focusNode: _loginFocusNode,
                    onPressed: _login,
                    child: Text('login'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(HexColor("#1b3260")),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Text('Dont have an account ? '),
                    InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, '/registration'),
                        child: Text(
                          'Create',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

class UpperOfPage extends StatelessWidget {
  const UpperOfPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome To ',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Skin Cancer Detecion',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '''in This Application you can
Check your Skin by take a photo for your skin and let
the Application detect Wether your skin is healthy.''',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
