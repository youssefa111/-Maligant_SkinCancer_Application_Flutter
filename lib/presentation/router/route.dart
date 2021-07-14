import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp/screens/Sign_screens/login_screen.dart';
import 'package:gp/screens/Sign_screens/registration_screen.dart';
import 'package:gp/screens/test_skin_screen.dart';
import 'package:gp/screens/history_screen.dart';
import 'package:gp/screens/home_screen.dart';

class AppRoute {
  Route onGeneralRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());
        break;
      case RegistrationScreen.route:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
        break;
      case HomeScreen.route:
        return MaterialPageRoute(builder: (_) => HomeScreen());
        break;
      case HistoryScreen.route:
        return MaterialPageRoute(builder: (_) => HistoryScreen());
        break;
      case TestSkinScreen.route:
        return MaterialPageRoute(builder: (_) => TestSkinScreen());
        break;
      default:
        return null;
    }
  }
}
