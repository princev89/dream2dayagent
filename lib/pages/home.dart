import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup/configView.dart';
import 'package:startup/pages/workArea.dart';
import 'package:geocoder/geocoder.dart';
import 'package:startup/widgets/appbar.dart';
import 'package:startup/widgets/loader.dart';
import 'package:startup/widgets/updatelocal.dart';
import 'package:startup/widgets/updateprofile.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

/// This is the private State class that goes with Home.
class _HomeState extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String city;
  String name;
  String shopName;
  String shopDescription;
  String gstno;
  List<dynamic> bookings;
  String countryValue;
  String stateValue;
  String cityValue;
  String shopImage;
  @override
  // ignore: override_on_non_overriding_member
  // Future<void> getCurrentLocation() async {
  //   Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((Position position) {
  //     print(position);
  //     setState(() {
  //       updateCity(position.latitude, position.longitude);
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  // updateCity(x, y) async {
  //   final coordinates = new Coordinates(x, y);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = addresses.first;
  //   print("${first.addressLine}");
  //   setState(() {
  //     city = first.addressLine;
  //     city = first.subAdminArea;
  //   });
  // }

  iscity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      city = prefs.getString('city');
    });
  }

  getUserInfo() async {
    await FirebaseFirestore.instance
        .collection('agents')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        print('Document data: ${documentSnapshot.data()}');
        setState(() {
          // city = documentSnapshot.get('district');
          name = documentSnapshot.get('full_name');
          shopName = documentSnapshot.get('shop_name');
          shopDescription = documentSnapshot.get('shop_description');
          gstno = documentSnapshot.get('gst_no');
          bookings = documentSnapshot.get('bookings');
          shopImage = documentSnapshot.get('shop_image');
          print("Bookings are: " + bookings.toString());
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    iscity();

    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) async {
        int sensitivity = 8;
        if (details.delta.dy > sensitivity) {
          // Down Swipe
          print("Swipe Down");
          showLoaderDialog(context, 'Loading');

          await getUserInfo();
          setState(() {});
          Navigator.pop(context);
        }
      },
      child: Scaffold(
          backgroundColor: isDarkMode ? darkMode : mainColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 1,
            title: CustomAppBar(),
          ),
          body:
              // city != null
              //     ? name != null
              // ?
              WorkArea(
                  shopImage: shopImage,
                  shopName: shopName,
                  ownerName: name,
                  description: shopDescription,
                  gstno: gstno,
                  city: city,
                  bookings: bookings)
          //     : UpdateProfile()
          // : UpdateLocal(),
          // body: Column(children: [],
          ),
    );
  }
}
