// import 'package:flutter/material.dart';

// import '../screens/signUp_screen.dart';
// import '../widgets/login_field.dart';

// class LoginScreen extends StatefulWidget {
//   static const routeName = '/login';
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   final color = Colors.amberAccent[700];
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/image/Medicine.jpg"),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(8),
//             child: Column(
//               children: <Widget>[
//                 LoginFields(
//                   emailController: _emailController,
//                   passwordController: _passwordController,
//                   color: color,
//                 ),
//                 SizedBox(
//                   height: 120,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 90.0),
//                   child: Row(
//                     children: <Widget>[
//                       Text("Don't have an account?"),
//                       FlatButton(
//                         textColor: Colors.amber[700],
//                         child: Text("Sign Up"),
//                         onPressed: () {
//                           Navigator.pushNamed(context, SignUp.routeName);
//                         },
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
