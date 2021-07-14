import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gp/DB/database.dart';
import 'package:gp/models/user.dart';
import 'package:gp/screens/home_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:toast/toast.dart';

class UserProvider extends ChangeNotifier {
  User _users;

  User get userInfo {
    return _users;
  }

  Future<void> addUser(User user, BuildContext context) async {
    await AppDataBase().insertUser(user);
    Toast.show(
      "The Registration is sucessfully",
      context,
      duration: 2,
      gravity: Toast.CENTER,
    );
    print(AppDataBase().insertUser(user));
    notifyListeners();
  }

  Future<void> loginFun(
      String userName, String password, BuildContext context) async {
    var appDatabase = AppDataBase();
    var usersList = await appDatabase.retrieveUsers();
    bool flag = false;
    int i = 0;
    while (i != usersList.length) {
      if (userName == usersList[i].username &&
          password == usersList[i].password) {
        _users = usersList[i];
        notifyListeners();
        Navigator.of(context).pushNamed(HomeScreen.route);
        flag = true;
        return;
      }
      i++;
    }
    if (flag == true) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('There is something is wrong!'),
        content: Text('Please check your username or password'),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(HexColor("#1b3260")),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Okay',
            ),
          )
        ],
      ),
    );
  }
}
