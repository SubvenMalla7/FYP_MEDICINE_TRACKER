import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:test_dasd/widgets/app_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/medicine_scedule.dart';
import '../widgets/calender_widget.dart';
import '../model/medicine_prrovider.dart';
import '../screens/maps&phones.dart';
import '../screens/add_screen.dart';
import '../my_icons_icons.dart';

class DashBoardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  var _isInt = true;

  @override
  void didChangeDependencies() {
    if (_isInt) {
      Provider.of<Medicines>(context).fetchAndSetMeds();
    }
    _isInt = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final medicine = Provider.of<Medicines>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Take your Medicines!',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed(Map.routeName),
              icon: Icon(FontAwesomeIcons.mapMarkedAlt,
                  color: Theme.of(context).accentColor, size: 25),
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                child: Calender(),
              ),
              Container(
                height: 520,
                //height: 460,
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: medicine.items[i],
                    child: MedicineScedule(),
                  ),
                  itemCount: medicine.items.length,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        elevation: 8,
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add),
        children: [
          SpeedDialChild(
            child: Icon(MyIcons.more_1),
            label: 'Add Medicine',
            labelStyle: TextStyle(color: Theme.of(context).accentColor),
            onTap: () {
              Navigator.pushNamed(context, AddScreen.routeName);
            },
          ),
          SpeedDialChild(
            child: Icon(MyIcons.ruler),
            label: 'Add Mesurements',
            labelStyle: TextStyle(color: Theme.of(context).accentColor),
            onTap: () {
              print("Add dose");
            },
          ),
          SpeedDialChild(
            child: Icon(MyIcons.dose),
            label: 'Add Dose',
            labelStyle: TextStyle(color: Theme.of(context).accentColor),
            onTap: () => print("Add dose"),
          ),
        ],
      ),
    );
  }
}
