import 'package:flutter/material.dart';
import 'package:test_dasd/widgets/app_drawer.dart';
import '../widgets/user_medicines.dart';
import 'package:provider/provider.dart';
import '../model/medicine_prrovider.dart';

// import './add_medicines.dart';
import './add_screen.dart';

class MedicineScreen extends StatelessWidget {
  static const routeName = '/medicines';

  Future<void> _refreshMedicines(BuildContext context) async {
   await Provider.of<Medicines>(context,listen: false).fetchAndSetMeds();
  }

  @override
  Widget build(BuildContext context) {
    final medicineData = Provider.of<Medicines>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicines'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddScreen.routeName),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(AddScreen.routeName),
      ),
      drawer: AppDrawer(),
      body:
      RefreshIndicator(
        onRefresh:()=>_refreshMedicines(context),
        child: 
        Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: medicineData.items.length,
            itemBuilder: (_, i) => Column(
              children: <Widget>[
                UserMedicines(
                  medicineData.items[i].id,
                  medicineData.items[i].icon,
                  medicineData.items[i].title,
                ),
                Divider()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
















