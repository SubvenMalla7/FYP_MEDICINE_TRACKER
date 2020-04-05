import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/signUp_screen.dart';
import 'model/medicine_prrovider.dart';
import './model/auth.dart';
//import './screens/add_medicines.dart';
import './screens/tab_screen.dart';
import './screens/medicines_screen.dart';
import './screens/add_screen.dart';
import './screens/auth_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/splash_screen.dart';
import './screens/medcineScreen.dart';
import './screens/user_profile.dart';

void main() {
  runApp(MyApp());
}

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
          ChangeNotifierProvider.value(
            value: Medicines(
              authData.token,
              authData.userId,
            ),
          ),
          // ChangeNotifierProxyProvider<Auth, Medicines>(
          //      create: (context) => Medicines('','', []),
          //   //   var auth = Provider.of<Auth>(context);
          //   //   Medicines(auth.token, []);
          //   // },
          //   update: (context, auth, updatedMedicines) => Medicines(auth.token,auth.userId,
          //       updatedMedicines == null ? [] : updatedMedicines.items),
          // ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Medicine Tracker',
            theme: ThemeData(
              //primaryColor: Color.fromRGBO(232, 177, 0, 1),//yellow
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
                            : AuthScreen(),
                  ),
            routes: {
              DashBoardScreen.routeName: (ctx) => DashBoardScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              SignUp.routeName: (ctx) => SignUp(),
              // AddMedicinesScreen.routeName: (ctx) => AddMedicinesScreen(),
              MedicineScreen.routeName: (ctx) => MedicineScreen(),
              TabsScreen.routeName: (ctx) => TabsScreen(),
              AddScreen.routeName: (ctx) => AddScreen(),
              SingleMedicine.routeName: (ctx) => SingleMedicine(),
              UserProfile.routeName: (ctx) => UserProfile(),
            },
          ),
        ));
  }
}
