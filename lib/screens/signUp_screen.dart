import 'package:flutter/material.dart';

import '../screens/dashboard_screen.dart';
import '../widgets/form_widget.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final color = Colors.amberAccent[700];
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/image/Medicine.jpg"),
            fit: BoxFit.fill,
          )),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 190,
                    ),
                    Align(
                      alignment: Alignment(-0.80, 1),
                      child: Text(
                        'Create a account',
                        style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 230,
                                padding: EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      ///// first name field\\\\\
                                      buildTextField(
                                          ctr: fNameController,
                                          type: TextInputType.text,
                                          icon: Icon(Icons.account_box),
                                          label: 'First Name'),

                                      /////  last name field\\\\\
                                      buildTextField(
                                          ctr: lNameController,
                                          type: TextInputType.text,
                                          icon: Icon(Icons.account_box),
                                          label: 'Last Name'),

                                      ///// for email id field\\\\\
                                      buildTextField(
                                          ctr: emailController,
                                          type: TextInputType.emailAddress,
                                          icon: Icon(Icons.email),
                                          label: 'Email Id'),

                                      ////// phone field \\\\\
                                      buildTextField(
                                          ctr: phoneController,
                                          type: TextInputType.phone,
                                          icon: Icon(Icons.phone),
                                          label: 'Phone'),

                                      ////// for password field\\\\\\
                                      buildTextField(
                                          ctr: passwordController,
                                          type: TextInputType.text,
                                          icon: Icon(Icons.lock),
                                          label: 'Password',
                                          ob: true),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FlatButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _loading ? 'Signing up....' : 'Sign Up ',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  color: color,
                                  disabledColor: Colors.grey,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, DashBoardScreen.routeName);
                                  },
                                  //_loading ? null : _handleSignup(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 90.0),
                  child: Row(
                    children: <Widget>[
                      Text("Already have an account?"),
                      FlatButton(
                        textColor: Colors.amber[700],
                        child: Text("Sign In"),
                        onPressed: () {
                          //print(emailController);
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _handleSignup() async {
  //   setState(() {
  //     _loading = true;
  //   });

  //   var data = {
  //     'firstname': fNameController.text,
  //     'lastname': lNameController.text,
  //     'email': emailController.text,
  //     'password': passwordController.text,
  //     'phone': phoneController.text,
  //   };

  // var resp = await Api().postData(data, 'register');
  // var body = json.decode(resp.body);
  // print(fNameController.text);
  // print(emailController.text);
  // print(body);

  // Navigator.push(
  //     context, new MaterialPageRoute(builder: (context) => Dashboard()));
  //}
}
