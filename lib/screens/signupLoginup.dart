import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/auth.dart';
import '../model/http_exception.dart';
import '../widgets/buildCard_widget.dart';

enum AuthMode { Signup, Login }

class EmailValidator {
  static String validate(String value) {
    return value.isEmpty
        ? 'Email cannot be empty'
        : !value.contains('@') ? 'Email Should contain @' : null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    return value.isEmpty
        ? 'Password cannot be empty'
        : value.length < 5 ? 'Password is too short!' : null;
  }
}

class LoginSign extends StatefulWidget {
  @override
  _LoginSignState createState() => _LoginSignState();
}

class _LoginSignState extends State<LoginSign>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Size> _heigtAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 400,
        ));
    _heigtAnimation = Tween<Size>(
      begin: Size(double.infinity, 200),
      end: Size(double.infinity, 270),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _launchURL() async {
    const url = 'http://192.168.0.103:8000/password/reset';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showErrorDialog(String messsage) {
    showDialog(
        context: context,
        builder: (ctx) =>
            alert(context, 'Please Check your in input', messsage));
  }

  Future<void> submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
        //Navigator.of(context).pushNamed(TabsScreen.routeName);
      } else {
        // Sign user up

        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authantication Failed';
      if (error.toString().contains('The email has already been taken.')) {
        errorMessage = 'The email has already been taken.';
      } else if (error.toString().contains('User does not exist')) {
        errorMessage = 'User does not exist';
      } else if (error.toString().contains('Password missmatch')) {
        errorMessage = 'Password missmatch or Invalid Password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try Again!';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: _screenSize.height,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/image/Medicine.png"),
          fit: BoxFit.fill,
        )),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: _screenSize.height * 0.19,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${_authMode == AuthMode.Login ? 'Login' : 'Create Account'}',
                            style: TextStyle(
                                fontSize: 45,
                                fontWeight: FontWeight.w900,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${_authMode == AuthMode.Login ? 'Please sign in to continue.' : 'Please sign up to continue.'}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _screenSize.height * 0.03,
                  ),
                  Container(
                    child: authCard(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget authCard(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 10.0,
          child: AnimatedBuilder(
            animation: _heigtAnimation,
            builder: (ctx, ch) => Container(
              // height: _authMode == AuthMode.Signup ? 280 : 180,
              height: _heigtAnimation.value.height,
              constraints:
                  BoxConstraints(minHeight: _heigtAnimation.value.height),
              width: deviceSize.width * 0.80,
              padding: EdgeInsets.all(16.0),
              child: ch,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      key: Key('email'),
                      decoration: InputDecoration(
                          labelText: 'E-Mail', icon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,
                      validator: EmailValidator.validate,
                      onSaved: (value) {
                        _authData['email'] = value;
                      },
                    ),
                    TextFormField(
                      key: Key('password'),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      controller: _passwordController,
                      validator: PasswordValidator.validate,
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                    if (_authMode == AuthMode.Signup)
                      TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            icon: Icon(Icons.lock)),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                return value != _passwordController.text
                                    ? 'Passwords do not match!'
                                    : null;
                              }
                            : null,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: deviceSize.height * 0.03,
        ),
        if (_isLoading)
          CircularProgressIndicator()
        else
          Padding(
            padding: const EdgeInsets.only(left: 150.0),
            child: RaisedButton(
              key: _authMode == AuthMode.Login ? Key('login') : Key('signin'),
              elevation: 8,
              child: Container(
                alignment: Alignment.center,
                height: deviceSize.height * 0.05,
                width: deviceSize.width * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              onPressed: submit,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
              color: Colors.orange.withOpacity(0.7),
              textColor: Theme.of(context).primaryTextTheme.button.color,
            ),
          ),
        SizedBox(
          height: _authMode == AuthMode.Signup ? deviceSize.height * 0.15 : 50,
        ),
        _authMode == AuthMode.Login
            ? InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
                  child: Text(
                    '${_authMode == AuthMode.Login ? 'Forgot Password' : ''} ',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                onTap: _launchURL,
              )
            : SizedBox(
                height: deviceSize.height * 0,
              ),
        FlatButton(
          child: Text(
              '${_authMode == AuthMode.Login ? "Don't have an account? SIGN UP" : 'Already have an account? LOGIN'} '),
          onPressed: _switchAuthMode,
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textColor: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
