import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gp/Provider/user_provider.dart';

import 'package:gp/presentation/router/route.dart';
import 'package:gp/screens/Sign_screens/login_screen.dart';

import 'package:gp/screens/nav_bar_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'Provider/history_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  configLoading();
}
// #1b3260
// #3d77f3

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AppRoute _appRoute = AppRoute();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => HistoryProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Skin Cancer',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              color: HexColor("#1b3260"),
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: HexColor("#1b3260")),
              backwardsCompatibility: false),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          textTheme: TextTheme(
            headline3: TextStyle(
              color: Colors.white,
            ),
            headline4: TextStyle(
              color: Colors.white,
            ),
            headline5: TextStyle(
              fontWeight: FontWeight.bold,
              color: HexColor('#a99e71'),
            ),
            headline6: TextStyle(
              fontWeight: FontWeight.bold,
              color: HexColor('#a99e71'),
            ),
          ),
          buttonColor: HexColor("#1b3260"),
          backgroundColor: HexColor('#1b3260'),
        ),
        onGenerateRoute: _appRoute.onGeneralRoute,
        builder: EasyLoading.init(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return NavBarScreen();
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
