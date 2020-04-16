import 'package:flutter/material.dart';

class User with ChangeNotifier {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String age;
  final String gender;
  final String condition;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.age,
    this.gender,
    this.condition,
  });
}
