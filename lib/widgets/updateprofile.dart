import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup/main.dart';
import 'package:startup/widgets/loader.dart';
import '../configView.dart';

class UpdateProfile extends StatefulWidget {
  UpdateProfile({Key key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String name;
  Position _currentPosition;
  String address;
  String district;
  String shopName;
  String gstno;
  String description;
  String secondaryPhone;
  bool shopImageUploaded = false;
  bool verificationIdUploaded = false;
  File localshopImage;
  File localaadharImage;
  String shopImageUrl;
  String aadharImageUrl;

  bool showservices = false;
  List<String> tags = [];
  List<String> options = [];
  List<String> subserviceoptions = [];
  List<List<String>> allsubservice = [];
  List<String> subservicetitle = [];

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  @override
  // ignore: override_on_non_overriding_member

  Future getservices() async {
    await FirebaseFirestore.instance
        .collection('services')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['name']);
        setState(() {
          options.add(doc['name']);
        });
      });
    });
    print("Options are: " + options.toString());
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
          description = documentSnapshot.get('shop_description');
          gstno = documentSnapshot.get('gst_no');
          secondaryPhone = documentSnapshot.get('secondary_phone');

          for (var item in documentSnapshot.get('services')) {
            tags.add(item);
          }
        });
      }
    });
  }

  Future getSubService() async {
    print("Sub cat: ");
    await FirebaseFirestore.instance
        .collection('subservice')
        .get()
        .then((QuerySnapshot querySnapshot) {
      List<String> title = [];
      querySnapshot.docs.forEach((doc) {
        List<String> services = [];
        // print("Doc is  ${doc['name'][0]['name']}");
        title.add(doc.id.toString());

        for (var item in doc['name']) {
          services.add(item['name']);
        }
        setState(() {
          allsubservice.add(services);
        });

        // setState(() {
        //   subservices.add(Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       children: [
        //         Text(doc.id.toString()),
        //         Container(
        //           child: ChipsChoice<String>.multiple(
        //             value: tag,
        //             onChanged: (val) => setState(() => tag = val),
        //             choiceItems: C2Choice.listFrom<String, String>(
        //               source: chipTag,
        //               value: (i, v) => v,
        //               label: (i, v) => v,
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ));
        //     });
      });
      setState(() {
        subservicetitle = title;
      });
    });
    print("All title are: $subservicetitle");
    print("All title are: $allsubservice");

    // print("Options are: " + options.toString());
  }

  Future<void> uploadDoc(bool isaadhar) async {
    final picker = ImagePicker();
    final XFile image = await picker.pickImage(source: ImageSource.gallery);
    print(image.path);
    showLoaderDialog(context, 'Uploading Image');
    await uploadFile(image.path, isaadhar);
  }

  Future<void> uploadFile(String filePath, bool aadhar) async {
    File file = File(filePath);

    try {
      if (aadhar) {
        TaskSnapshot snapshot = await firebase_storage.FirebaseStorage.instance
            .ref('agentAadhar/${auth.currentUser.uid}.png')
            .putFile(file);

        if (snapshot.state == TaskState.success) {
          final String downloadUrl = await snapshot.ref.getDownloadURL();
          print(downloadUrl);
          setState(() {
            aadharImageUrl = downloadUrl;
            verificationIdUploaded = true;

            localaadharImage = File(filePath);
          });
          Navigator.of(context, rootNavigator: true).pop(context);
          // final snackBar =
          //     SnackBar(content: Text('Yay! Verification Uploaded'));
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        TaskSnapshot snapshot = await firebase_storage.FirebaseStorage.instance
            .ref('shopImage/${auth.currentUser.uid}.png')
            .putFile(file);
        if (snapshot.state == TaskState.success) {
          final String downloadUrl = await snapshot.ref.getDownloadURL();
          print(downloadUrl);
          setState(() {
            shopImageUrl = downloadUrl;
            shopImageUploaded = true;

            localshopImage = File(filePath);
          });
          Navigator.of(context, rootNavigator: true).pop(
              context); // final snackBar = SnackBar(content: Text('Yay! Success'));
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    } on firebase_core.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    getservices();
    getSubService();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(title: TextStyle(color: Colors.black)),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SizedBox()),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await preferences.clear();
                      setState(() {});
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    child: Icon(Icons.logout, size: 16)),
                Text('Logout', style: TextStyle(fontSize: 14)),
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: setProfile(),
        ),
      ),
    );
  }

  Widget setProfile() {
    List<bool> professionsSelected = List.filled(20, false);
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference agents =
        FirebaseFirestore.instance.collection('agents');
    updateaddress(x, y) async {
      final coordinates = new Coordinates(x, y);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      district = first.subAdminArea;
      address = first.addressLine;
      print(district);
    }

    // ignore: unused_element
    Future<void> getCurrentLocation() async {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        print(position);
        setState(() {
          _currentPosition = position;
          updateaddress(position.latitude, position.longitude);
        });
      }).catchError((e) {
        print(e);
      });
    }

    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop(context);
        },
      );
      Widget continueButton = FlatButton(
        color: Colors.green,
        child: Text("Ok"),
        onPressed: () {
          getCurrentLocation();
          setState(() {});
          Navigator.of(context, rootNavigator: true).pop(context);
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Location Premission"),
        content: Text(
            "Dream2Day Agent Want to access you location to help customers to locate you shops. Would you like to give permission ?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Name',
              style: heading,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.black12,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  validator: (value) =>
                      value.isEmpty ? 'Please enter your Name' : null,
                  onChanged: (value) {
                    name = value;
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: name ?? 'Your name'),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Shop Name',
              style: heading,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.black12,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  validator: (value) =>
                      value.isEmpty ? 'Enter Shop Name' : null,
                  onChanged: (value) {
                    shopName = value;
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: shopName ?? 'Shop Name'),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Shop Description',
              style: heading,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.black12,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  onChanged: (value) {
                    description = value;
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: description ?? 'Shop Description'),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'GST No.',
              style: heading,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.black12,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  onChanged: (value) {
                    gstno = value;
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: gstno ?? 'GST No.'),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Secondary Phone',
              style: heading,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.black12,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  validator: (value) {
                    if (value.length < 10) {
                      return 'Please enter valid phone number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    secondaryPhone = value;
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: secondaryPhone ?? 'Secondary Phone'),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              color: CupertinoColors.activeOrange,
              child: CupertinoButton(
                child: address != null
                    ? Text(
                        address + ", " + district,
                        style: secondaryText,
                      )
                    : Text(
                        'Update Location',
                        style: secondaryText,
                      ),
                onPressed: () {
                  showAlertDialog(context);
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            shopImageUploaded
                ? InkWell(
                    onTap: () {
                      uploadDoc(false);
                    },
                    child: Image.file(
                      localshopImage,
                      fit: BoxFit.contain,
                    ),
                  )
                : Center(
                    child: CupertinoButton(
                        color: Colors.green,
                        child: Text("Upload Shop Photo"),
                        onPressed: () {
                          uploadDoc(false);
                        }),
                  ),
            SizedBox(
              height: 10,
            ),
            verificationIdUploaded
                ? InkWell(
                    onTap: () {
                      uploadDoc(true);
                    },
                    child: Image.file(
                      localaadharImage,
                      fit: BoxFit.contain,
                    ),
                  )
                : Center(
                    child: CupertinoButton(
                        color: Colors.green,
                        child: Text("Upload Aadhar"),
                        onPressed: () {
                          uploadDoc(true);
                        }),
                  ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showservices ? showservices = false : showservices = true;
                });
              },
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "Show Services",
                  style: heading,
                ),
                Icon(
                    showservices
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                    size: 50)
              ]),
            ),
            for (int i = 0; i < subservicetitle.length; i++)
              Visibility(
                visible: showservices,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subservicetitle[i],
                        style: GoogleFonts.lato(fontSize: 22)),
                    ChipsChoice<String>.multiple(
                      value: tags,
                      onChanged: (val) => setState(() => tags = val),
                      choiceItems: C2Choice.listFrom<String, String>(
                        source: allsubservice[i],
                        value: (i, v) => v,
                        label: (i, v) => v,
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      choiceBuilder: (item) {
                        return Center(
                          child: CustomChip(
                              label: item.label,
                              width: double.infinity,
                              height: 40,
                              color: Colors.green,
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              selected: item.selected,
                              onSelect: item.select),
                        );
                      },
                      direction: Axis.vertical,
                    )
                  ],
                ),
              ),
            Visibility(
                visible: showservices, child: Text('Random: ', style: heading)),
            Visibility(
              visible: showservices,
              child: ChipsChoice<String>.multiple(
                value: tags,
                onChanged: (val) => setState(() => tags = val),
                choiceItems: C2Choice.listFrom<String, String>(
                  source: options,
                  value: (i, v) => v,
                  label: (i, v) => v,
                ),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                choiceBuilder: (item) {
                  return Center(
                    child: CustomChip(
                        label: item.label,
                        width: double.infinity,
                        height: 40,
                        color: Colors.green,
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        selected: item.selected,
                        onSelect: item.select),
                  );
                },
                direction: Axis.vertical,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: CupertinoButton(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: primaryBlue,
                  child: Text('Update'),
                  onPressed: () async {
                    if (_currentPosition == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Update Location"),
                      ));
                    }
                    // if (_formKey.currentState.validate() &&
                    //     _currentPosition != null) {
                    //   showLoaderDialog(context, 'Updating Profile');

                    auth.currentUser.updateDisplayName(name);
                    if (auth.currentUser.displayName != null) {
                      await agents
                          .doc(auth.currentUser.uid)
                          .set(
                            {
                              'full_name': name,
                              'services': tags,
                              'shop_name': shopName,
                              'gst_no': gstno,
                              'shop_description': description,
                              'secondary_phone': secondaryPhone,
                              'district': district,
                              'address': address,
                              'shop_image': shopImageUrl,
                              'verification': aadharImageUrl,
                              'cordinates':
                                  _currentPosition.latitude.toString() +
                                      ", " +
                                      _currentPosition.longitude.toString(),
                            },
                            SetOptions(merge: true),
                          )
                          .then((value) => {
                                Navigator.pushReplacementNamed(context, "/home")
                              })
                          .catchError((error) {
                            print(error);
                          });
                    } else {
                      await agents
                          .doc(auth.currentUser.uid)
                          .set(
                            {
                              'full_name': name,
                              'services': tags,
                              'shop_name': shopName,
                              'gst_no': gstno,
                              'shop_description': description,
                              'secondary_phone': secondaryPhone,
                              'district': district,
                              'address': address,
                              'shop_image': null,
                              'verification': null,
                              'bookings': [
                                // {
                                //   'date': DateTime.now(),
                                //   'booking_id': 1323,
                                //   'status': 'upcomming'
                                // }
                              ],
                              'cordinates': null,
                            },
                            SetOptions(merge: true),
                          )
                          .then((value) => {
                                Navigator.pushReplacementNamed(context, "/home")
                              })
                          .catchError((error) {
                            print(error);
                          });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final String label;
  final Color color;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final bool selected;
  final Function(bool selected) onSelect;

  CustomChip({
    Key key,
    this.label,
    this.color,
    this.width,
    this.height,
    this.margin,
    this.selected,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: this.width,
      height: this.height,
      margin: margin ??
          const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 5,
          ),
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: selected ? (color ?? Colors.green) : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(selected ? 25 : 10)),
        border: Border.all(
          color: selected ? (color ?? Colors.green) : Colors.grey,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => onSelect(!selected),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Visibility(
                visible: selected,
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 32,
                )),
            Positioned(
              left: 9,
              right: 9,
              bottom: 7,
              child: Container(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    color: selected ? Colors.white : Colors.black45,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
