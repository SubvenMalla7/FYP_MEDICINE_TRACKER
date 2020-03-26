// import 'package:flutter/material.dart';


// import '../screens/dashboard_screen.dart';
// import './form_widget.dart';



// class LoginFields extends StatelessWidget {
//   final TextEditingController emailController;
//   final TextEditingController passwordController;
//   final Color color;


//   LoginFields({
//     @required this.emailController,
//     @required this.passwordController,
//     @required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         SizedBox(
//           height: 190,
//         ),
//         Align(
//           alignment: Alignment(-0.80, 1),
//           child: Text(
//             'Login',
//             style: TextStyle(
//                 fontSize: 50,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.orangeAccent),
//           ),
//         ),
//         Align(
//           alignment: Alignment(-0.80, 1),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Please Login to continue',
//               style: TextStyle(fontSize: 15, color: Colors.black54),
//             ),
//           ),
//         ),
//         SizedBox(
//           height:50,
//         ),
//         Card(
//           elevation: 5,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               child: Column(
//                 children: <Widget>[
                 
//                   ///// for email id field\\\\\
//                   buildTextField(
//                       ctr: emailController,
//                       icon: Icon(Icons.email),
//                       label: 'Email',
//                       type: TextInputType.emailAddress),
//                   ////// for password field\\\\\\

//                   buildTextField(
//                       ctr: passwordController,
//                       icon: Icon(Icons.lock),
//                       label: 'Password',
//                       type: TextInputType.text,
//                       ob: true),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: FlatButton(
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                             top: 8, bottom: 8, left: 10, right: 10),
//                         child: const Text(
//                           'Login ',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20.0,
//                             decoration: TextDecoration.none,
//                             fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                       ),
//                       color: color,
//                       disabledColor: Colors.grey,
//                       shape: new RoundedRectangleBorder(
//                         borderRadius: new BorderRadius.circular(20.0),
//                       ),
//                       onPressed: () {
//                         Navigator.pushNamed(context,DashBoardScreen.routeName);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
