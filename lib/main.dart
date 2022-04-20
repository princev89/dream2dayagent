import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:startup/configView.dart';
import 'package:startup/pages/createAccount.dart';
import 'package:startup/pages/home.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:startup/widgets/updateprofile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('hi')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MyApp()),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final pages = [
    PageViewModel(
      pageBackground: Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   stops: [0.0, 1.0],
            //   begin: FractionalOffset.topCenter,
            //   end: FractionalOffset.bottomCenter,
            //   tileMode: TileMode.repeated,
            //   colors: [
            //     Colors.orange,
            //     Colors.pinkAccent,
            //   ],
            // ),
            color: Colors.white),
      ),
      // iconImageAssetPath: 'assets/air-hostess.png',
      bubble: Image.asset('assets/shop.png'),
      body: Text(
        'Register your shop and showcase your facility to everyone.',
      ),
      title: Text(
        'Connect with us and explore your business.',
      ),
      mainImage: Image.asset(
        'assets/shop.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: GoogleFonts.poppins(color: Colors.black54),
      bodyTextStyle: GoogleFonts.poppins(color: Colors.black54),
    ),
    PageViewModel(
      pageBackground: Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   stops: [0.0, 1.0],
            //   begin: FractionalOffset.topCenter,
            //   end: FractionalOffset.bottomCenter,
            //   tileMode: TileMode.repeated,
            //   colors: [
            //     Colors.orange,
            //     Colors.pinkAccent,
            //   ],
            // ),
            color: Colors.white),
      ),
      iconImageAssetPath: 'assets/viewbookings.png',
      body: Text(
        'Maintain your portfolio and attract customers.',
      ),
      mainImage: Image.asset(
        'assets/viewbookings.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      title: Text('Grow with us , we are always here to help you'),
      titleTextStyle: GoogleFonts.poppins(color: Colors.black54),
      bodyTextStyle: GoogleFonts.poppins(color: Colors.black54),
    ),
    PageViewModel(
      pageBackground: Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   stops: [0.0, 1.0],
            //   begin: FractionalOffset.topCenter,
            //   end: FractionalOffset.bottomCenter,
            //   tileMode: TileMode.repeated,
            //   colors: [
            //     Colors.orange,
            //     Colors.pinkAccent,
            //   ],
            // ),
            color: Colors.white),
      ),
      iconImageAssetPath: 'assets/manage_shop.png',
      body: Text(
        'Easy  to manage your  booking  at  your  fingertip.',
      ),
      title: Text('Increase You Reach'),
      mainImage: Image.asset(
        'assets/manage_shop.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: GoogleFonts.poppins(color: Colors.black54),
      bodyTextStyle: GoogleFonts.poppins(color: Colors.black54),
    ),
  ];
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: darkMode));
    return MaterialApp(
      locale: context.locale,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: mainColor),
      ),
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      title: 'Dream2Day Agent',
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return CircularProgressIndicator();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return auth.currentUser != null
                ? Home()
                : Builder(
                    builder: (context) => IntroViewsFlutter(
                          pages,
                          showNextButton: true,
                          showBackButton: true,
                          onTapDoneButton: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CreateAccount()),
                            );
                          },
                          onTapSkipButton: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CreateAccount()),
                            );
                          },
                          pageButtonTextStyles: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                          ),
                        ));
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return CircularProgressIndicator();
        },
      ),
      routes: {
        "/home": (_) => Home(),
        "/updateProfile": (_) => UpdateProfile(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
