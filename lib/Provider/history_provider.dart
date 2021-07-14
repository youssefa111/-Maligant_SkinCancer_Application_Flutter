import 'package:flutter/widgets.dart';
import 'package:gp/DB/database.dart';
import 'package:gp/models/history.dart';

class HistoryProvider extends ChangeNotifier {
  List<History> _history;

  List<History> get allHistories {
    return _history;
  }

  Future<void> addHistory(History history) async {
    await AppDataBase().insertHistory(history);

    print(AppDataBase().insertHistory(history));
    notifyListeners();
  }

  Future<void> deleteHistory(int id) async {
    await AppDataBase().deleteHistory(id);

    print(AppDataBase().deleteHistory(id));
    notifyListeners();
  }

  Future<void> retriveHistory() async {
    var x = AppDataBase();
    var result = await x.retrieveHistorys();
    _history = result;
    notifyListeners();
  }
}
