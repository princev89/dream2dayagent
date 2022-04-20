import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../configView.dart';
import 'package:timer_button/timer_button.dart';

int currentIndex = 0;

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String phone;
  String otpCode;
  String verificationId;
  DateTime selectedDate = DateTime.now();
  String name;
  String address;
  String district;
  List<String> professions = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isNextClicked;
  bool isVerifyClicked;
  ConfirmationResult confirmationResult;

  Future getPhone() async {
    final SmsAutoFill _autoFill = SmsAutoFill();
    final completePhoneNumber = await _autoFill.hint;
    print(completePhoneNumber);
    setState(() {
      phone = completePhoneNumber;
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      // do whatever you want based on the firebaseUser state
      if (firebaseUser != null) {
        Navigator.pushReplacementNamed(context, "/home");
      }
    });

    currentIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    List screens = [welcome(), signUp(), otp()];

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 40, right: 35),
        child: screens[currentIndex],
      ),
    );
  }

  Widget welcome() {
    void _showPopupMenu() async {
      await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(100, 100, 100, 100),
        items: [
          PopupMenuItem<String>(
            value: 'English',
            child: GestureDetector(
                onTap: () {
                  context.setLocale(Locale('en'));
                  print('English');
                },
                child: Text('English')),
          ),
          PopupMenuItem<String>(
            value: 'हिंदी',
            child: GestureDetector(
              onTap: () {
                context.setLocale(Locale('hi'));
                print('hindi');
              },
              child: Text('हिंदी'),
            ),
          ),
        ],
        elevation: 8.0,
      );
    }

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: SizedBox(
              height: 100, child: Image.asset('assets/background.png')),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text('welcome', style: GoogleFonts.poppins(fontSize: 28)).tr(),
        //     GestureDetector(
        //       onTap: () {
        //         _showPopupMenu();
        //       },
        //       child: Icon(Icons.language, color: Colors.green),
        //     ),
        //   ],
        // ),
        SizedBox(
          height: 10,
        ),
        Text('welcometext', style: GoogleFonts.nunitoSans(fontSize: 30)).tr(),
        SizedBox(
          height: 20,
        ),
        Center(
          child: CupertinoButton(
              color: primaryBlue,
              child: Text('create_account').tr(),
              onPressed: () async {
                print('waiting');

                await getPhone();
                print('done');
                setState(() {
                  currentIndex = 1;
                  print(currentIndex);
                });
              }),
        )
      ]),
    );
  }

  Widget signUp() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
                height: 150,
                width: 150,
                child: Image.asset('assets/profile.png')),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'enter_phone',
            style: heading,
          ).tr(),
          SizedBox(
            height: 20,
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
                    phone = value;
                  },
                  initialValue: phone != null ? phone : null,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'phone_number'.tr(),
                  ),
                )),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            'phone_privacy_text',
            style: secondaryText,
          ).tr(),
          SizedBox(
            height: 30,
          ),
          Center(
            child: CupertinoButton(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: primaryBlue,
                child: isNextClicked == true
                    ? SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : Text('next').tr(),
                onPressed: () async {
                  setState(() {
                    isNextClicked == true
                        ? isNextClicked = false
                        : isNextClicked = true;
                    print(isNextClicked);
                  });
                  if (phone.length == 10) phone = '+91' + phone;
                  // confirmationResult =
                  //     await FirebaseAuth.instance.signInWithPhoneNumber(phone);
                  // if (confirmationResult != null) {
                  //   setState(() {
                  //     currentIndex = 2;
                  //   });
                  // }

                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phone,
                    verificationCompleted:
                        (PhoneAuthCredential credential) async {
                      await auth.signInWithCredential(credential);
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      if (e.code == 'invalid-phone-number') {
                        print('The provided phone number is not valid.');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content:
                              Text("The provided phone number is not valid."),
                        ));
                        setState(() {
                          isNextClicked = false;
                        });
                      }
                    },
                    codeSent: (String verificationId, int resendToken) async {
                      print("verificationId is " + verificationId);
                      this.verificationId = verificationId;
                      setState(() {
                        //ask for otp
                        currentIndex = 2;
                      });
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget otp() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('assets/text_message.png')),
          Text(
            'enter_otp',
            style: heading,
          ).tr(),
          Text(
            'otp_info',
            style: secondaryText,
          ).tr(),
          if (phone != null)
            Text(
              phone,
              style: secondaryText,
            ),
          SizedBox(
            height: 20,
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
                  setState(() {
                    otpCode = value;
                  });
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.digitsOnly
                ],
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: '#  #  #  #  #  #'),
              ),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: CupertinoButton(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: primaryBlue,
                child: isVerifyClicked == true
                    ? SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : Text('verify').tr(),
                onPressed: () async {
                  setState(() {
                    isVerifyClicked == true
                        ? isVerifyClicked = false
                        : isVerifyClicked = true;
                    print(isVerifyClicked);
                  });
                  print(verificationId);
                  print(otpCode);
                  // UserCredential userCredential =
                  //     await confirmationResult.confirm(otpCode);
                  // if (FirebaseAuth.instance.currentUser == null) {
                  //   print('user null');
                  // } else {
                  //   print('logged in');
                  // }

                  await codeIsSent(otpCode);
                }),
          ),
          SizedBox(height: 30),
          TimerButton(
            buttonType: ButtonType.FlatButton,
            label: 'resend_otp'.tr(),
            timeOutInSeconds: 60,
            onPressed: () async {
              setState(() {
                isVerifyClicked = false;
              });
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: phone,
                verificationCompleted: (PhoneAuthCredential credential) async {
                  await auth.signInWithCredential(credential);
                },
                verificationFailed: (FirebaseAuthException e) {
                  if (e.code == 'invalid-phone-number') {
                    print('The provided phone number is not valid.');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("The provided phone number is not valid."),
                    ));
                    setState(() {
                      isNextClicked = false;
                    });
                  }
                },
                codeSent: (String verificationId, int resendToken) async {
                  print("verificationId is " + verificationId);
                  this.verificationId = verificationId;
                  setState(() {
                    //ask for otp
                    currentIndex = 2;
                  });
                },
                codeAutoRetrievalTimeout: (String verificationId) {},
              );
            },
            color: Colors.orange,
            disabledTextStyle: TextStyle(color: CupertinoColors.secondaryLabel),
          ),
        ],
      ),
    );
  }

  codeIsSent(String smsCode) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = await PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    await auth.signInWithCredential(credential);
    if (auth.currentUser != null) {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }
}
