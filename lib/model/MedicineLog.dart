import 'package:flutter/material.dart';

class MedicineLog with ChangeNotifier {
  
  final String title;
  final double amount;
  final String time;
  final String date;
  final String status;
  final String reasons;

  MedicineLog(
      {
      @required this.title,
      @required this.amount,
      @required this.time,
      @required this.date,
      @required this.status,
      @required this.reasons});
}
