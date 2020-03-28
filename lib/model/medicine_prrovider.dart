import 'dart:convert';

import 'package:flutter/material.dart';
import '../my_icons_icons.dart';

import 'package:http/http.dart' as http;

import './Medicine.dart';
import './http_exception.dart';


class Medicines with ChangeNotifier {
  final String authtoken;
  final String id;

  Medicines(this.authtoken, this.id);
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    
  };

  List<Medicine> _items = [];

  List<Medicine> get items {
    return [..._items];
  }

  Medicine findById(String id) {
    return _items.firstWhere((med) => med.id == id);
  }

  Future<void> fetchAndSetMeds() async {

    final url = 'http://10.0.2.2:8000/api/medicine?api_token=$authtoken';
    // const url='http://192.168.0.103:8000/api/medicine';
    try {
    final response = await http.get(url, headers: headers);
    final extractedData = json.decode(response.body);

    final List<Medicine> loadedMedicine = [];
    var data = extractedData;
    print('object');
    print(id);
    print(extractedData);

    // try {
      //print(data.length);
      data.forEach((medData) {
        var icon = MyIcons.color_pill;

        var _color;
        //print(medData);
        //print(medData['amount'].runtimeType);
        // print('${int.parse(medData['color'])} is fromdata');
        // print(Colors.white.value);
        if (Colors.white70.value == int.parse(medData['color'])) {
          _color = Colors.white70;
        }
        if (Colors.red.value == int.parse(medData['color'])) {
          _color = Colors.red;
        }
        if (Colors.yellow.value == int.parse(medData['color'])) {
          _color = Colors.yellow;
        }
        if (Colors.blue.value == int.parse(medData['color'])) {
          _color = Colors.blue;
        }
        if (Colors.purple.value == int.parse(medData['color'])) {
          _color = Colors.purple;
        }
        if (Colors.green.value == int.parse(medData['color'])) {
          _color = Colors.green;
        }
        if (Colors.black.value == int.parse(medData['color'])) {
          _color = Colors.black;
        }
        //print('lol1');
        ////////////////////////ICONS///////////////////////////////////
        if (MyIcons.color_pill.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.color_pill;
        }
        if (MyIcons.drugs.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.drugs;
        }
        if (MyIcons.circle.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.circle;
        }
        if (MyIcons.oval.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.oval;
        }
        if (MyIcons.color_pill.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.color_pill;
        }
        if (MyIcons.pill_vertical.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.pill_vertical;
        }
        if (MyIcons.color_pill.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.color_pill;
        }
        if (MyIcons.water.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.water;
        }
        if (MyIcons.vaccine.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.vaccine;
        }
        if (MyIcons.inhaler.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.vaccine;
        }
        if (MyIcons.eye_dropper.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.eye_dropper;
        }
        if (MyIcons.spray.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.spray;
        }
        if (MyIcons.medicine_bottle.codePoint == int.parse(medData['icon'])) {
          icon = MyIcons.medicine_bottle;
        }
        //print('lol2');
        loadedMedicine.add(
          Medicine(
            id: medData['id'].toString(),
            title: medData['title'],
            amount:0,
            time: medData['time'],
            icon: Icon(
              icon,
              color: _color,
            ),
            color: int.parse(medData['color']),
            // icon: medData['icon'],
          ),
        );
      });
      //print('lol');
      _items = loadedMedicine;
      //print('loaded is $loadedMedicine');
      //print('lol');
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addMedicines(Medicine medicine) async {
    final url = 'http://10.0.2.2:8000/api/medicine?api_token=$authtoken';
    // const url='http://192.168.0.103:8000/api/medicine';

    var icon = medicine.icon;
    print(icon.icon.codePoint);
    print(medicine.title);
    print(authtoken);
    print(id);
    // try {
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({
        'title': medicine.title,
        'amount': medicine.amount,
        'time': medicine.time,
        'icon': medicine.icon.icon.codePoint.toString(),
        'color': medicine.color.toString(),
        'user_id': int.parse(id),
      }),
    );
    // icon=medicine.icon;
    // color=medicine.color;
    // print(medicine.icon);
    final newMedicine = Medicine(
      id: json.decode(response.body)['data']['id'].toString(),
      title: medicine.title,
      amount: medicine.amount,
      time: medicine.time,
      icon: medicine.icon,
      color: medicine.color,
    );
    // print(medicine.icon);
    print(json.decode(response.body)['data']['id']);
    _items.add(newMedicine);
    notifyListeners();
    // } catch (error) {
    //   print(error);
    //   throw error;
    // }
  }

  Future<void> updateMedicine(String id, Medicine newMeds) async {
    final medIndex = _items.indexWhere((meds) => meds.id == id);
    final url = 'http://10.0.2.2:8000/api/medicine/$id?api_token=$authtoken';
    await http.put(url,
        // headers: headers,
        body: ({
          "title": newMeds.title,
          "amount": newMeds.amount.toString(),
          "time": newMeds.time,
          "icon": newMeds.icon.icon.codePoint.toString(),
          "color": newMeds.color.toString(),
        }));
    if (medIndex >= 0) {
      _items[medIndex] = newMeds;
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> deleteMeds(String id) async {
    final url = 'http://10.0.2.2:8000/api/medicine/$id?api_token=$authtoken';
    // final url='http://192.168.0.103:8000/api/medicine/$id';
    final existingMedsIndex = _items.indexWhere((meds) => meds.id == id);
    var existingMedicine = _items[existingMedsIndex];
    _items.removeAt(existingMedsIndex);
    notifyListeners();
    final response = await http.delete(url, headers: headers);
    if (response.statusCode >= 400) {
      _items.insert(existingMedsIndex, existingMedicine);
      notifyListeners();
      throw HttpException("Could not delete Medicines");
    }
    existingMedicine = null;
  }
}
