import 'package:flutter/material.dart';

class Medicine with ChangeNotifier {
  final String id;
  final String title;
  double amount;
  final String time;
  final String date;
  final String type;
  final String instruction;
  final String note;
  final Icon icon;
  final int color;

  Medicine({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.time,
    @required this.icon,
    @required this.color,
    @required this.date,
    @required this.type,
    @required this.instruction,
    @required this.note,
  });
}
