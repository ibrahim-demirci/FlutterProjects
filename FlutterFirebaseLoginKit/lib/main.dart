import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_firebaselogin/pages/login_screen.dart';
import 'package:flutterx_firebaselogin/pages/phone_login.dart';
import 'package:flutterx_firebaselogin/pages/splash_screen.dart';
import 'package:flutterx_firebaselogin/pages/welcome_page.dart';
import 'package:flutterx_firebaselogin/pages/admob_page.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
  FirebaseAdMob.instance.initialize(appId: _getAppId()); // Initialize AdMob app ID
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/landingpage':(BuildContext context)=>MyApp(),
        '/welcomepage':(BuildContext context)=>WelcomePage(),
        '/phonelogin':(BuildContext context)=>PhoneLogin(),
        '/admobpage':(BuildContext context)=>AdmobPage(),
        '/splash':(BuildContext context)=>SplashScreen(),
        '/login':(BuildContext context)=>LoginScreen(),
      },
    );
  }
}

// AdMob app id input here
String _getAppId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-4846931245614453~7687050969';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-4846931245614453~7687050969';
  }
  return null;
}
