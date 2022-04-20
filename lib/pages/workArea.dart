import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:startup/pages/bookingdetail.dart';
import 'package:startup/pages/serachinArea.dart';
import 'package:startup/widgets/updatelocal.dart';

class WorkArea extends StatefulWidget {
  final shopName;
  final gstno;
  final description;
  final ownerName;
  final city;
  final shopImage;
  final List<dynamic> bookings;

  const WorkArea({
    Key key,
    this.ownerName,
    this.description,
    this.gstno,
    this.city,
    this.shopName,
    this.bookings,
    this.shopImage,
  }) : super(key: key);

  @override
  _WorkAreaState createState() => _WorkAreaState();
}

class _WorkAreaState extends State<WorkArea> {
  @override
  Widget build(BuildContext context) {
    // final todayDate = DateTime.now();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  // BoxShadow(
                  //   color: Colors.grey,
                  //   blurRadius: 6.0,
                  // ),
                ],
                // image: DecorationImage(
                //     alignment: Alignment.topRight,
                //     scale: 10,
                //     image: AssetImage('assets/background.png')),
                color: Colors.white,
                // gradient: LinearGradient(
                //   colors: [
                //     const Color(0xFFd76d77),
                //     const Color(0xFFffaf7b),
                //   ],
                //   begin: const FractionalOffset(0.0, 0.0),
                //   end: const FractionalOffset(1.0, 0.0),
                //   stops: [0.0, 1.0],
                //   tileMode: TileMode.clamp,
                // ),
              ),
              margin: EdgeInsets.all(2),
              // height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.shopName ?? "Shop Name ".toUpperCase(),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: widget.shopImage == null
                              ? Image.asset(
                                  'assets/background.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.shopImage,
                                  fit: BoxFit.cover,
                                ),
                        )),
                    Text(
                      widget.gstno ??
                          "* * * * * * * *"
                                  .toUpperCase()
                                  .toString()
                                  .substring(0, 5) +
                              " * * * *",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: CupertinoColors.secondaryLabel),
                    ),
                    Text(
                      widget.description ??
                          "On my as he but i pallas upon, rapping utters sad on the here, with faster distinctly just this vainly. The my word wandering gently betook devil on perched name. Floor visiter unhappy chamber and each midnight. The wished that there i grew lenore nothing. Faster his into one just me other this. But still sitting chamber doubting eagerly stepped one raven. Lamplight beguiling that bust the at. Nevernevermore fowl."
                                  .toString()
                                  .substring(0, 200) +
                              "....",
                      style: TextStyle(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ower Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        Text(
                          widget.ownerName ?? "Ower Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 1.5,
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => widget.city != null
                            ? SearchInArea(
                                city: widget.city,
                              )
                            : Scaffold(
                                body: SafeArea(
                                child: UpdateLocal(),
                              ))));
              },
              child: Container(
                color: Color(0xff334756),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                            widget.city != null
                                ? 'Search Customer in ${widget.city}'
                                : 'Update City to Get Bookings',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        Icon(CupertinoIcons.arrow_right,
                            color: Colors.white, size: 30)
                      ]),
                ),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Bookings',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                // Text('View All',
                //     style: GoogleFonts.poppins(
                //         fontSize: 14,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.lightBlue))
              ],
            ),
            SizedBox(height: 10),
            widget.bookings != null && widget.bookings.length != 0
                ? Column(
                    children: [
                      Container(
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                // BoxShadow(
                                //   color: Colors.grey,
                                //   blurRadius: 6.0,
                                // ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.bookings.length,
                              itemBuilder: (context, index) {
                                // Timestamp t = bookings[index]['date'];
                                // DateTime d = t.toDate();
                                // int remaningday = d.difference(todayDate).inDays;
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BookingDetail(
                                                widget.bookings[index]
                                                        ['bookingid']
                                                    .toString(),
                                                "widget.bookings[index]['service']")));
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  widget.bookings[index]
                                                          ['service']
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                              Text(
                                                  widget.bookings[index]['date']
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                            ],
                                          ),
                                          Icon(
                                            CupertinoIcons.right_chevron,
                                            color:
                                                widget.bookings[index] == false
                                                    ? Colors.red
                                                    : Colors.green,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),
                      Divider(
                        height: 1.2,
                      )
                    ],
                  )
                : Center(
                    child: Text('You Don\'t Have any orders',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
          ],
        ),
      ),
    );
  }
}
