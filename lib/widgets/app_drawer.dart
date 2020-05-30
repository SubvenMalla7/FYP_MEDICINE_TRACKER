import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../model/auth.dart';
import '../my_icons_icons.dart';
import '../screens/user_profile.dart';
import '../screens/medicines_screen.dart';
import '../screens/maps&phones.dart';
import '../screens/measurements.dart';
import '../screens/tab_screen.dart';

class AppDrawer extends StatelessWidget {
  static const routeName = '/appbar';
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle() {
      return TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
    }

    final screenSize = MediaQuery.of(context).size;
    final userdata = Provider.of<Auth>(context);
    return Container(
      padding: const EdgeInsets.only(top: 35),
      //height: 740,
      height: screenSize.height * 0.88,
      width: screenSize.width * 0.5,
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
        child: Drawer(
          key: Key('AppDrawer'),
          elevation: 10,
          child: Container(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    PageRouteBuilder<Null>(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return AnimatedBuilder(
                            animation: animation,
                            builder: (BuildContext context, Widget child) {
                              return Opacity(
                                opacity: animation.value,
                                child: UserProfile(),
                              );
                            });
                      },
                      transitionDuration: Duration(milliseconds: 500),
                    ),
                  ),
                  // Navigator.of(context).pushNamed(UserProfile.routeName),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        key: Key('userprofile'),
                        height: 160,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 70,
                                width: 70,
                                child: Hero(
                                  tag: userdata.userId,
                                  child: CircleAvatar(
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                userdata.name == null ? '' : userdata.name,
                                style: textStyle(),
                              ),
                              Text(
                                userdata.email == null ? '' : userdata.email,
                                style: textStyle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.dashboard,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Dashboard',
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(TabsScreen.routeName);
                  },
                ),
                Divider(
                  thickness: 3,
                ),
                ListTile(
                  key: Key('mesurements'),
                  leading: Icon(
                    MyIcons.ruler,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Body Measurement',
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(Measurement.routeName);
                  },
                ),
                Divider(
                  thickness: 3,
                ),
                ListTile(
                  key: Key('map'),
                  leading: Icon(
                    FontAwesomeIcons.mapMarkedAlt,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text('Maps'),
                  onTap: () {
                    Navigator.of(context).pushNamed(Map.routeName);
                  },
                ),
                Divider(
                  thickness: 3,
                ),
                ListTile(
                  leading: Icon(
                    MyIcons.medicine_bottle,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text('Medicines'),
                  onTap: () {
                    Navigator.of(context).pushNamed(MedicineScreen.routeName);
                  },
                ),
                Divider(
                  thickness: 3,
                ),
                SizedBox(
                  height: 120,
                ),
                Container(
                  height: 50,
                  width: 180,
                  child: FlatButton(
                    key: Key('logout'),
                    color: Theme.of(context).errorColor,
                    shape: StadiumBorder(),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                      Provider.of<Auth>(context, listen: false).logout();
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.exit_to_app,
                          size: 25,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
