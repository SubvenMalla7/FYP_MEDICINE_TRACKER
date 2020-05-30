import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/buildCard_widget.dart';
import '../screens/medcineScreen.dart';
import '../widgets/user_medicines.dart';
import '../model/medicine_prrovider.dart';
// import './add_medicines.dart';
import '../widgets/app_drawer.dart';
import './add_screen.dart';

class MedicineScreen extends StatelessWidget {
  static const routeName = '/medicines';

  @override
  Widget build(BuildContext context) {
    final medicineData = Provider.of<Medicines>(context);
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
      child: Scaffold(
          drawer: AppDrawer(),
          floatingActionButton: FloatingActionButton(
            key: Key('addMedicine'),
            child: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddScreen.routeName),
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                forceElevated: true,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(120),
                        bottomRight: Radius.circular(120))),
                expandedHeight: screenSize.height * 0.35,
                pinned: true,
                elevation: 0,
                backgroundColor: Theme.of(context).primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Medicines',
                    style: textStyle(Colors.white),
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AddScreen.routeName),
                    ),
                  )
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => Column(
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
                            Navigator.of(context).push(
                              PageRouteBuilder<Null>(
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return AnimatedBuilder(
                                      animation: animation,
                                      builder:
                                          (BuildContext context, Widget child) {
                                        return Opacity(
                                          opacity: animation.value,
                                          child: SingleMedicine(
                                            medicine: medicineData.items[i],
                                          ),
                                        );
                                      });
                                },
                                transitionDuration: Duration(milliseconds: 600),
                              ),
                            )
                          },
                          child: Column(
                            children: <Widget>[
                              Hero(
                                tag: medicineData.items[i].id,
                                child: UserMedicines(
                                  medicineData.items[i].id,
                                  medicineData.items[i].icon,
                                  medicineData.items[i].title,
                                  medicineData.items[i].color,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  childCount: medicineData.items.length,
                ),
              )
            ],
          )),
    );
  }
}
