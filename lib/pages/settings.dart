// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:startup/configView.dart';
// import 'package:startup/pages/createAccount.dart';
// import 'package:startup/widgets/updateprofile.dart';

// class UpdateSetting extends StatelessWidget {
//   const UpdateSetting({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'Update Setting',
//             style: TextStyle(color: Colors.black),
//           ),
//           backgroundColor: isDarkMode ? darkMode : mainColor,
//           elevation: 0,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               // ToggleButtons(children: Te, isSelected: isSelected)
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => UpdateProfile()));
//                 },
//                 child: Text(
//                   'Update Profile',
//                 ),
//               ),
//               CupertinoButton(
//                   child: Text('Logout'),
//                   onPressed: () async {
//                     await auth.signOut();
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => CreateAccount()));
//                   })
//             ],
//           ),
//         ));
//   }
// }
