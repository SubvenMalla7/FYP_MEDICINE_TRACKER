import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../model/Medicine.dart';

class MedicineScedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color colors = Theme.of(context).primaryColor;
    final medicine = Provider.of<Medicine>(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 5,
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                      end: Alignment.topLeft,
                      begin: Alignment.bottomRight,
                      colors: <Color>[
                        colors.withOpacity(0.5),
                        colors.withOpacity(0.9),
                        colors,
                      ])),
              height: 50,
              child: Center(
                  child: Text(
                medicine.time,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20))),
              child: ListTile(
                leading: medicine.icon,
                title: Text(medicine.title),
                subtitle: Text('Take ${medicine.amount.toString()}'),
                trailing: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
