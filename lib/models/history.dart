import 'dart:convert';

class History {
  // ignore: non_constant_identifier_names
  final int history_id;
  // ignore: non_constant_identifier_names
  final int user_id;
  final String date;
  final String result;
  final String picture;
  History({
    // ignore: non_constant_identifier_names
    this.history_id,
    // ignore: non_constant_identifier_names
    this.user_id,
    this.date,
    this.result,
    this.picture,
  });

  Map<String, dynamic> toMap() {
    return {
      'history_id': history_id,
      'user_id': user_id,
      'date': date,
      'result': result,
      'picture': picture,
    };
  }

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      history_id: map['history_id'],
      user_id: map['user_id'],
      date: map['date'],
      result: map['result'],
      picture: map['picture'],
    );
  }

  String toJson() => json.encode(toMap());

  factory History.fromJson(String source) =>
      History.fromMap(json.decode(source));
}
