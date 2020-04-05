import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../model/auth.dart';

class UserProfile extends StatelessWidget {
  static const routeName = '/userprofile';
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.black87,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Column(
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: MainTabInfo(
                              fieldTitle: "Full Name",
                              fieldInfo: userData.name,
                            ),
                          ),
                          MainTabInfo(
                            fieldTitle: "Email",
                            fieldInfo: "Not Specified",
                            //  medicine.amount == 0
                            //     ? "Not Specified"
                            //     : medicine.amount.toString() + " mg",
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ExtendedInfoTab(
                          fieldTitle: "Body Weight",
                          fieldInfo: "Not Specified",
                          //  medicine.type.length == 0
                          //     ? "No Type"
                          //     : medicine.type,
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        ExtendedInfoTab(
                          fieldTitle: "Height ",
                          fieldInfo: "Not Specified",
                          // medicine.instruction.length == 0
                          //     ? "No instruction"
                          //     : medicine.instruction,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        ExtendedInfoTab(
                          fieldTitle: "Gender",
                          fieldInfo: "Not Specified",
                          // medicine.time,
                        ),
                        SizedBox(
                          width: 90,
                        ),
                        ExtendedInfoTab(
                          fieldTitle: "Age ",
                          fieldInfo: "Not Specified",
                        )
                        // medicine.date.toString()),
                      ],
                    ),
                    ExtendedInfoTab(
                      fieldTitle: "Sex",
                      fieldInfo: "Not Specified",
                      // medicine.amount.toString(),
                    ),
                    // ExtendedInfoTab(
                    //   fieldTitle: "Notes",
                    //   fieldInfo: medicine.note.length == 0
                    //       ? 'No Notes'
                    //       : medicine.note,
                    // ),
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 5,
              ),
              //ExtendedSection(medicine: medicine),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.08,
                  right: MediaQuery.of(context).size.height * 0.06,
                  top: 25,
                ),
                child: Container(
                  width: 200,
                  height: 70,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainTabInfo extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  MainTabInfo({this.fieldTitle, this.fieldInfo});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 100,
      child: ListView(
        padding: EdgeInsets.only(top: 15),
        shrinkWrap: true,
        children: <Widget>[
          Text(
            fieldTitle,
            style: TextStyle(
                fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            fieldInfo,
            style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  ExtendedInfoTab({@required this.fieldTitle, @required this.fieldInfo});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                fieldTitle,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              fieldInfo,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
