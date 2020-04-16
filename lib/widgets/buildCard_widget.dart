import 'package:flutter/material.dart';

TextStyle textStyle() {
  return TextStyle(
      color: Colors.black54, fontSize: 18, fontWeight: FontWeight.bold);
}

TextStyle headingStyle(BuildContext context) {
  return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: Theme.of(context).primaryColor);
}

Widget myRadioButton(
    {String title, int value, Function onChanged, int groupValue}) {
  return RadioListTile(
    value: value,
    groupValue: groupValue,
    onChanged: onChanged,
    title: Text(
      title,
      style: textStyle(),
    ),
  );
}

Widget buildCard({child}) {
  return Card(
    margin: const EdgeInsets.all(10),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Container(padding: EdgeInsets.all(15), child: child),
  );
}

Future<Null> selectdate(BuildContext context, DateTime dateTime) async {
  final DateTime picked = await showDatePicker(
    context: context,
    initialDate: dateTime,
    firstDate: dateTime.subtract(new Duration(days: 3650)),
    lastDate: dateTime.add(new Duration(days: 3650)),
  );
  return picked;
}

Widget buildForm(String initailValue, String label, String msg,
    TextInputType textInputType, Function onsaved) {
  return TextFormField(
    initialValue: initailValue,
    decoration: InputDecoration(labelText: label),
    textInputAction: textInputType == TextInputType.multiline
        ? TextInputAction.newline
        : TextInputAction.next,
    maxLines: label == 'Medical Conditions (if any)' ? 3 : 1,
    keyboardType: textInputType,
    validator: label == 'Medical Conditions (if any)'
        ? null
        : (value) {
            if (value.isEmpty) {
              return msg;
            }
            return null;
          },
    onSaved: onsaved,
  );
}

Widget dropDown(
    List list, Color color, String _currentUnitSelected, Function onchanged) {
  return DropdownButton<String>(
    items: list.map((selectedUnit) {
      return DropdownMenuItem<String>(
        value: selectedUnit,
        child: Text(
          selectedUnit,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      );
    }).toList(),
    onChanged: onchanged,
    value: _currentUnitSelected,
  );
}

Widget alert(BuildContext context) {
  return AlertDialog(
    title: Text('An unexpected error occured'),
    content: Text('Somthing went error'),
    actions: <Widget>[
      FlatButton(
        child: Text(
          'Okay',
          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ],
  );
}
