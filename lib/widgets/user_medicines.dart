import 'package:flutter/material.dart';

class UserMedicines extends StatelessWidget {
  final String id;
  final String title;
  final Icon icons;
  final int color;

  UserMedicines(
    this.id,
    this.icons,
    this.title,
    this.color,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        elevation: 8,
        shadowColor: Theme.of(context).primaryColor,
        shape: StadiumBorder(),
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.1,
          child: ListTile(
            leading: CircleAvatar(
              radius: 40,
              backgroundColor: color == Colors.white70.value
                  ? Colors.black87
                  : Colors.black12,
              child: icons,
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}
