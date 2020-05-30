import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import '../widgets/notification.dart';

import '../screens/tab_screen.dart';
import '../my_icons_icons.dart';
import 'package:provider/provider.dart';
import '../model/Medicine.dart';
import '../model/medicine_prrovider.dart';
import '../widgets/buildCard_widget.dart';

class AddScreen extends StatefulWidget {
  static const routeName = '/add';

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  //variables

  final _form = GlobalKey<FormState>();
  int _groupValue = 1;
  static DateTime dateTime = DateTime.now();
  String date = DateFormat("yyyy-MM-dd").format(dateTime);
  var _editedMedicine = Medicine(
    id: null,
    title: '',
    amount: 0.25,
    time: '',
    interval: 1,
    icon: Icon(
      _icon,
    ),
    color: 0,
    date: DateTime.now().toString(),
    instruction: '',
    note: '',
    type: '',
  );

  String _instruction = "Doesn't matter";
  TimeOfDay _time = TimeOfDay.now();
  double dose = 0;
  String selectedUnit = 'tablet(s)';
  int days;
  String daysTitle = 'Number of days';

  Function onpressed(String title) {
    return (newValue) => setState(() => {
          _groupValue = newValue,
          _instruction = title,
          _editedMedicine = Medicine(
              id: _editedMedicine.id,
              title: _editedMedicine.title,
              amount: _editedMedicine.amount,
              time: _editedMedicine.time,
              interval: _editedMedicine.interval,
              icon: _editedMedicine.icon,
              color: _editedMedicine.color,
              date: _editedMedicine.date,
              instruction: _instruction,
              note: _editedMedicine.note,
              type: _editedMedicine.type),
        });
  }

  var _selected = 0;

