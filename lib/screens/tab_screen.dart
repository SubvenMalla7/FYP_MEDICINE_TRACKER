import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_dasd/my_icons_icons.dart';

import '../model/auth.dart';

import './medicines_screen.dart';
import './dashboard_screen.dart';
import './user_profile.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tab_screen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  var isLoading = true;
  bool isInt = true;

  @override
  void didChangeDependencies() {
    print(isLoading);
    if (isInt) {
      final data = Provider.of<Auth>(context).fetchUserData();
      print(data);

      isLoading = false;
      isInt = false;
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    print(isLoading);
    _pages = [
      {
        'page': DashBoardScreen(),
        'title': 'Dashboard',
      },
      {
        'page': MedicineScreen(),
        'title': 'Add Medicines',
      },
      {
        'page': UserProfile(),
        'title': 'More',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(isLoading);
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        child: BottomNavigationBar(
          elevation: 10,
          onTap: _selectPage,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
          unselectedItemColor: Colors.white,
          selectedItemColor: Theme.of(context).accentColor,
          currentIndex: _selectedPageIndex,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.dashboard),
              title: Text(
                'Dashboard',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(MyIcons.medicine_bottle),
              title: Text(
                'Medicines',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            // BottomNavigationBarItem(
            //   backgroundColor: Theme.of(context).primaryColor,
            //   icon: Icon(Icons.more_horiz),
            //   title: Text(
            //     'More',
            //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
