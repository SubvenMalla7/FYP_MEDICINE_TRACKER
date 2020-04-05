import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:test_dasd/screens/medicines_screen.dart';

import '../model/Medicine.dart';
import '../model/medicine_prrovider.dart';
import '../screens/add_screen.dart';

class SingleMedicine extends StatelessWidget {
  static const routeName = '/medicine';

  @override
  Widget build(BuildContext context) {
    final Medicine medicine = ModalRoute.of(context).settings.arguments;
    var date = DateFormat('yyyy-mm-dd').format(DateTime.now());
    print(date);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          medicine.title,
          textAlign: TextAlign.center,
          semanticsLabel: 'Medicine Name',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(AddScreen.routeName,
                    arguments: medicine.id);
              },
              icon: Icon(Icons.edit,
                  color: Theme.of(context).accentColor, size: 30),
            ),
          )
        ],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                        radius: 40,
                        backgroundColor: medicine.color == Colors.white70.value
                            ? Colors.black87
                            : Colors.black12,
                        child: medicine.icon),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Column(
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: MainTabInfo(
                              fieldTitle: "Medicine Name",
                              fieldInfo: medicine.title,
                            ),
                          ),
                          MainTabInfo(
                            fieldTitle: "Dosage",
                            fieldInfo: medicine.amount == 0
                                ? "Not Specified"
                                : medicine.amount.toString() + " mg",
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ExtendedInfoTab(
                          fieldTitle: "Medicine Type",
                          fieldInfo: medicine.type.length == 0
                              ? "No Type"
                              : medicine.type,
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        ExtendedInfoTab(
                          fieldTitle: "Instruction ",
                          fieldInfo: medicine.instruction.length == 0
                              ? "No instruction"
                              : medicine.instruction,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        ExtendedInfoTab(
                          fieldTitle: "Start Time",
                          fieldInfo: medicine.time,
                        ),
                        SizedBox(
                          width: 90,
                        ),
                        ExtendedInfoTab(
                            fieldTitle: "Start Date ",
                            fieldInfo: medicine.date.toString()),
                      ],
                    ),
                    ExtendedInfoTab(
                      fieldTitle: "Dose ",
                      fieldInfo: medicine.amount.toString(),
                    ),
                    ExtendedInfoTab(
                      fieldTitle: "Notes",
                      fieldInfo: medicine.note.length == 0
                          ? 'No Notes'
                          : medicine.note,
                    ),
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 5,
              ),
              //ExtendedSection(medicine: medicine),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.06,
                  right: MediaQuery.of(context).size.height * 0.06,
                  top: 25,
                ),
                child: Container(
                  width: 280,
                  height: 70,
                  child: FlatButton(
                    color: Theme.of(context).errorColor,
                    shape: StadiumBorder(),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                elevation: 10,
                                title: Text('Are you sure?'),
                                content: Text(
                                  'Do you want to delete ${medicine.title}?',
                                  style: TextStyle(fontSize: 18),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () async {
                                      try {
                                        await Provider.of<Medicines>(context,
                                                listen: false)
                                            .deleteMeds(medicine.id);
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                MedicineScreen.routeName);
                                      } catch (error) {
                                        print('This is an eror $error');
                                      }
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                ],
                              ));
                    },
                    child: Center(
                      child: Text(
                        "Delete Medicine",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainTabInfo extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  MainTabInfo({this.fieldTitle, this.fieldInfo});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 100,
      child: ListView(
        padding: EdgeInsets.only(top: 15),
        shrinkWrap: true,
        children: <Widget>[
          Text(
            fieldTitle,
            style: TextStyle(
                fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            fieldInfo,
            style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  ExtendedInfoTab({@required this.fieldTitle, @required this.fieldInfo});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                fieldTitle,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              fieldInfo,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
