import 'package:flutter/material.dart';

Widget buildTextField(
    {TextEditingController ctr,
    TextInputAction textInputAction = TextInputAction.next,
    String label,
    Icon icon,
    TextInputType type,
    bool ob = false}) {
  return TextField(
    textInputAction: textInputAction,
    controller: ctr,
    keyboardType: type,
    decoration: InputDecoration(
      icon: icon,
      labelText: label,
    ),
    obscureText: ob,
  );
}
