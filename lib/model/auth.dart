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

  final List<User> loadedUserData = [];

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
      print('object');
      print(responseData);
      //print(responseData['errors']);
      if (responseData['errors'] != null) {
        print('hello');
        throw HttpException(responseData['errors']);
      }
      token = responseData['token'];
      userId = responseData['localId'].toString();

      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({'token': token, 'user_id': userId});
      pref.setString('user', userData);
      print('subven');
      print(pref.getString('user'));
    } catch (error) {
      print(userId);
      print(error);
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
    // const url='http://192.168.0.103:8000/api/medicine';
    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      loadedUserData.add(User(name: extractedData['name']));
      name = extractedData['name'];
      email = extractedData['email'];
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUserInfo(int id, User newUsers) async {
    print(newUsers.gender);
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
}
