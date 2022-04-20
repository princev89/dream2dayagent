// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:startup/configView.dart';

// class SetProfile extends StatefulWidget {
//   SetProfile({Key key}) : super(key: key);

//   @override
//   _SetProfileState createState() => _SetProfileState();
// }

// class _SetProfileState extends State<SetProfile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: mainColor,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: mainColor,
//           title: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Set Profile',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 Text(
//                   'Skip',
//                   style: TextStyle(
//                       color: CupertinoColors.secondaryLabel, fontSize: 16),
//                 )
//               ],
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Select Language',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 Row(
//                   children: [
//                     Chip(
//                       title: 'English',
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Chip(
//                       title: 'Hindi',
//                     ),
//                   ],
//                 ),
//                 Divider(),
//                 Text(
//                   'Profession',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ]),
//         ));
//   }
// }
