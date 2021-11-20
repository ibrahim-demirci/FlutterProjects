import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_firebaselogin/constants/constants.dart';
import 'package:flutterx_firebaselogin/services/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class WelcomePage extends StatefulWidget {
  WelcomePage({this.auth, this.currentUser});
  final BaseAuth auth;
  final Future currentUser;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String email = '';
  String phoneNo = '';
  String displaName = '';
  String photoUrl = '';
  String uid = '';

  //final facebookLogin = FacebookLogin();

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.uid = val.uid;
        this.email = val.email;
        this.phoneNo = val.phoneNumber;
        this.displaName = val.displayName;
        this.photoUrl = val.photoUrl;
      });
    }).catchError((e) {
      print(e);
    });

    // TODO: implement initState
    super.initState();
    //widget.userProfile.entries;
    //_loginWithFB();
  }

  logout() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            BackgroundWidget(size: size),
            Positioned(
              child: AppBar(
                title: Text("Welcome!"),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: <Widget>[
                  IconButton(
                    onPressed: () {

                    },
                    icon: Icon(Icons.share),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/google_firebase.png'),
                      width: 120.0,
                    ),
                    Text(
                      'Flutter Firebase All In One',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          photoUrl != null
                              ? CachedNetworkImage(
                                  width: 100.0,
                                  imageUrl: "$photoUrl",
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )
                              : Text(''),
                          SizedBox(
                            height: 20.0,
                          ),
                          uid != null
                              ? Text('UID: $uid', style: kLabelStyle,)
                              : Text(''),
                          SizedBox(
                            height: 10.0,
                          ),
                          displaName != null
                              ? Text(
                                  'Name: ' + displaName,
                                  style: kLabelStyle,
                                )
                              : Text(''),
                          //photoUrl == null ? Icon(Icons.camera_alt, size: 5.0) : null,
                          SizedBox(
                            height: 10.0,
                          ),
                          email != null
                              ? Text(
                                  'Email: ' + email,
                                  style: kLabelStyle,
                                )
                              : Text(''),
                          SizedBox(
                            height: 10.0,
                          ),
                          phoneNo != null
                              ? Text(
                                  'Phone: ' + phoneNo,
                                  style: kLabelStyle,
                                )
                              : Text(''),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),

//                   code added by mamun

                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/admobpage')
                              .catchError((e) {
                            print(e);
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/admob.png',
                              width: 40.0,
                              height: 30.0,
                            ),
                            Text(
                              'Admob',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      width: 200.0,
                      height: 50.0,
                      child: RaisedButton(
                        elevation: 5.0,
                        onPressed: logout,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.black54,
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
