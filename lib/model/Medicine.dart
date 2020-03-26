import 'package:flutter/material.dart';

class Medicine with ChangeNotifier {
  final String id;
  final String title;
  final double amount;
  final String time;
  final Icon icon;
  final int color;

  Medicine({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.time,
    @required this.icon,
    @required this.color,
  });
}
