import 'package:cmmsge/utils/warna.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'views/pages/splashscreen/splashscreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: thirdcolor, // status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMMS GE',
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: backgroundcolor,
          textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: textcolor),
          canvasColor: Colors.transparent),
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
    );
  }
}
