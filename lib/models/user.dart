import 'package:flutter/material.dart';

class User {
  // ignore: non_constant_identifier_names
  final int user_id;
  final String username;
  final String password;
  final String confirmPassword;
  final int age;
  final String gendar;
  final String photo;

  User(
      // ignore: non_constant_identifier_names
      {this.user_id,
      @required this.username,
      @required this.password,
      @required this.confirmPassword,
      @required this.age,
      @required this.gendar,
      this.photo});

  User.fromMap(Map<String, dynamic> res)
      : user_id = res["user_id"],
        username = res["username"],
        age = res["age"],
        password = res["password"],
        confirmPassword = res["confirmPassword"],
        gendar = res["gendar"],
        photo = res["photo"];

  Map<String, Object> toMap() {
    return {
      'user_id': user_id,
      'username': username,
      'age': age,
      'password': password,
      'confirmPassword': confirmPassword,
      'gendar': gendar,
      'photo': photo,
    };
  }
}
