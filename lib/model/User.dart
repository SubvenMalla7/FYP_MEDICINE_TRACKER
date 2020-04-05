import 'package:flutter/cupertino.dart';

class User with ChangeNotifier {
  String id;
  String name;
  // String dob;
  // int age;
  // String gender;
  // String sex;
  String email;

  User({
    @required this.id,
    @required this.name,
    // @required this.dob,
    // @required this.age,
    // @required this.gender,
    // @required this.sex,
    @required this.email,
  });
}
