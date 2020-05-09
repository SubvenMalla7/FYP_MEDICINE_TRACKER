import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/medicine_prrovider.dart';
import './model/auth.dart';
import './screens/tab_screen.dart';
import './screens/medicines_screen.dart';
import './screens/add_screen.dart';

import './screens/dashboard_screen.dart';
import './screens/splash_screen.dart';
import './screens/medcineScreen.dart';
import './screens/user_profile.dart';
import './screens/maps&phones.dart';
import './screens/measurements.dart';
import './screens/addUserDetails.dart';
import './screens/signupLoginup.dart';

void main() {
  runApp(MyApp());
}
// AIzaSyAtji8RF0OkgNMx4TGRPgVqgK7BBBSygtY

class MyApp extends StatelessWidget {
  // This widget is the root of the application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Auth(),
      child: MedicineApp(),
    );
  }
}

class MedicineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Medicines(
              authData.token,
              authData.userId,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Medicine Tracker',
            theme: ThemeData(
              primaryColor: Color.fromRGBO(227, 152, 23, 1),
              accentColor: Color.fromRGBO(192, 19, 56, 1), //red
              backgroundColor: Colors.white,

              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? TabsScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (ctx, authResultSnapShot) =>
                        authResultSnapShot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : LoginSign(),
                  ),
            routes: {
              DashBoardScreen.routeName: (ctx) => DashBoardScreen(),
              MedicineScreen.routeName: (ctx) => MedicineScreen(),
              TabsScreen.routeName: (ctx) => TabsScreen(),
              AddScreen.routeName: (ctx) => AddScreen(),
              SingleMedicine.routeName: (ctx) => SingleMedicine(),
              UserProfile.routeName: (ctx) => UserProfile(),
              Map.routeName: (ctx) => Map(),
              Measurement.routeName: (ctx) => Measurement(),
              AddUserDetails.routeName: (ctx) => AddUserDetails(),
            },
          ),
        ));
  }
}
