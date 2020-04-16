import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../my_icons_icons.dart';
import '../screens/tab_screen.dart';

class Measurement extends StatefulWidget {
  static const routeName = '/measurement';

  @override
  _MeasurementState createState() => _MeasurementState();
}

class _MeasurementState extends State<Measurement> {
  var heartRate = 0;
  var water = 0;
  int weight = 0;
  var heightFeet = 0;
  var heightInches = 0;
  String height = '';
  String pressure = '';
  var bloodSugar = 0;
  var bloodPressureUp = 120;
  var bloodPressureDown = 80;
  TextEditingController customController = TextEditingController();
  TextEditingController customController1 = TextEditingController();
  @override
  void initState() {
    getName();

    super.initState();
  }

  Future<void> getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final measurementDataExtracted =
        json.decode(prefs.getString('measurementData')) as Map<String, Object>;

    setState(() {
      heartRate = measurementDataExtracted['HeartRate'];
      weight = measurementDataExtracted['weight'];
      height = measurementDataExtracted['height'];
      water = measurementDataExtracted['water'];
      heightFeet = measurementDataExtracted['heightfeet'];
      heightInches = measurementDataExtracted['heightinches'];
      bloodPressureUp = measurementDataExtracted['bloodPressureUp'];
      bloodPressureDown = measurementDataExtracted['bloodPressureDown'];
    });
  }

  void tap(BuildContext context, id) async {
    if (customController.text == '') {
      Navigator.of(context).pop();
      return;
    }
    if (customController.text != null || customController1.text != null) {
      if (id == 3) {
        setState(() {
          heightFeet = int.parse(customController.text);
          heightInches = int.parse(customController1.text);
        });
      } else {
        setState(() {
          bloodPressureUp = int.parse(customController.text);
          bloodPressureDown = int.parse(customController1.text);
        });
      }
    }
    Navigator.of(context).pop();
  }

  Future _showdoubleDialog(String unit1, String unit2, id) async {
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  child: TextField(
                    controller: customController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  unit1,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 40,
                  child: TextField(
                    controller: customController1,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  unit2,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Theme.of(context).errorColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                  onPressed: () => tap(context, id),
                  child: Text(
                    'Done',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          );
        });
  }

  Future _showIntegerDialog(id) async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 0,
          maxValue: 200,
          step: 1,
          initialIntegerValue: 0,
        );
      },
    ).then((int value) async {
      if (value != null) {
        setState(() {
          id == 1
              ? heartRate = value
              : id == 2 ? weight = value : bloodSugar = value;
        });
      }
    });
  }

  Widget _button(id, String unit1, String unit2) {
    return FlatButton(
      key: Key(height),
      color: Theme.of(context).primaryColor,
      onPressed: () {
        id == 3
            ? _showdoubleDialog(unit1, unit2, id)
            : id == 4
                ? _showdoubleDialog(unit1, unit2, id)
                : _showIntegerDialog(id);
      },
      child: Text(
        'Record',
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
      ),
      shape: StadiumBorder(),
    );
  }

  Widget _buildCard(
      String title, var value, String unit, Icon icon, Widget button) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 35),
        child: Container(
          height: 100,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  icon,
                  SizedBox(
                    width: 20,
                  ),
                  Text(title),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: value.toString(),
                        style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    TextSpan(
                        text: unit,
                        style: TextStyle(fontSize: 15, color: Colors.black45))
                  ])),
                  button
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              final pref = await SharedPreferences.getInstance();
              final measurementData = json.encode({
                'HeartRate': heartRate,
                'weight': weight,
                'bloodSugar': bloodSugar,
                'water': water,
                'heightfeet': heightFeet,
                'heightinches': heightInches,
                'bloodPressureUp': bloodPressureUp,
                'bloodPressureDown': bloodPressureDown
              });
              pref.setString('measurementData', measurementData);
              Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
            }),
        title: Text("Health"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black12,
          padding: const EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              _buildCard(
                'Heart rate',
                heartRate,
                'bpm',
                Icon(
                  FontAwesomeIcons.heartbeat,
                  color: Colors.red,
                ),
                _button(1, '', ''),
              ),
              SizedBox(
                height: 10,
              ),
              _buildCard(
                'Weight',
                weight,
                'kg',
                Icon(
                  FontAwesomeIcons.weightHanging,
                  color: Colors.red,
                ),
                _button(2, '', ''),
              ),
              SizedBox(
                height: 10,
              ),
              _buildCard(
                'Height',
                height = "$heightFeet' $heightInches''",
                'feet',
                Icon(
                  MyIcons.ruler,
                  color: Colors.red,
                ),
                _button(3, 'feet', 'inches'),
              ),
              SizedBox(
                height: 10,
              ),
              _buildCard(
                'Water',
                water,
                'glasses',
                Icon(
                  FontAwesomeIcons.glassWhiskey,
                  color: Colors.red,
                ),
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon: Icon(
                          MdiIcons.minus,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (water > 0) {
                            setState(() {
                              water -= 1;
                              tap(context, 0);
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            water += 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _buildCard(
                'Blood Pressure',
                pressure = "$bloodPressureUp/ $bloodPressureDown",
                'mmHg',
                Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.red,
                ),
                _button(4, '/', ''),
              ),
              SizedBox(
                height: 10,
              ),
              _buildCard(
                'Blood Sugar Level',
                bloodSugar,
                'mg/dL',
                Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.red,
                ),
                _button(5, '', ''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
