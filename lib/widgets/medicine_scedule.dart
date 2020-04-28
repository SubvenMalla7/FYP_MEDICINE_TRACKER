import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../model/medicine_prrovider.dart';
import '../model/Medicine.dart';
import '../model/MedicineLog.dart';

class MedicineScedule extends StatefulWidget {
  @override
  _MedicineSceduleState createState() => _MedicineSceduleState();
}

class _MedicineSceduleState extends State<MedicineScedule> {
  var status;
  var time;
  String reasons = '-';
  var color = Colors.red;
  String text = 'Not Taken';
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var _medicineLog = MedicineLog(
    title: '',
    amount: 0.25,
    time: '',
    date: DateTime.now().toString(),
    status: '',
    reasons: '',
  );

  initializeNotification() async {
    var initiallizeAndroid = AndroidInitializationSettings('ic_launcher');
    var initiallizeIOS = IOSInitializationSettings();
    var initSettings =
        InitializationSettings(initiallizeAndroid, initiallizeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }

  Future singleNotification(
    FlutterLocalNotificationsPlugin plugin,
    DateTime date,
    String message,
    String subText,
    int hashcode,
    String channelId,
  ) {
    var androidChannel = AndroidNotificationDetails(
      channelId,
      'chanel-name',
      'chanel-description',
      importance: Importance.Max,
      priority: Priority.Max,
    );
    print('Channel-Id $hashcode');
    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    plugin
        .
        // periodicallyShow(
        //     hashcode, message, subText, interval, platformChannel);
        schedule(hashcode, message, subText, date, platformChannel,
            payload: hashCode.toString());
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

  @override
  Widget build(BuildContext context) {
    Color colors = Theme.of(context).primaryColor;
    final medicine = Provider.of<Medicine>(context);
    var time = TimeOfDay.now();
    int min;
    print('this is medicine color ${medicine.title}');

    Future<void> notification() async {
      DateTime now = DateTime.now().toUtc().add(Duration(minutes: min));

      await singleNotification(
        localNotificationsPlugin,
        now,
        " It's time to take your medicine",
        'Please Take ${medicine.amount} ${medicine.type} of ${medicine.title}',
        int.parse((time.hour.toString() + time.minute.toString())),
        time.format(context),
      );
    }

    Future<Null> _selectTime(BuildContext context) async {
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
              title: medicine.title,
              amount: medicine.amount,
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

    Widget taken() {
      return Container(
        color: Theme.of(context).primaryColor,
        height: 280,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  'When did you take your medicine?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Theme.of(context).accentColor),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                  textColor: Colors.white,
                  onPressed: () {
                    _medicineLog = MedicineLog(
                      title: medicine.title,
                      amount: medicine.amount,
                      time: medicine.time,
                      date: DateTime.now().toString(),
                      status: 'Taken',
                      reasons: reasons,
                    );
                    _save(context);
                    setState(() {
                      text = 'Taken at ${medicine.time}';
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('On Time: (${medicine.time})')),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  _medicineLog = MedicineLog(
                    title: medicine.title,
                    amount: medicine.amount,
                    time: time.format(context),
                    date: DateTime.now().toString(),
                    status: 'Taken',
                    reasons: reasons,
                  );
                  _save(context);

                  setState(() {
                    text = 'Taken at ${time.format(context)}';
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Now (${time.format(context)})'),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () => _selectTime(context),
                child: Text('Pick Specific Time'),
              ),
            ],
          ),
        ),
      );
    }

    Widget snoozed() {
      return Container(
        height: 280,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Snooze For?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    min = 5;
                  });
                  notification();
                  Navigator.of(context).pop();
                },
                child: Text('5 Minutes from ${time.format(context)}'),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    min = 10;
                  });
                  notification();
                  Navigator.of(context).pop();
                },
                child: Text('10 Minutes from ${time.format(context)}'),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    min = 30;
                  });
                  notification();
                  Navigator.of(context).pop();
                },
                child: Text('30 Minutes from ${time.format(context)}'),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    min = 60;
                  });
                  notification();
                  Navigator.of(context).pop();
                },
                child: Text('1 hr from ${time.format(context)}'),
              ),
            ],
          ),
        ),
      );
    }

    Widget skipped() {
      return Container(
        height: 280,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  'When did you take your medicine?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    reasons = "Medicine isn't near me";
                  });
                  _medicineLog = MedicineLog(
                    title: medicine.title,
                    amount: medicine.amount,
                    time: medicine.time,
                    date: DateTime.now().toString(),
                    status: 'Skipped',
                    reasons: reasons,
                  );
                  _save(context);
                  Navigator.of(context).pop();
                },
                child: Text("Medicine isn't near me"),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    reasons = "Forgot/ busy/Asleep";
                  });
                  _medicineLog = MedicineLog(
                    title: medicine.title,
                    amount: medicine.amount,
                    time: time.format(context),
                    date: DateTime.now().toString(),
                    status: 'Skipped',
                    reasons: reasons,
                  );
                  _save(context);
                  Navigator.of(context).pop();
                },
                child: Text('Forgot/ busy/Asleep'),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    reasons = "Ran out of the medicine";
                  });
                  _medicineLog = MedicineLog(
                    title: medicine.title,
                    amount: medicine.amount,
                    time: time.format(context),
                    date: DateTime.now().toString(),
                    status: 'Skipped',
                    reasons: reasons,
                  );
                  _save(context);
                  Navigator.of(context).pop();
                },
                child: Text('Ran out of the medicine'),
              ),
            ],
          ),
        ),
      );
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

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Take ${medicine.amount.toString()}'),
                      Text(text, style: TextStyle(color: color))
                    ],
                  ),
                ),
                children: <Widget>[
                  Container(
                    height: 100,
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                  iconSize: 35,
                                  onPressed: () {
                                    _action(context);

                                    setState(() {
                                      status = 'cancel';
                                      text = 'Skipped ';
                                      color = Colors.red;
                                    });
                                  },
                                ),
                                Text(
                                  'Skip',
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
