import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterx_firebaselogin/constants/strings.dart';
import 'package:flutterx_firebaselogin/pages/welcome_page.dart';
import 'package:flutterx_firebaselogin/constants/constants.dart';
import 'package:flutterx_firebaselogin/services/platform_alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  String phoneNo;
  String smsCode;
  String verificationId;

  Future<void> _showSignInError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.signInFailed,
      exception: exception,
    ).show(context);
  }

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrive = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed in');
      });
    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential phoneAuthCredential) {
      print('Verified');
    };

    final PhoneVerificationFailed verifiedFailed = (AuthException exception) {
      print('${exception.message}');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error!"),
              content: Text("${exception.message}"),
            );
          });
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifiedFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrive);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter Sms Code'),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.currentUser().then(
                        (user) {
                          if (user != null) {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WelcomePage(
                                  currentUser:
                                      FirebaseAuth.instance.currentUser().then(
                                    (val) {
                                      this.phoneNo = val.phoneNumber;
                                    },
                                  ),
                                ),
                              ),
                            ).catchError(
                              (e) {
                                _showSignInError(context, e);
                              },
                            );
                          } else {
                            Navigator.of(context).pop();
                            phoneSignIn();
                          }
                        },
                      );
                    } on PlatformException catch (e) {
                      _showSignInError(context, e);
                    }
                  },
                  child: Text('Done')),
            ],
          );
        });
  }

  phoneSignIn() {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      FirebaseAuth.instance.signInWithCredential(credential).then((user) {
        Navigator.of(context).pushReplacementNamed('/welcomepage');
      }).catchError((e) {
        final snack = SnackBar(
          content: new Text(e.message),
          action: null,
          duration: new Duration(seconds: 4),
          backgroundColor: Colors.black,
        );
        Scaffold.of(context).showSnackBar(snack);
      });
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            BackgroundWidget(size: size),
            Positioned(
              child: AppBar(
                title: Text("Phone Login"),
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.mobileAlt,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'PHONE LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle,
                      height: 60.0,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.white,
                          ),
                          hintText: 'Enter Phone Number',
                          hintStyle: kHintTextStyle,
                        ),
                        onChanged: (value) {
                          this.phoneNo = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Format: [+][country code][number with area code]',
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      width: 200.0,
                      child: RaisedButton(
                        elevation: 5.0,
                        onPressed: verifyPhone,
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.black54,
                        child: Text(
                          'Verify',
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
