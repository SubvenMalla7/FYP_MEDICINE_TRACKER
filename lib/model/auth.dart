import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:test_dasd/model/User.dart';
import './http_exception.dart';

class Auth with ChangeNotifier {
  String token;
  String userId;
  String userName;
  String email;
  String name;
  String phone;
  String age;
  String gender;
  String condition;

  List<User> _userData = [];

  List<User> get userData {
    return [..._userData];
  }

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  bool get isAuth {
    return token != null;
  }

  String get token_1 {
    if (token != null) {
      return token;
    }
    return null;
  }

  String get userid {
    return userId;
  }

  User findById(int id) {
    return _userData.firstWhere((user) => user.id == id);
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = 'http://192.168.0.103:8000/api/$urlSegment';
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'password_confirmation': password,
            'name': 'Test'
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData['errors']);

      if (responseData['errors'] != null) {
        print('hellodfsdf');
        throw HttpException(responseData['errors']);
      }
      token = responseData['token'];
      userId = responseData['localId'].toString();

      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({'token': token, 'user_id': userId});
      pref.setString('user', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'register');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'login');
  }

  Future<bool> autoLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('user')) {
      return false;
    }
    final userDataExtracted =
        json.decode(pref.getString('user')) as Map<String, Object>;
    token = userDataExtracted['token'];
    userId = userDataExtracted['user_id'];
    notifyListeners();
    return true;
  }

  void logout() async {
    token = null;
    userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }

  Future<void> fetchUserData() async {
    final url = 'http://192.168.0.103:8000/api/userData?api_token=$token';
    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      _userData.add(
        User(
            id: extractedData['id'],
            name: extractedData['name'],
            email: extractedData['email'],
            phone: extractedData['phone'],
            age: extractedData['age'],
            gender: extractedData['gender'],
            condition: extractedData['conditions']),
      );
      name = extractedData['name'];
      email = extractedData['email'];
      phone = extractedData['phone'];
      age = extractedData['age'];
      gender = extractedData['gender'];
      condition = extractedData['conditions'];

      name = extractedData['name'];
      email = extractedData['email'];

      //notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUserInfo(int id, User newUsers) async {
    print(newUsers.condition);
    print(token);
    // final userIndex = loadedUserData.indexWhere((users) => users.id == id);
    final url = 'http://192.168.0.103:8000/api/updateUser?api_token=$token';
    await http.put(
      url,
      body: ({
        "name": newUsers.name,
        "email": newUsers.email,
        "phone": newUsers.phone,
        "age": newUsers.age,
        "gender": newUsers.gender,
        "conditions": newUsers.condition,
      }),
    );
    print('done');
    notifyListeners();
    // if (userIndex >= 0) {
    //   loadedUserData[userIndex] = newUsers;
    //
    // } else {
    //   print('....');
    // }
  }

  Future<void> deleteuser(int id) async {
    final url = 'http://192.168.0.103:8000/api/deleteUser?api_token=$token';
    final existingUserIndex = _userData.indexWhere((user) => user.id == id);
    _userData.removeAt(existingUserIndex);
    await http.delete(url, headers: headers);

    token = null;
    userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}
