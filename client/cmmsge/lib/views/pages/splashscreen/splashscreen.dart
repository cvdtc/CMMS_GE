import 'dart:async';

import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/utils/bottomnavigation.dart';
import 'package:cmmsge/views/utils/ceksharepreference.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  late FirebaseMessaging messaging;
  bool subscribemasalah = true;
  bool subscribeprogress = true;
  bool subscribeselesai = true;

  @override
  void initState() {
    super.initState();
    // * adding firebase configuration setup
    messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    // ++ SUBSCRIBE TOPIC RMS PERMINTAAN
    if (subscribemasalah) {
      // messaging.subscribeToTopic('RMSPERMINTAAN');
      messaging.subscribeToTopic('CMMSMASALAH');
    } else {
      // messaging.unsubscribeFromTopic('RMSPERMINTAAN');
      messaging.unsubscribeFromTopic('CMMSMASALAH');
    }
    // ++ SUBSCRIBE TOPIC RMSPROGRESS
    if (subscribeprogress) {
      // messaging.subscribeToTopic('RMSPROGRESS');
      messaging.subscribeToTopic('CMMSPROGRESS');
    } else {
      // messaging.unsubscribeFromTopic('RMSPROGRESS');
      messaging.unsubscribeFromTopic('CMMSPROGRESS');
    }
    // ++ SUBSCRIBE TOPIC RMSSELESAI
    if (subscribeselesai) {
      // messaging.subscribeToTopic('RMSPROGRESS');
      messaging.subscribeToTopic('CMMSSELESAI');
    } else {
      // messaging.unsubscribeFromTopic('RMSPROGRESS');
      messaging.unsubscribeFromTopic('CMMSSELESAI');
    }
    Timer(Duration(seconds: 4), () {
      CekSharedPred().cektoken(context).then((value) {
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigation(
                      numberOfPage: 0,
                    )));
      });
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 175,
                height: 100,
                child: Image.asset('assets/images/logoge.png'),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'CMMS GRAND ELEPHANT',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              CircularProgressIndicator(
                color: primarycolor,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
