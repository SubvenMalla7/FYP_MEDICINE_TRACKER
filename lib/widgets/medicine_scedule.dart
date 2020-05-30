import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_dasd/widgets/buildCard_widget.dart';

import '../widgets/animation.dart';
import '../widgets/notification.dart';
import '../model/medicine_prrovider.dart';
import '../model/Medicine.dart';
import '../model/MedicineLog.dart';

class MedicineScedule extends StatefulWidget {
  @override
  _MedicineSceduleState createState() => _MedicineSceduleState();
}

class _MedicineSceduleState extends State<MedicineScedule> {
  var status;
  TimeOfDay time = TimeOfDay.now();
  String reasons = '-';
  var color = Colors.red;
  String text = 'Not Taken';

  var _medicineLog = MedicineLog(
    title: '',
    amount: 0.25,
    time: '',
    date: DateTime.now().toString(),
    status: '',
    reasons: '',
  );

  void notification(String amount, String type, int min, String title) {
    notifications(
      context,
      TimeOfDay.now(),
      'Please Take $amount $type of $title',
      true,
      0,
      min,
    );
  }

  Future<void> _save(BuildContext context) async {
    _medicineLog = MedicineLog(
      title: _medicineLog.title,
      amount: _medicineLog.amount,
      time: _medicineLog.time,
      date: _medicineLog.date,
      status: _medicineLog.status,
      reasons: _medicineLog.reasons,
    );
    try {
      await Provider.of<Medicines>(context, listen: false)
          .addMedicinesLog(_medicineLog);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An unexpected error occured'),
          content: Text('Somthing went error'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Okay',
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }

  Future<Null> _selectTime(
      BuildContext context, String title, double amount) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: time,
    );

    if (picked != null) {
      setState(
        () {
          time = picked;
          time = time;

          _medicineLog = MedicineLog(
            title: title,
            amount: amount,
            time: time.format(context),
            date: DateTime.now().toString(),
            status: 'Taken',
            reasons: reasons,
          );

          text = 'Taken at ${time.format(context)}';
          color = Colors.green;
        },
      );
    }
    _save(context);
    Navigator.of(context).pop();
  }

  Widget button(String key, String title, double amount, String time,
      String statuss, String message) {
    return FlatButton(
      key: Key(key),
      color: Theme.of(context).primaryColor,
      shape: StadiumBorder(),
      onPressed: () {
        setState(() => reasons = message);
        //print(reasons);
        _medicineLog = MedicineLog(
          title: title,
          amount: amount,
          time: time,
          date: DateTime.now().toString(),
          status: statuss,
          reasons: statuss == 'Taken' ? '-' : reasons,
        );
        _save(context);

        Navigator.of(context).pop();
      },
      child: Text(
        message,
        style: textStyle(Colors.white),
      ),
    );
  }

  Widget snoozeButton(
    String key,
    String amount,
    String type,
    int min,
    String title,
    String message,
  ) {
    return FlatButton(
      key: Key(key),
      shape: StadiumBorder(),
      color: Theme.of(context).primaryColor,
      onPressed: () {
        notification(amount, type, min, title);
        Navigator.of(context).pop();
      },
      child: Text(
        message,
        style: textStyle(Colors.white),
      ),
    );
  }

  void ini() {
    initializeNotification();
  }

