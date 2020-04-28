import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/User.dart';
import '../widgets/buildCard_widget.dart';
import '../model/auth.dart';

class AddUserDetails extends StatefulWidget {
  static const routeName = '/addUserDetails';

  @override
  _AddUserDetailsState createState() => _AddUserDetailsState();
}

class _AddUserDetailsState extends State<AddUserDetails> {
  String _selectedGender = 'Male';
  List genders = ['Male', 'Female', 'Others'];
  final form = GlobalKey<FormState>();
  bool _isLoading = false;
  bool inIt = true;

  var _editedData = User(
    id: null,
    name: '',
    email: '',
    phone: '',
    age: '',
    gender: '',
    condition: '',
  );

  Future<void> _save(BuildContext context) async {
    final isValid = form.currentState.validate();
    if (!isValid) {
      return;
    }
    _editedData = User(
      id: _editedData.id,
      age: _editedData.age,
      condition: _editedData.condition,
      email: _editedData.email,
      gender: _selectedGender,
      name: _editedData.name,
      phone: _editedData.phone,
    );
    print(_editedData.phone);
    form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_editedData.id != null) {
        await Provider.of<Auth>(context, listen: false)
            .updateUserInfo(_editedData.id, _editedData);
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) =>
            alert(context, 'An Error Occurred', 'Please try again!'),
      );
    }
    // finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Navigator.of(context).pop();
    // }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (inIt) {
      final userId = ModalRoute.of(context).settings.arguments as int;
      if (userId != null) {
        _editedData =
            Provider.of<Auth>(context, listen: false).findById(userId);
      }
    }
    inIt = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Card(
                  shape: StadiumBorder(),
                  color: Theme.of(context).primaryColor,
                  elevation: 10,
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.cancel),
                          color: Theme.of(context).errorColor,
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        Text(
                          'Add Your Details',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        // SizedBox(
                        //   width: 70,
                        // ),
                        IconButton(
                            icon: Icon(Icons.check, color: Colors.white),
                            onPressed: () => _save(context)),
                      ],
                    ),
                  ),
                ),
                Container(
                    child: Form(
                  key: form,
                  child: Column(
                    children: <Widget>[
                      buildCard(
                        child: Column(
                          children: <Widget>[
                            buildForm(
                                _editedData.name,
                                'Full Name',
                                'Please enter your Name',
                                TextInputType.text,
                                (value) => {
                                      _editedData = User(
                                        id: _editedData.id,
                                        age: _editedData.age,
                                        condition: _editedData.condition,
                                        email: _editedData.email,
                                        gender: _editedData.gender,
                                        name: value,
                                        phone: _editedData.phone,
                                      )
                                    }),
                            buildForm(
                                _editedData.email,
                                'Email',
                                'Please enter your email',
                                TextInputType.emailAddress,
                                (value) => {
                                      _editedData = User(
                                        id: _editedData.id,
                                        age: _editedData.age,
                                        condition: _editedData.condition,
                                        email: value,
                                        gender: _editedData.gender,
                                        name: _editedData.name,
                                        phone: _editedData.phone,
                                      )
                                    }),
                            buildForm(
                                _editedData.phone,
                                'Phone',
                                'Please enter your Phone',
                                TextInputType.phone,
                                (value) => {
                                      _editedData = User(
                                        id: _editedData.id,
                                        age: _editedData.age,
                                        condition: _editedData.condition,
                                        email: _editedData.email,
                                        gender: _editedData.gender,
                                        name: _editedData.name,
                                        phone: value.toString(),
                                      )
                                    }),
                          ],
                        ),
                      ),
                      buildCard(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 120,
                                  child: buildForm(
                                      _editedData.age.toString(),
                                      'Age',
                                      'Please enter your Age.',
                                      TextInputType.number,
                                      (value) => {
                                            _editedData = User(
                                              id: _editedData.id,
                                              age: value,
                                              condition: _editedData.condition,
                                              email: _editedData.email,
                                              gender: _editedData.gender,
                                              name: _editedData.name,
                                              phone: _editedData.phone,
                                            )
                                          }),
                                ),
                                Container(
                                  width: 180,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Gender:',
                                        style: textStyle(),
                                      ),
                                      dropDown(
                                        genders,
                                        Theme.of(context).primaryColor,
                                        _selectedGender,
                                        (String newValue) {
                                          setState(() {
                                            this._selectedGender = newValue;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      buildCard(
                        child: Column(
                          children: <Widget>[
                            buildForm(
                                _editedData.condition,
                                'Medical Conditions (if any)',
                                '',
                                TextInputType.multiline, (value) {
                              _editedData = User(
                                id: _editedData.id,
                                age: _editedData.age,
                                condition: value,
                                email: _editedData.email,
                                gender: _editedData.gender,
                                name: _editedData.name,
                                phone: _editedData.phone,
                              );
                            })
                          ],
                        ),
                      ),
                      FlatButton(
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                        onPressed: () => _save(context),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
