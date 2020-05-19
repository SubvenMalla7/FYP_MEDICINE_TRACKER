import 'package:flutter/material.dart';

TextStyle textStyle(Color color) {
  return TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold);
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
      style: textStyle(Colors.white),
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
    validator: label == 'Medical Conditions (if any)' ||
            label == 'Any other instructions?'
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

Widget alert(BuildContext context, String title, String msg) {
  return AlertDialog(
    title: Text(title),
    content: Text(msg),
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

Widget deleteDialog(BuildContext context, String title, Function onpressed) {
  return AlertDialog(
    elevation: 10,
    title: Text('Are you sure?'),
    content: Text(
      title,
      style: TextStyle(fontSize: 18),
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: onpressed,
        child: Text(
          'Yes',
          style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
        ),
      ),
      FlatButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(
          'No',
          style: TextStyle(fontSize: 18, color: Theme.of(context).accentColor),
        ),
      ),
    ],
  );
}

Widget customAppBar(
    BuildContext context,
    IconData icon1,
    Color color1,
    String title,
    IconData icon2,
    Color color2,
    Function onPressed,
    Function onPressed2) {
  return Card(
    shape: StadiumBorder(),
    color: Theme.of(context).primaryColor,
    elevation: 10,
    child: Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon1),
            color: color1,
          ),
          // SizedBox(
          //   width: 10,
          // ),
          Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // SizedBox(
          //   width: 70,
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: Icon(icon2, color: color2), onPressed: onPressed2),
          ),
        ],
      ),
    ),
  );
}

Widget myRadioButton1(
    {var groupValue, String title, int value, Function onChanged}) {
  return RadioListTile(
    value: value,
    groupValue: groupValue,
    onChanged: onChanged,
    title: Text(
      title,
      style: textStyle(Colors.black54),
    ),
  );
}

Widget myRadioButton2(
    {var groupValue,
    String title,
    int value,
    Function onChanged,
    Function onChange}) {
  return RadioListTile(
    value: value,
    groupValue: groupValue,
    onChanged: onChange,
    title: Text(
      title,
      style: textStyle(Colors.black54),
    ),
  );
}

Widget option(BuildContext context, Widget child) {
  return Container(
    color: Colors.white,
    height: MediaQuery.of(context).size.height * 0.35,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: child,
    ),
  );
}