  @override
  void initState() {
    ini();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color colors = Theme.of(context).primaryColor;
    final medicine = Provider.of<Medicine>(context);
    final screenSize = MediaQuery.of(context).size;
    var time = TimeOfDay.now();

    Widget sized() {
      return SizedBox(height: screenSize.height * 0.01);
    }

    Widget taken() {
      return option(
        context,
        Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                'When did you take your medicine?',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).accentColor),
              ),
            ),
            sized(),
            sized(),
            sized(),
            button('onMedicineTime', medicine.title, medicine.amount,
                medicine.time, 'Taken', 'On Time: (${medicine.time})'),
            sized(),
            button('onCurrentTime', medicine.title, medicine.amount,
                time.format(context), 'Taken', 'Now (${time.format(context)})'),
            sized(),
            FlatButton(
              shape: StadiumBorder(),
              color: Theme.of(context).primaryColor,
              onPressed: () => _selectTime(
                context,
                medicine.title,
                medicine.amount,
              ),
              child: Text(
                'Pick Specific Time',
                style: textStyle(Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    Widget snoozed() {
      return option(
        context,
        Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                'Snooze For?',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).accentColor),
              ),
            ),
            sized(),
            sized(),
            snoozeButton(
              'snooze1',
              medicine.amount.toString(),
              medicine.type,
              5,
              medicine.title,
              '5 Minutes from ${time.format(context)}',
            ),
            sized(),
            snoozeButton(
              'snooze2',
              medicine.amount.toString(),
              medicine.type,
              10,
              medicine.title,
              '10 Minutes from ${time.format(context)}',
            ),
            sized(),
            snoozeButton(
              'snooze3',
              medicine.amount.toString(),
              medicine.type,
              30,
              medicine.title,
              '30 Minutes from ${time.format(context)}',
            ),
            sized(),
            snoozeButton(
              'snooze4',
              medicine.amount.toString(),
              medicine.type,
              60,
              medicine.title,
              '1 hour from ${time.format(context)}',
            ),
            sized(),
          ],
        ),
      );
    }

    Widget skipped() {
      return option(
        context,
        Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                'When did you take your medicine?',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).accentColor),
              ),
            ),
            sized(),
            sized(),
            sized(),
            button('reason1', medicine.title, medicine.amount, medicine.time,
                'Skipped', "Medicine isn't near me"),
            sized(),
            button('reason2', medicine.title, medicine.amount, medicine.time,
                'Skipped', "Forgot/ busy/Asleep"),
            sized(),
            button('reason3', medicine.title, medicine.amount, medicine.time,
                'Skipped', "Ran out of the medicine"),
            sized(),
          ],
        ),
      );
    }

    TextStyle cardText() {
      return TextStyle(fontWeight: FontWeight.w300, fontSize: 15);
    }

    Future<void> _action(BuildContext ctx) {
      return showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: Container(
                child: status == 'Snoozed'
                    ? snoozed()
                    : status == 'Taken' ? taken() : skipped()),
            behavior: HitTestBehavior.opaque,
          );
        },
      );
    }

    return SideInAnimation(
      delay: 1,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 8,
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
                    ],
                  ),
                ),
                height: screenSize.height * 0.07,
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
                    color: Colors.black.withOpacity(0.005),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20))),
                child: ExpansionTile(
                  title: ListTile(
                    leading: Container(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: medicine.color == Colors.white70.value
                            ? Colors.black87
                            : Colors.black12,
                        child: Hero(tag: medicine.id, child: medicine.icon),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        medicine.title,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            'Take ${medicine.amount.toString()} ${medicine.type}',
                            style: cardText()),
                        Text(medicine.instruction, style: cardText()),
                        Text(text, style: TextStyle(color: color)),
                      ],
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      height: screenSize.height * 0.12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  IconButton(
                                    key: Key('taken'),
                                    icon: Icon(
                                      Icons.check,
                                      color: colors,
                                    ),
                                    iconSize: 35,
                                    onPressed: () {
                                      _action(context);

                                      setState(() {
                                        status = "Taken";
                                        text = 'Taken ';
                                        color = Colors.green;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Taken',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  IconButton(
                                    key: Key('snooze'),
                                    icon: Icon(Icons.snooze,
                                        color: Color.fromRGBO(240, 208, 0, 1)),
                                    iconSize: 35,
                                    onPressed: () {
                                      _action(context);
                                      setState(() {
                                        status = 'Snoozed';
                                        text = 'Snoozed';
                                        color = Colors.deepOrange;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Snooze',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  IconButton(
                                    key: Key('skiped'),
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    iconSize: 35,
                                    onPressed: () {
                                      _action(context);

                                      setState(() {
                                        status = 'cancel';
                                        text = 'Skipped';
                                        color = Colors.red;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Skip',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
