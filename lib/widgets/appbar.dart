import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:startup/widgets/updateprofile.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {},
          child: SizedBox(
              height: 45,
              child: Image.asset('assets/background.png', fit: BoxFit.cover)),
        ),
        SizedBox(
          width: 10,
        ),
        Text.rich(
          TextSpan(
            text: 'Dream',
            style: GoogleFonts.poppins(
              color: Colors.orange,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: '2',
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                  )),
              TextSpan(
                  text: 'Day',
                  style: GoogleFonts.poppins(
                    color: Colors.orange,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(),
        ),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UpdateProfile()));
            },
            icon: Icon(Icons.account_circle_rounded,
                color: Colors.black38, size: 30))
      ],
    );
  }
}