  static var _icon = MyIcons.color_pill;
  Color _iconColor = Colors.white70;
  static List<Color> colors = [
    Colors.white70,
    Colors.red,
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.green,
    Colors.black,
  ];
  var _intervals = [
    6,
    8,
    12,
    24,
  ];
  var time;
  var inIt = true;
  List<bool> isSelected;
  var _isLoading = false;
  // FlutterLocalNotificationsPlugin localNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  var _unit = [
    'tablet(s)',
    'drop(s)',
    'gram(s)',
    'milligram(s)',
    'injection(s)',
    'pill(s)',
    'puff(s)',
    'spray(s)',
    'tablespoon(S)',
    'teaspoon(s)',
  ];

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (picked != null) {
      setState(
        () {
          _time = picked;
          time = _time.format(context);

          _editedMedicine = Medicine(
              id: _editedMedicine.id,
              title: _editedMedicine.title,
              amount: _editedMedicine.amount,
              time: time.toString(),
              interval: _editedMedicine.interval,
              icon: _editedMedicine.icon,
              color: _editedMedicine.color,
              date: _editedMedicine.date,
              instruction: _editedMedicine.instruction,
              note: _editedMedicine.note,
              type: _editedMedicine.type);
        },
      );
    }
  }

  Widget icon(IconData icon) {
    return IconButton(
      onPressed: () {
        _icon = icon;
      },
      icon: Icon(icon, color: _iconColor),
    );
  }

  Future<void> _save(BuildContext context) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _editedMedicine = Medicine(
      id: _editedMedicine.id,
      title: _editedMedicine.title,
      amount: _editedMedicine.id != null ? _editedMedicine.amount : dose,
      time: _time.format(context),
      interval:
          _editedMedicine.interval == 0 ? _editedMedicine.interval : _selected,
      icon: Icon(
        _icon,
        color: _iconColor,
      ),
      color: _iconColor.value,
      instruction: _editedMedicine.instruction.isNotEmpty
          ? _editedMedicine.instruction
          : "Doesn't matter",
      date: date,
      note: _editedMedicine.note == '' ? "-" : _editedMedicine.note,
      type: selectedUnit,
    );

    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedMedicine.id != null) {
      await Provider.of<Medicines>(context, listen: false)
          .updateMedicine(_editedMedicine.id, _editedMedicine);
    } else {
      try {
        await Provider.of<Medicines>(context, listen: false)
            .addMedicines(_editedMedicine);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) =>
              alert(context, 'An Error Occurred', 'Please try again!'),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushNamed(TabsScreen.routeName);
  }

  Future<Null> _selectDose(BuildContext context, int id) async {
    TextEditingController customController = TextEditingController();
    final _customNode = FocusNode();

    void tap(BuildContext context) {
      if (customController.text == '') {
        Navigator.of(context).pop();
        return;
      }
      if (customController.text != null) {
        setState(() {
          id == 1
              ? dose = double.parse(customController.text)
              : days = int.parse(customController.text);

          daysTitle = 'Number of days: $days day(s)';
        });
      }
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(id == 1 ? 'Add you dose!' : 'Number Of Days'),
        content: TextField(
          controller: customController,
          focusNode: _customNode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => tap(context),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
          ),
          FlatButton(
            onPressed: () => tap(context),
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void _selectdate(BuildContext context) {
    selectdate(context, dateTime).then((DateTime picked) {
      if (picked != null && picked != dateTime) {
        setState(
          () {
            dateTime = picked;
            _editedMedicine = Medicine(
              id: _editedMedicine.id,
              title: _editedMedicine.title,
              amount:
                  _editedMedicine.id != null ? _editedMedicine.amount : dose,
              time: _time.format(context),
              interval: _editedMedicine.interval,
              icon: Icon(
                _icon,
                color: _iconColor,
              ),
              color: _iconColor.value,
              instruction: _editedMedicine.instruction,
              date: DateFormat("yyyy-MM-dd").format(dateTime),
              note: _editedMedicine.note,
              type: selectedUnit,
            );
          },
        );
      }
    });
  }

  void _changeIconColor(Color selectedColor) {
    setState(() {
      _iconColor = selectedColor;
    });
  }

  @override
  void initState() {
    super.initState();
    isSelected = [
      true,
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ];
    ini();
  }

  @override
  void didChangeDependencies() {
    if (inIt) {
      final medicineId = ModalRoute.of(context).settings.arguments as String;
      if (medicineId != null) {
        _editedMedicine =
            Provider.of<Medicines>(context, listen: false).findById(medicineId);
      }
    }
    inIt = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            shape: StadiumBorder(),
            title: Text(
              'Add Your Meds',
              style: textStyle(Colors.white),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                    key: Key('done'),
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      _save(context);
                      noti(
                        _editedMedicine.amount.toString(),
                        _editedMedicine.type,
                        _editedMedicine.title,
                      );
                    }),
              )
            ],
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    color: Theme.of(context).backgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Form(
                          key: _form,
                          child: Column(
                            children: <Widget>[
                              buildCard(
                                child: TextFormField(
                                  key: Key('medicineName'),
                                  initialValue: _editedMedicine.title,
                                  decoration:
                                      InputDecoration(labelText: 'Medicine'),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter the name of medicine';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedMedicine = Medicine(
                                      id: _editedMedicine.id,
                                      title: value,
                                      amount: _editedMedicine.amount,
                                      time: _editedMedicine.time,
                                      interval: _editedMedicine.interval,
                                      icon: _editedMedicine.icon,
                                      color: _editedMedicine.color,
                                      date: _editedMedicine.date,
                                      instruction: _editedMedicine.instruction,
                                      note: _editedMedicine.note,
                                      type: _editedMedicine.type,
                                    );
                                  },
                                ),
                              ),
                              //Instructions
                              buildCard(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: Text(
                                        'Instructions',
                                        style: headingStyle(context),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Should this be taken with food?',
                                            style: textStyle(Colors.black54),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              myRadioButton2(
                                                groupValue: _groupValue,
                                                onChange:
                                                    onpressed("Before eating"),
                                                title: "Before eating",
                                                value: 1,
                                              ),
                                              myRadioButton2(
                                                groupValue: _groupValue,
                                                title: "While eating",
                                                onChange:
                                                    onpressed("While eating"),
                                                value: 2,
                                              ),
                                              myRadioButton2(
                                                groupValue: _groupValue,
                                                title: "After eating",
                                                onChange:
                                                    onpressed("After eating"),
                                                value: 3,
                                              ),
                                              myRadioButton2(
                                                groupValue: _groupValue,
                                                title: "Doesn't matter",
                                                onChange:
                                                    onpressed("Doesn't matter"),
                                                value: 4,
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          buildForm(
                                            'instruction',
                                            '-',
                                            'Any other instructions?',
                                            '',
                                            TextInputType.multiline,
                                            (value) {
                                              _editedMedicine = Medicine(
                                                  id: _editedMedicine.id,
                                                  title: _editedMedicine.title,
                                                  amount:
                                                      _editedMedicine.amount,
                                                  time: _editedMedicine.time,
                                                  interval:
                                                      _editedMedicine.interval,
                                                  icon: _editedMedicine.icon,
                                                  color: _editedMedicine.color,
                                                  date: _editedMedicine.date,
                                                  instruction: _editedMedicine
                                                      .instruction,
                                                  note: value,
                                                  type: _editedMedicine.type);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //Reminder Times
                              buildCard(
                                  child: Container(
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Reminder Times',
                                      style: headingStyle(context),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text("Remind me every",
                                                  style: textStyle(
                                                      Colors.black54)),
                                              SizedBox(
                                                width: screenSize.width * 0.1,
                                              ),
                                              DropdownButton<int>(
                                                key: Key('interval'),
                                                hint: _selected == 0
                                                    ? Text(
                                                        "Interval",
                                                        style: textStyle(color),
                                                      )
                                                    : null,
                                                elevation: 4,
                                                value: _selected == 0
                                                    ? null
                                                    : _selected,
                                                items:
                                                    _intervals.map((int value) {
                                                  return DropdownMenuItem<int>(
                                                    value: value,
                                                    child: Text(
                                                      value.toString(),
                                                      style: textStyle(color),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (newVal) {
                                                  setState(() {
                                                    _selected = newVal;
                                                  });
                                                },
                                              ),
                                              Text(
                                                _selected == 1
                                                    ? " hour"
                                                    : " hours",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () => _selectTime(context),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Time:',
                                                  style:
                                                      textStyle(Colors.black54),
                                                ),
                                                SizedBox(
                                                  width:
                                                      screenSize.width * 0.45,
                                                ),
                                                Text(
                                                  _editedMedicine.id != null
                                                      ? _editedMedicine.time
                                                      : '${_time.format(context)}',
                                                  style: textStyle(color),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Container(
                                      //padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                      child: GestureDetector(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Dose:',
                                              style: textStyle(Colors.black54),
                                            ),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  IconButton(
                                                    icon: Icon(
                                                      MdiIcons.minus,
                                                    ),
                                                    onPressed: () {
                                                      if (dose > 0 ||
                                                          _editedMedicine
                                                                  .amount >
                                                              0) {
                                                        setState(() {
                                                          _editedMedicine.id !=
                                                                  null
                                                              ? _editedMedicine
                                                                      .amount -=
                                                                  0.25
                                                              : dose -= 0.25;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _selectDose(context, 1);
                                                    },
                                                    child: Container(
                                                      width: screenSize.width *
                                                          0.09,
                                                      height:
                                                          screenSize.height *
                                                              0.04,
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors
                                                                  .black54,
                                                              width: 3),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        _editedMedicine.id !=
                                                                null
                                                            ? _editedMedicine
                                                                .amount
                                                                .toString()
                                                            : dose.toString(),
                                                        style: TextStyle(
                                                            color: color,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.add,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _editedMedicine.id !=
                                                                null
                                                            ? _editedMedicine
                                                                .amount += 0.25
                                                            : dose += 0.25;
                                                      });
                                                    },
                                                  ),
                                                  Container(
                                                    child: dropDown(_unit,
                                                        color, selectedUnit,
                                                        (String newValue) {
                                                      setState(() {
                                                        this.selectedUnit =
                                                            newValue;
                                                      });
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                              //schedule
                              buildCard(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Schedule',
                                      style: headingStyle(context),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(18),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                'Start Date:',
                                                style:
                                                    textStyle(Colors.black54),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _selectdate(context);
                                                },
                                                child: Text(
                                                  date,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Duration',
                                                  style:
                                                      textStyle(Colors.black54),
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    myRadioButton1(
                                                      title: "Every Day",
                                                      value: 1,
                                                      groupValue: _groupValue,
                                                      onChanged: (newValue) =>
                                                          setState(() =>
                                                              _groupValue =
                                                                  newValue),
                                                    ),
                                                    InkWell(
                                                      onTap: () => _selectDose(
                                                          context, 2),
                                                      child: myRadioButton1(
                                                        title: daysTitle,
                                                        value: 2,
                                                        groupValue: _groupValue,
                                                        onChanged: (newValue) {
                                                          _selectDose(
                                                              context, 2);
                                                          setState(() {
                                                            _groupValue =
                                                                newValue;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //Med icon
                              buildCard(
                                  child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Text(
                                      'Medicine Icon',
                                      style: headingStyle(context),
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13),
                                        color: Colors.black38,
                                      ),
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: <Widget>[
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: <Widget>[
                                                icon(MyIcons.color_pill),
                                                icon(MyIcons.drugs),
                                                icon(MyIcons.circle),
                                                icon(MyIcons.oval),
                                                icon(MyIcons.pill_vertical),
                                                icon(MyIcons.water),
                                                icon(MyIcons.vaccine),
                                                icon(MyIcons.inhaler),
                                                icon(MyIcons.eye_dropper),
                                                icon(MyIcons.spray),
                                                icon(MyIcons.medicine_bottle),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenSize.height * 0.04,
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                for (var color in colors)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                      onTap: () => {
                                                        _changeIconColor(color),
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor: color,
                                                        radius: 15,
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              )),
                              //button
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                child: RaisedButton(
                                  elevation: 5,
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    _save(context);
                                    noti(
                                      _editedMedicine.amount.toString(),
                                      _editedMedicine.type,
                                      _editedMedicine.title,
                                    );
                                  },
                                  child: Text(
                                    'Done',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void ini() {
    initializeNotification();
  }

  void noti(String amount, String type, String title) {
    notifications(context, _time, 'Please Take $amount $type of $title', false,
        _selected, 1);
  }
}
