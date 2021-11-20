import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterx_firebaselogin/constants/size_config.dart';
import 'package:flutterx_firebaselogin/pages/dashboard_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    Timer(Duration(seconds: 5),()=>Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(auth: new Auth(),)),
//    Timer(Duration(seconds: 3),()=>Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardPage()),
    Timer(
        Duration(seconds: 3),
        () => Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 1),
                pageBuilder: (_, __, ___) => DashboardPage())));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Container(
        height: SizeConfig.blockSizeVertical * 100,
        width: SizeConfig.blockSizeHorizontal * 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 120.0, right: 120.0),
                      child: LinearProgressIndicator(
                        backgroundColor: Color(0xFFD7D7D7),
                      ),
                    ),
                  ],
                )),
              ],
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'intro',
                    child: Image(
                      image: AssetImage('assets/images/google_firebase.png'),
                      height: SizeConfig.blockSizeVertical * 35,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  'Flutter Firebase All In One',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'v1.0.0.20',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
