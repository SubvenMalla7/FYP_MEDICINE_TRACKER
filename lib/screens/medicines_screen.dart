import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_dasd/screens/medcineScreen.dart';

import '../widgets/user_medicines.dart';
import '../model/medicine_prrovider.dart';

// import './add_medicines.dart';
import './add_screen.dart';

class MedicineScreen extends StatelessWidget {
  static const routeName = '/medicines';

  Future<void> _refreshMedicines(BuildContext context) async {
    await Provider.of<Medicines>(context, listen: false).fetchAndSetMeds();
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
      body: RefreshIndicator(
        onRefresh: () => _refreshMedicines(context),
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: medicineData.items.length,
              itemBuilder: (_, i) => Column(
                children: <Widget>[
                  Dismissible(
                    key: Key(medicineData.items[i].id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Theme.of(context).errorColor,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onDismissed: (direction) async {
                      await Provider.of<Medicines>(context, listen: false)
                          .deleteMeds(medicineData.items[i].id);
                    },
                    child: InkWell(
                      onTap: () => {
                        Navigator.of(context).pushNamed(
                            SingleMedicine.routeName,
                            arguments: medicineData.items[i])
                      },
                      child: Column(
                        children: <Widget>[
                          UserMedicines(
                            medicineData.items[i].id,
                            medicineData.items[i].icon,
                            medicineData.items[i].title,
                            medicineData.items[i].color,
                          ),
                          Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
