import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import './http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = 'http://10.0.2.2:8000/api/$urlSegment';
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
      _token = responseData['token'];
      _userId = responseData['localId'].toString();
      print(_userId);
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({'token': _token, 'user_id': _userId});
      pref.setString('user', userData);
      print('subven');
      print(pref.getString('user'));
    } catch (error) {
      print(_userId);
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
    _token = userDataExtracted['token'];
    _userId = userDataExtracted['user_id'];
    notifyListeners();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}
