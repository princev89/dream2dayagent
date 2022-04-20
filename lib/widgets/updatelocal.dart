import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup/pages/home.dart';
import 'package:startup/widgets/loader.dart';

class UpdateLocal extends StatefulWidget {
  UpdateLocal({Key key}) : super(key: key);

  @override
  _UpdateLocalState createState() => _UpdateLocalState();
}

class _UpdateLocalState extends State<UpdateLocal> {
  String cityValue;
  String countryValue = 'India';
  String stateValue;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference agents =
        FirebaseFirestore.instance.collection('agents');

    Future<void> updateLocation(disctrict) {
      return agents
          .doc(auth.currentUser.uid)
          .update({'city': disctrict})
          .then((value) => print("City Updated"))
          .catchError((error) => print("Failed to update City: $error"));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('I want my bookings in',
              style:
                  GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w400)),
        ),
        Image.asset('assets/map_location.png'),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CSCPicker(
                  defaultCountry: DefaultCountry.India,
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                ),
              ],
            )),
        Expanded(child: SizedBox()),
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: CupertinoButton(
              color: Colors.orange,
              child: Text('Update'),
              onPressed: () async {
                showLoaderDialog(context, 'Upading Location');
                print(cityValue);
                await updateLocation(cityValue);

                SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  prefs.setString('city', cityValue);
                });

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ));
              }),
        )
      ],
    );
  }
}
