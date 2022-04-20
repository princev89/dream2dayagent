import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:startup/widgets/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetail extends StatefulWidget {
  final String documentId;
  final service;
  BookingDetail(this.documentId, this.service);

  @override
  _BookingDetailState createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  @override
  Widget build(BuildContext context) {
    CollectionReference bookings =
        FirebaseFirestore.instance.collection('bookings');

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: CustomAppBar(),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: bookings.doc(widget.documentId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            FirebaseAuth auth = FirebaseAuth.instance;
            // for (var item in data['requirments']) {
            //   if (item['item'] == widget.service &&
            //       item['agent_phone'] == auth.currentUser.phoneNumber)
            //     isaccepted = true;
            //   if (item['item'] == widget.service)
            //     requirments.add({
            //       'item': item['item'],
            //       'bookedto': auth.currentUser.displayName,
            //       'agent_phone': auth.currentUser.phoneNumber,
            //     });
            //   else
            //     requirments.add(item);
            // }

            return Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Owner: " + data['customer'],
                      style: GoogleFonts.lato(fontSize: 28),
                    ),
                    SizedBox(height: 10),
                    // Text(
                    //   "Location: " + data['city'],
                    //   style: GoogleFonts.lato(
                    //       fontSize: 28, fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(height: 10),
                    Text(
                      "Service: " + data['service'],
                      style: GoogleFonts.lato(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Service Date: " + data['serviceDate'],
                      style: GoogleFonts.lato(fontSize: 28),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    if (data['booked'] == false)
                      Center(
                        child: CupertinoButton(
                            color: Colors.green,
                            child: Text('Accept Request'),
                            onPressed: () async {
                              CollectionReference agents = FirebaseFirestore
                                  .instance
                                  .collection('agents');

                              bookings
                                  .doc(widget.documentId)
                                  .update({'booked': true})
                                  .then((value) => print("User Updated"))
                                  .catchError((error) =>
                                      print("Failed to update user: $error"));
                              // agents
                              //     .doc(auth.currentUser.uid)
                              //     .update({
                              //       'bookings': newBooking,
                              //     })
                              //     .then((value) => print("User Updated"))
                              //     .catchError((error) =>
                              //         print("Failed to update user: $error"));
                            }),
                      ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          IconButton(
                              color: Colors.green,
                              iconSize: 30,
                              onPressed: () =>
                                  launch("tel://${data['customer_phone']}"),
                              icon: Icon(Icons.call)),
                          Text('Call 1',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400))
                        ]),
                        // Column(children: [
                        //   IconButton(
                        //       color: Colors.green,
                        //       iconSize: 30,
                        //       onPressed: () =>
                        //           launch("tel://${data['secondary_phone']}"),
                        //       icon: Icon(Icons.call)),
                        //   Text('Call 2',
                        //       style: TextStyle(
                        //           fontSize: 20, fontWeight: FontWeight.w400))
                        // ])
                      ],
                    ),
                  ],
                ));
          }

          return Center(child: Text("Loading..."));
        },
      ),
    );
  }
}
