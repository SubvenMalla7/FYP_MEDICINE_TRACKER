import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../my_icons_icons.dart';
import './Medicine.dart';
import './http_exception.dart';
import 'MedicineLog.dart';

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

  List<MedicineLog> _logitems = [];

  List<MedicineLog> get logitems {
    return [..._logitems];
  }

  Medicine findById(String id) {
    return _items.firstWhere((med) => med.id == id);
  }

  Future<void> fetchAndSetMeds() async {
    final url = 'http://192.168.0.103:8000/api/medicine?api_token=$authtoken';
    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      print(extractedData);

      final List<Medicine> loadedMedicine = [];
      var data = extractedData;

      data.forEach((medData) {
        var icon = MyIcons.color_pill;

        var _color;

        if (Colors.white70.value == int.parse(medData['color'])) {
          _color = Colors.white;
        }
        if (Colors.red.value == int.parse(medData['color'])) {
          _color = Colors.red;
        }
        if (Colors.orange.value == int.parse(medData['color'])) {
          _color = Colors.orange;
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
        print("object");
        loadedMedicine.add(
          Medicine(
              id: medData['id'].toString(),
              title: medData['title'],
              amount: double.parse(medData['amount']),
              time: medData['time'],
              interval: medData['intervals'],
              icon: Icon(
                icon,
                size: 30,
                color: _color,
              ),
              color: int.parse(medData['color']),
              date: medData['start_date'],
              instruction: medData['instruction'],
              note: medData['note'],
              type: medData['type']),
        );
        print('sdasdas${medData['id']}');
      });

      _items = loadedMedicine;

      notifyListeners();
    } catch (error) {
      //throw error;
    }
  }

  Future<void> addMedicines(Medicine medicine) async {
    final url = 'http://192.168.0.103:8000/api/medicine?api_token=$authtoken';
    print(url);

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({
        'title': medicine.title,
        'amount': medicine.amount,
        'time': medicine.time,
        'intervals': medicine.interval,
        'start_date': medicine.date,
        'icon': medicine.icon.icon.codePoint.toString(),
        'color': medicine.color.toString(),
        'user_id': int.parse(id),
        'type': medicine.type,
        'instruction': medicine.instruction,
        'note': medicine.note,
      }),
    );
    print(response.body);

    final newMedicine = Medicine(
      id: json.decode(response.body)['data']['id'].toString(),
      title: medicine.title,
      amount: medicine.amount,
      time: medicine.time,
      interval: medicine.interval,
      icon: medicine.icon,
      color: medicine.color,
      date: medicine.date,
      instruction: medicine.instruction,
      note: medicine.note,
      type: medicine.type,
    );

    _items.add(newMedicine);

    notifyListeners();
  }

  Future<void> updateMedicine(String id, Medicine newMeds) async {
    final medIndex = _items.indexWhere((meds) => meds.id == id);
    final url =
        'http://192.168.0.103:8000/api/medicine/$id?api_token=$authtoken';
    await http.put(
      url,
      body: ({
        "title": newMeds.title,
        "amount": newMeds.amount.toString(),
        "time": newMeds.time,
        "icon": newMeds.icon.icon.codePoint.toString(),
        "color": newMeds.color.toString(),
        "type": newMeds.type,
        "instruction": newMeds.instruction,
        "start_date": newMeds.date,
        "note": newMeds.date
      }),
    );

    if (medIndex >= 0) {
      _items[medIndex] = newMeds;
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> deleteMeds(String id) async {
    final url =
        'http://192.168.0.103:8000/api/medicine/$id?api_token=$authtoken';
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

////////////////////////////////////////MEDICIENE LOG//////////////////////////////////////////////////

  Future<void> addMedicinesLog(MedicineLog medicineLog) async {
    final url =
        'http://192.168.0.103:8000/api/medicineLog?api_token=$authtoken';
    // const url='http://192.168.0.103:8000/api/medicine';

    // try {
    await http.post(
      url,
      headers: headers,
      body: json.encode({
        'title': medicineLog.title,
        'amount': medicineLog.amount,
        'time': medicineLog.time,
        'start_date': medicineLog.date,
        'user_id': int.parse(id),
        'status': medicineLog.status,
        'reasons': medicineLog.reasons,
      }),
    );

    final newMedicineLog = MedicineLog(
      title: medicineLog.title,
      amount: medicineLog.amount,
      time: medicineLog.time,
      date: medicineLog.date,
      status: medicineLog.status,
      reasons: medicineLog.reasons,
    );

    _logitems.add(newMedicineLog);
    notifyListeners();
  }
}
