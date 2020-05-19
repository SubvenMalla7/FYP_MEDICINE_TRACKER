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
  void didChangeDependencies() {
    Provider.of<Auth>(context).fetchUserData();
    Provider.of<Auth>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context);
    final screenSize = MediaQuery.of(context).size;
    print(userData.phone);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 30,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => deleteDialog(
                                context,
                                "Are You sure you want to delete account? ?",
                                () async {
                                  try {
                                    await Provider.of<Auth>(context,
                                            listen: false)
                                        .deleteuser(int.parse(userData.userId));
                                    Navigator.of(context)
                                        .pushReplacementNamed('/');
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
                  SizedBox(
                    height: screenSize.height * 0.183,
                  ),
                  Container(
                    height: screenSize.height * 0.67,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(80),
                            topRight: Radius.circular(80))),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 300, top: 10),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 30,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () => Navigator.of(context).pushNamed(
                                AddUserDetails.routeName,
                                arguments: int.parse(userData.userId)),
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.03,
                        ),
                        Text(
                          userData.name,
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userData.email,
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
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
                                    width: 160,
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
                                fieldTitle: 'Phone NO.',
                                fieldInfo: userData.phone == null
                                    ? 'Not Specified'
                                    : userData.phone,
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 40),
                          alignment: Alignment.centerLeft,
                          child: ExtendedInfoTab(
                            fieldTitle: 'Medical Conditions:',
                            fieldInfo: userData.condition == null
                                ? 'Not Specified'
                                : userData.condition,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 150,
              left: 130,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Hero(
                      tag: userData.userId,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
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
