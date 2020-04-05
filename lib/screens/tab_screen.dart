import 'package:flutter/material.dart';

import './medicines_screen.dart';
import './dashboard_screen.dart';
import './user_profile.dart';
import '../widgets/app_drawer.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tab_screen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
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
        'title': 'Add Medicines',
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
    return Scaffold(
      drawer: AppDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        unselectedItemColor: Colors.black,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
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
            icon: Icon(Icons.add),
            title: Text(
              'Medicines',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.person_outline),
            title: Text('Profile',
             style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),),
          ),
        ],
      ),
    );
  }
}
