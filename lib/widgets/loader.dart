import 'package:flutter/material.dart';

showLoaderDialog(BuildContext _context, String message) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text(message)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: _context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
