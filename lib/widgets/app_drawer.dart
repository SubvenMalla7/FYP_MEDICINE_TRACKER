import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../model/auth.dart';
import '../my_icons_icons.dart';
import '../screens/user_profile.dart';
import '../screens/medicines_screen.dart';
import '../screens/maps&phones.dart';
import '../screens/measurements.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userdata= Provider.of<Auth>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(UserProfile.routeName),
                child: UserAccountsDrawerHeader(
                  accountName: Text(
                    userdata.name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: Text(
                    userdata.email,
                    style: TextStyle(color: Colors.white),
                  ),
                  currentAccountPicture: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              MyIcons.ruler,
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              'Body Measurement',
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Measurement.routeName);
            },
          ),
          Divider(
            thickness: 3,
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.mapMarked,
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
              Navigator.pop(context);
            },
          ),
          Divider(
            thickness: 3,
          ),
          SizedBox(
            height: 200,
          ),
          Container(
            height: 50,
            width: 250,
            child: FlatButton(
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
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
