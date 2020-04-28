import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/buildCard_widget.dart';

import '../screens/addUserDetails.dart';

import '../model/auth.dart';

class UserProfile extends StatefulWidget {
  static const routeName = '/userprofile';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void didChangeDependencies() {
    Provider.of<Auth>(context).fetchUserData();
    final user = Provider.of<Auth>(context);
    print("hekko");
    print(user.userData.length);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).pushNamed(
                AddUserDetails.routeName,
                arguments: int.parse(userData.userId)),
          )
        ],
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
                              fieldInfo: userData.name == null
                                  ? 'Not Specified'
                                  : userData.name,
                            ),
                          ),
                          MainTabInfo(
                            fieldTitle: "Email",
                            fieldInfo: userData.email == null
                                ? 'Not Specified'
                                : userData.email,
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
                          fieldTitle: "Gender",
                          fieldInfo: userData.gender == null
                              ? 'Not Specified'
                              : userData.gender,
                        ),
                        SizedBox(
                          width: 90,
                        ),
                        ExtendedInfoTab(
                          fieldTitle: "Age ",
                          fieldInfo: userData.age == null
                              ? 'Not Specified'
                              : userData.age,
                        )
                        // medicine.date.toString()),
                      ],
                    ),
                    ExtendedInfoTab(
                      fieldTitle: 'Medical Conditions:',
                      fieldInfo: userData.condition == null
                          ? 'Not Specified'
                          : userData.condition,
                    )
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
              ),
              IconButton(
                highlightColor: Theme.of(context).accentColor,
                splashColor: Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => deleteDialog(
                      context,
                      "Are You sure you want to delete account? ?",
                      () async {
                        try {
                          await Provider.of<Auth>(context, listen: false)
                              .deleteuser(int.parse(userData.userId));
                          Navigator.of(context).pushReplacementNamed('/');
                        } catch (error) {
                          print('This is an eror $error');
                        }
                      },
                    ),
                  );
                },
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
      width: MediaQuery.of(context).size.width * 0.40,
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
                fontSize: 20,
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
