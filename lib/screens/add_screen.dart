import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

import 'package:test_dasd/screens/tab_screen.dart';
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
  int _groupValue = 4;
  static DateTime dateTime = DateTime.now();
  String date = DateFormat("yyyy-MM-dd").format(dateTime);
  var _editedMedicine = Medicine(
    id: null,
    title: '',
    amount: 0.25,
    time: '',
    icon: Icon(
      _icon,
    ),
    color: 0,
    date: DateTime.now().toString(),
    instruction: '',
    note: '',
    type: '',
  );
  String _freqencyItemSelected = 'Once a day';
  String _instruction = "Doesn't matter";
  TimeOfDay _time = TimeOfDay.now();
  double dose = 0;
  String selectedUnit = 'tablet(s)';
  int days;
  String daysTitle = 'Number of days';
  static List<IconData> icons = [
    MyIcons.color_pill,
    MyIcons.drugs,
    MyIcons.circle,
    MyIcons.oval,
    MyIcons.water,
    MyIcons.pill_vertical,
    MyIcons.vaccine,
    MyIcons.inhaler,
    MyIcons.eye_dropper,
    MyIcons.spray,
    MyIcons.spoon,
    MyIcons.medicine_bottle,

    // all the icons you want to include
  ];

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
  Icon icon;
  //Color _iconColor = Colors.red;
  var time;
  var inIt = true;
  List<bool> isSelected;
  var _isLoading = false;
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  //

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: textStyle(),
      ),
    );
  }

  var _frequecies = ['Once a day', 'Twice a day', '3 times a day'];

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

  Future<void> _save(BuildContext context) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    // print('this is ${_icon.codePoint}');
    _editedMedicine = Medicine(
      id: _editedMedicine.id,
      title: _editedMedicine.title,
      amount: _editedMedicine.id != null ? _editedMedicine.amount : dose,
      time: _time.format(context),
      icon: Icon(
        _icon,
        color: _iconColor,
      ),
      color: _iconColor.value,
      instruction: _editedMedicine.instruction,
      date: date,
      note: _editedMedicine.note,
      type: selectedUnit,
    );

    // print(_editedMedicine.color);
    // print(icon);
    // _icon = MyIcons.color_pill;
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
          builder: (ctx) => alert(context),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushNamed(TabsScreen.routeName);
  }

  Future<Null> _selectDose(BuildContext context) async {
    TextEditingController customController = TextEditingController();
    final _customNode = FocusNode();

    void tap(BuildContext context) {
      if (customController.text == '') {
        Navigator.of(context).pop();
        return;
      }
      if (customController.text != null) {
        setState(() {
          dose = double.parse(customController.text);
        });
      }
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add you dose!'),
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

  Future<Null> _selectDays(BuildContext context) async {
    TextEditingController customController = TextEditingController();
    final _customNode = FocusNode();

    void tap(BuildContext context) {
      if (customController.text == '') {
        Navigator.of(context).pop();
        return;
      }
      if (customController.text != null) {
        setState(() {
          days = int.parse(customController.text);

          daysTitle = 'Number of days: $days day(s)';
        });
      }
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add you dose!'),
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
    initializeNotification();
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

  initializeNotification() async {
    var initiallizeAndroid = AndroidInitializationSettings('ic_launcher');
    var initiallizeIOS = IOSInitializationSettings();
    var initSettings =
        InitializationSettings(initiallizeAndroid, initiallizeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Meds',
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.white70)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
                  _save(context);
                  notification();
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
                                    icon: _editedMedicine.icon,
                                    color: _editedMedicine.color,
                                    date: _editedMedicine.date,
                                    instruction: _editedMedicine.instruction,
                                    note: _editedMedicine.note,
                                    type: _editedMedicine.type);
                              },
                            ),
                          ),
                          //Instructions
                          buildCard(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
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
                                        style: textStyle(),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          _myRadioButton(
                                            title: "Before eating",
                                            value: 1,
                                            onChanged: (newValue) =>
                                                setState(() => {
                                                      _groupValue = newValue,
                                                      _instruction =
                                                          "Before eating",
                                                      _editedMedicine = Medicine(
                                                          id: _editedMedicine
                                                              .id,
                                                          title: _editedMedicine
                                                              .title,
                                                          amount:
                                                              _editedMedicine
                                                                  .amount,
                                                          time: _editedMedicine
                                                              .time,
                                                          icon: _editedMedicine
                                                              .icon,
                                                          color: _editedMedicine
                                                              .color,
                                                          date: _editedMedicine
                                                              .date,
                                                          instruction:
                                                              _instruction,
                                                          note: _editedMedicine
                                                              .note,
                                                          type: _editedMedicine
                                                              .type),
                                                    }),
                                          ),
                                          _myRadioButton(
                                            title: "While eating",
                                            value: 2,
                                            onChanged: (newValue) =>
                                                setState(() => {
                                                      _groupValue = newValue,
                                                      _instruction =
                                                          "While eating",
                                                      _editedMedicine = Medicine(
                                                          id: _editedMedicine
                                                              .id,
                                                          title: _editedMedicine
                                                              .title,
                                                          amount:
                                                              _editedMedicine
                                                                  .amount,
                                                          time: _editedMedicine
                                                              .time,
                                                          icon: _editedMedicine
                                                              .icon,
                                                          color: _editedMedicine
                                                              .color,
                                                          date: _editedMedicine
                                                              .date,
                                                          instruction:
                                                              _instruction,
                                                          note: _editedMedicine
                                                              .note,
                                                          type: _editedMedicine
                                                              .type),
                                                    }),
                                          ),
                                          _myRadioButton(
                                            title: "After eating",
                                            value: 3,
                                            onChanged: (newValue) =>
                                                setState(() => {
                                                      _groupValue = newValue,
                                                      _instruction =
                                                          "After eating",
                                                      _editedMedicine = Medicine(
                                                          id: _editedMedicine
                                                              .id,
                                                          title: _editedMedicine
                                                              .title,
                                                          amount:
                                                              _editedMedicine
                                                                  .amount,
                                                          time: _editedMedicine
                                                              .time,
                                                          icon: _editedMedicine
                                                              .icon,
                                                          color: _editedMedicine
                                                              .color,
                                                          date: _editedMedicine
                                                              .date,
                                                          instruction:
                                                              _instruction,
                                                          note: _editedMedicine
                                                              .note,
                                                          type: _editedMedicine
                                                              .type),
                                                    }),
                                          ),
                                          _myRadioButton(
                                            title: "Doesn't matter",
                                            value: 4,
                                            onChanged: (newValue) =>
                                                setState(() => {
                                                      _groupValue = newValue,
                                                      _instruction =
                                                          "Doesn't matter",
                                                      _editedMedicine = Medicine(
                                                          id: _editedMedicine
                                                              .id,
                                                          title: _editedMedicine
                                                              .title,
                                                          amount:
                                                              _editedMedicine
                                                                  .amount,
                                                          time: _editedMedicine
                                                              .time,
                                                          icon: _editedMedicine
                                                              .icon,
                                                          color: _editedMedicine
                                                              .color,
                                                          date: _editedMedicine
                                                              .date,
                                                          instruction:
                                                              _instruction,
                                                          note: _editedMedicine
                                                              .note,
                                                          type: _editedMedicine
                                                              .type),
                                                    }),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      TextFormField(
                                        decoration: InputDecoration(
                                            labelText:
                                                'Any other instructions?'),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 3,
                                        onSaved: (value) {
                                          _editedMedicine = Medicine(
                                              id: _editedMedicine.id,
                                              title: _editedMedicine.title,
                                              amount: _editedMedicine.amount,
                                              time: _editedMedicine.time,
                                              icon: _editedMedicine.icon,
                                              color: _editedMedicine.color,
                                              date: _editedMedicine.date,
                                              instruction:
                                                  _editedMedicine.instruction,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Frequency:',
                                            style: textStyle(),
                                          ),
                                          Container(
                                            child: dropDown(
                                              _frequecies,
                                              color,
                                              _freqencyItemSelected,
                                              (String newValue) {
                                                setState(() {
                                                  this._freqencyItemSelected =
                                                      newValue;
                                                });
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                GestureDetector(
                                  onTap: () => _selectTime(context),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Time:',
                                          style: textStyle(),
                                        ),
                                        Text(
                                          _editedMedicine.id != null
                                              ? _editedMedicine.time
                                              : '${_time.format(context)}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                          style: textStyle(),
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
                                                      _editedMedicine.amount >
                                                          0) {
                                                    setState(() {
                                                      _editedMedicine.id != null
                                                          ? _editedMedicine
                                                              .amount -= 0.25
                                                          : dose -= 0.25;
                                                    });
                                                  }
                                                },
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _selectDose(context);
                                                },
                                                child: Container(
                                                  width: 60,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.black54,
                                                            width: 3)),
                                                  ),
                                                  child: Text(
                                                    _editedMedicine.id != null
                                                        ? _editedMedicine.amount
                                                            .toString()
                                                        : dose.toString(),
                                                    style: TextStyle(
                                                        color: color,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.add,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _editedMedicine.id != null
                                                        ? _editedMedicine
                                                            .amount += 0.25
                                                        : dose += 0.25;
                                                  });
                                                },
                                              ),
                                              Container(
                                                child: dropDown(
                                                    _unit, color, selectedUnit,
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
                                            style: textStyle(),
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
                                              style: textStyle(),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                _myRadioButton(
                                                  title: "Every Day",
                                                  value: 1,
                                                  onChanged: (newValue) =>
                                                      setState(() =>
                                                          _groupValue =
                                                              newValue),
                                                ),
                                                InkWell(
                                                  onTap: () =>
                                                      _selectDays(context),
                                                  child: _myRadioButton(
                                                    title: daysTitle,
                                                    value: 2,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        _groupValue = newValue;
                                                        _selectDays(context);
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
                                padding: const EdgeInsets.only(bottom: 15.0),
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
                                            IconButton(
                                              onPressed: () {
                                                _icon = MyIcons.color_pill;
                                              },
                                              icon: Icon(MyIcons.color_pill,
                                                  color: _iconColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _icon = MyIcons.drugs;
                                              },
                                              icon: Icon(MyIcons.drugs,
                                                  color: _iconColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _icon = MyIcons.circle;
                                              },
                                              icon: Icon(MyIcons.circle,
                                                  color: _iconColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _icon = MyIcons.oval;
                                              },
                                              icon: Icon(MyIcons.oval,
                                                  color: _iconColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _icon = MyIcons.pill_vertical;
                                              },
                                              icon: Icon(MyIcons.pill_vertical,
                                                  color: _iconColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _icon = MyIcons.water;
                                              },
                                              icon: Icon(MyIcons.water,
                                                  color: _iconColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _icon = MyIcons.vaccine;
                                              },
                                              icon: Icon(MyIcons.vaccine,
                                                  color: _iconColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _icon = MyIcons.inhaler;
                                              },
                                              icon: Icon(MyIcons.inhaler,
                                                  color: _iconColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _icon = MyIcons.eye_dropper;
                                              },
                                              icon: Icon(MyIcons.eye_dropper,
                                                  color: _iconColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _icon = MyIcons.spray;
                                              },
                                              icon: Icon(MyIcons.spray,
                                                  color: _iconColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _icon = MyIcons.medicine_bottle;
                                              },
                                              icon: Icon(
                                                  MyIcons.medicine_bottle,
                                                  color: _iconColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
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
                                                    const EdgeInsets.all(8.0),
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
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            child: RaisedButton(
                              elevation: 5,
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                _save(context);
                                notification();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => notification(),
        child: Icon(Icons.notifications),
      ),
    );
  }

/////////////////////////////////// NOTIFICATION////////////////////////////////////////////////////////
  Future<void> notification() async {
    String hour = _time.hour.toString();
    String min = _time.minute.toString().length == 2
        ? _time.minute.toString()
        : '0${_time.minute.toString()}';
    print(date);
    print(_time.format(context));
    DateTime now = DateTime.parse("$date $hour:$min:00");
    //DateTime.now().toUtc().add(Duration(seconds: 5));
    await singleNotification(
      localNotificationsPlugin,
      now,
      " It's time to take your medicine",
      'Please Take ${_editedMedicine.amount} ${_editedMedicine.type} of ${_editedMedicine.title}',
      int.parse((_time.hour.toString() + _time.minute.toString())),
      _time.format(context),
      RepeatInterval.Daily,
    );
  }

  Future singleNotification(
    FlutterLocalNotificationsPlugin plugin,
    DateTime date,
    String message,
    String subText,
    int hashcode,
    String channelId,
    RepeatInterval interval,
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
}
