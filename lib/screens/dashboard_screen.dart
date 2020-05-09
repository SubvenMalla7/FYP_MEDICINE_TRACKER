import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_dasd/screens/measurements.dart';
import 'package:test_dasd/screens/splash_screen.dart';

import '../widgets/medicine_scedule.dart';
import '../widgets/calender_widget.dart';
import '../model/medicine_prrovider.dart';
import '../screens/maps&phones.dart';
import '../screens/add_screen.dart';
import '../my_icons_icons.dart';
import '../widgets/app_drawer.dart';
// import '../widgets/buildCard_widget.dart';

class DashBoardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  var _isInt = true;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_isInt) {
      Provider.of<Medicines>(context).fetchAndSetMeds();
    }
    _isInt = false;
    _isLoading = false;

    super.didChangeDependencies();
  }

  // Widget appBar() {
  //   return Container(
  //     child: Container(

  //       alignment: Alignment.centerLeft,
  //       height: 100,
  //       width: 300,
  //       decoration: BoxDecoration(),
  //       // margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
  //       child: Calender(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final medicine = Provider.of<Medicines>(context);
    final screenSize = MediaQuery.of(context).size;
    final colors = Theme.of(context).primaryColor;
    final color = Theme.of(context).accentColor;

    return _isLoading
        ? SplashScreen()
        : Scaffold(
            drawer: AppDrawer(),
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
                    Navigator.pushNamed(context, Measurement.routeName);
                  },
                ),
              ],
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  forceElevated: true,
                  backgroundColor: colors,
                  expandedHeight: screenSize.height * 0.40,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                            bottom: Radius.circular(20)),
                        gradient: LinearGradient(
                          end: Alignment.topLeft,
                          begin: Alignment.bottomRight,
                          colors: <Color>[
                            color,
                            color.withOpacity(0.7),
                            color.withOpacity(0.5),
                            colors.withOpacity(0.5),
                            colors.withOpacity(0.4),
                            colors.withOpacity(0.5),
                            colors.withOpacity(0.7),
                            colors,
                          ],
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: screenSize.height * 0.15,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text(
                                'HI Admin',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                          ),
                          Container(
                            decoration: BoxDecoration(),
                            margin: const EdgeInsets.only(
                                top: 10, left: 5, right: 5),
                            child: Calender(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.mapMarkedAlt,
                          color: Colors.white.withOpacity(0.8),
                          size: 25,
                        ),
                        onPressed: () =>
                            Navigator.of(context).pushNamed(Map.routeName),
                      ),
                    )
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Container(
                      padding: const EdgeInsets.all(10),
                      child: ChangeNotifierProvider.value(
                        value: medicine.items[i],
                        child: MedicineScedule(),
                      ),
                    ),
                    childCount: medicine.items.length,
                  ),
                ),
              ],
            ),
          );
  }
}
