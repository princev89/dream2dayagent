import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:startup/widgets/updatelocal.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchInArea extends StatefulWidget {
  final city;
  SearchInArea({Key key, this.city}) : super(key: key);

  @override
  _SearchInAreaState createState() => _SearchInAreaState();
}

class _SearchInAreaState extends State<SearchInArea> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('bookings')
        .where('city', isEqualTo: widget.city)
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Row(
            children: [
              Text(
                'Location: ${widget.city}',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          )),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }
          if (snapshot.data.docs.isEmpty) {
            return Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                                body: SafeArea(
                                  child: UpdateLocal(),
                                ),
                              )));
                },
                child: Column(
                  children: [
                    Image.asset('assets/map_location.png'),
                    Text('Currenty No Order in ${widget.city}',
                        style: GoogleFonts.lato(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22))
                  ],
                ),
              ),
            );
          }
          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              List<String> requirments = [];
              for (var item in data['requirments']) {
                if (item['booked_to'] == null) {
                  requirments.add(item['item']);
                }
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.teal[600],
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(3, 3),
                          blurRadius: 12,
                          color: Color.fromRGBO(0, 0, 0, 0.30),
                        )
                      ]),
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Text(data['postby'],
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            IconButton(
                                onPressed: () =>
                                    launch("tel://${data['user_phone']}"),
                                icon: Icon(Icons.call, color: Colors.white60))
                          ],
                        ),
                        subtitle: Text(data['booking_date'],
                            style: GoogleFonts.lato(
                                color: CupertinoColors.secondaryLabel,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(requirments[index],
                                            style: GoogleFonts.lato(
                                                color: CupertinoColors
                                                    .secondaryLabel,
                                                fontWeight: FontWeight.bold))),
                                  )),
                            );
                          },
                          itemCount: requirments.length,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
