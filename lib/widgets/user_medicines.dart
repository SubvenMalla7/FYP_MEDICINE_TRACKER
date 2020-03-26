import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_screen.dart';
import '../model/medicine_prrovider.dart';

class UserMedicines extends StatelessWidget {
  final String id;
  final String title;
  final Icon icons;

  UserMedicines(
    this.id,
    this.icons,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icons,
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AddScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          elevation: 10,
                          title: Text('Are you sure?'),
                          content: Text(
                            'Do you want to delete $title?',
                            style: TextStyle(fontSize: 18),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () async {
                                try {
                                  await Provider.of<Medicines>(context,
                                          listen: false)
                                      .deleteMeds(id);
                                  Navigator.of(context).pop();
                                } catch (error) {
                                  print('This is an eror $error');
                                }
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'No',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
