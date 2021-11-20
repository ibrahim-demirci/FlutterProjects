import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:flutterx_firebaselogin/pages/linkedin_login.dart';
import 'package:flutterx_firebaselogin/pages/phone_login.dart';
import 'package:flutterx_firebaselogin/services/platform_alert_dialog.dart';
import 'package:flutterx_firebaselogin/constants/strings.dart';
import 'package:flutterx_firebaselogin/pages/resigter_page.dart';
import 'package:flutterx_firebaselogin/pages/welcome_page.dart';
import 'package:flutterx_firebaselogin/services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutterx_firebaselogin/constants/constants.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  LoginScreen({this.auth});

  final BaseAuth auth;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String displayName = '';
  String photoUrl = '';
  String uid = '';
  String _email;
  String _password;
  final formKey = new GlobalKey<FormState>();
  final facebookLogin = FacebookLogin();
  String _loggedInMessage;
  FirebaseUser _currentUser;

  TwitterLoginResult _twitterLoginResult;
  TwitterLoginStatus _twitterLoginStatus;
  TwitterSession _currentUserTwitterSession;


  // Error Dialogue
  Future<void> _showSignInError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.signInFailed,
      exception: exception,
    ).show(context);
  }

  validateLoginAndSave() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  //Phone Login

  validateAndSubmit() async {
    if (validateLoginAndSave()) {
      try {
        FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
                email: _email, password: _password))
            .user;
        if (user.isEmailVerified) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WelcomePage(
                        currentUser:
                            FirebaseAuth.instance.currentUser().then((val) {
                      this.email = val.email;
                    }).catchError((e) {
                      _showSignInError(context, e);
                    }))),
          );
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Verify"),
                  content: Text("Please Verify your email to continue Login"),
                );
              });
        }
        print('Logged User: $user');
      } on PlatformException catch (e) {
        _showSignInError(context, e);
      }
    }
  }

  // Google Login

  Future<void> _googleLogin(BuildContext context) async {
    try {
      await widget.auth.signInWithGoogle().whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WelcomePage(
                      currentUser:
                          FirebaseAuth.instance.currentUser().then((val) {
                    this.email = val.email;
                    this.displayName = val.displayName;
                    this.photoUrl = val.photoUrl;
                  }).catchError((e) {
                    _showSignInError(context, e);
                  }))),
        );
      });
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  // Facebook Login
  Future<void> _loginWithFB(BuildContext context) async {
    try {
      await widget.auth.signInWithFacebook();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WelcomePage(
                    currentUser:
                        FirebaseAuth.instance.currentUser().then((val) {
                  this.email = val.email;
                  this.displayName = val.displayName;
                  this.photoUrl = val.photoUrl;
                }).catchError((e) {
                  _showSignInError(context, e);
                }))),
      );
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  // Twitter Login - Api key and secret key are in constants/string.dart file
  void _loginWithTwitter(BuildContext context) async {
    String snackBarMessage = '';

    final TwitterLogin twitterLogin = new TwitterLogin(
        consumerKey: Strings.twitterApiKey,
        consumerSecret: Strings.twitterApiSecret);

    _twitterLoginResult = await twitterLogin.authorize();
    _currentUserTwitterSession = _twitterLoginResult.session;
    _twitterLoginStatus = _twitterLoginResult.status;

    switch (_twitterLoginStatus) {
      case TwitterLoginStatus.loggedIn:
        _currentUserTwitterSession = _twitterLoginResult.session;
        snackBarMessage = 'Successfully signed in as';
        PlatformAlertDialog(title:'Success', content: 'Successfully signed in', defaultActionText: 'Cancel',);
        break;

      case TwitterLoginStatus.cancelledByUser:
        snackBarMessage = 'Sign in cancelled by user.';
        PlatformAlertDialog(title:'Success', content: 'Sign in cancelled by user.', defaultActionText: 'Cancel',);
        break;

      case TwitterLoginStatus.error:
        snackBarMessage = 'An error occurred signing with Twitter.';
        PlatformAlertDialog(title:'Success', content: 'An error occurred signing with Twitter.', defaultActionText: 'Cancel',);
        break;
    }

    AuthCredential _authCredential = TwitterAuthProvider.getCredential(
        authToken: _currentUserTwitterSession?.token ?? '',
        authTokenSecret: _currentUserTwitterSession?.secret ?? '');
    _currentUser =
        (await _firebaseAuth.signInWithCredential(_authCredential)).user;

    setState(() {
      if (_twitterLoginStatus == TwitterLoginStatus.loggedIn &&
          _currentUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WelcomePage(
                      currentUser:
                          FirebaseAuth.instance.currentUser().then((val) {
                    this.displayName = val.displayName;
                    this.photoUrl = val.photoUrl;
                  }).catchError((e) {
                    _showSignInError(context, e);
                  }))),
        );
      } else {
        PlatformAlertDialog(title:'Error', content: 'An error occurred signing with Twitter.', defaultActionText: 'Cancel',);
        _loggedInMessage = _loggedInMessage = '$snackBarMessage';
      }
    });
  }

  // Anonymous Login
  anonymousSignIn(BuildContext context) async {
    await widget.auth.signInAnonymously().whenComplete(() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WelcomePage(
                    currentUser:
                        FirebaseAuth.instance.currentUser().then((val) {
                  this.uid = val.uid;
                }).catchError((e) {
                  _showSignInError(context, e);
                }))),
      );
    });
  }

  Widget _buildForm() {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              decoration: kBoxDecorationStyle,
              height: 60.0,
              child: TextFormField(
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  hintText: 'Enter your Email',
                  hintStyle: kHintTextStyle,
                ),
                validator: (value) =>
                    value.isEmpty ? 'Email Can\'t be Empty' : null,
                onSaved: (value) => _email = value,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              alignment: Alignment.centerLeft,
              decoration: kBoxDecorationStyle,
              height: 60.0,
              child: TextFormField(
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  hintText: 'Enter your Password',
                  hintStyle: kHintTextStyle,
                ),
                validator: (value) =>
                    value.isEmpty ? 'Password Can\'t be Empty' : null,
                onSaved: (value) => _password = value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      width: 200.0,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: validateAndSubmit,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.black54,
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          'OR',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
//        Text(
//          'Sign in / Login with',
//          style: kLabelStyle,
//        ),
      ],
    );
  }

  Widget _buildSignupBtn() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Don\'t have an Account? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  //Sign in with.. dialogue
  Widget _buildDialogueBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      width: 200.0,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          showGeneralDialog(
            context: context,
            pageBuilder: (context, anim1, anim2) {
              return Text('PAGE BUILDER');
            },
            barrierDismissible: true,
            barrierColor: Colors.transparent.withOpacity(0.85),
            barrierLabel: '',
            transitionDuration: Duration(milliseconds: 200),
            transitionBuilder: (context, anim1, anim2, child) {
              return Transform.scale(
                //scale: 1.0,
                scale: anim1.value,
                child: Opacity(
                  opacity: anim1.value,
                  child: AlertDialog(
                    backgroundColor: Colors.transparent,
                    content: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: FittedBox(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    width: 180.0,
                                    child: RaisedButton.icon(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                      ),
                                      color: Colors.red,
                                      icon: Icon(
                                        FontAwesomeIcons.google,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        'Google',
                                        style: kButtonTextStyle,
                                      ),
                                      onPressed: () => _googleLogin(context),
                                    ),
                                  ),
                                  Container(
                                    width: 180.0,
                                    child: RaisedButton.icon(
                                      onPressed: () => _loginWithFB(context),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                      ),
                                      color: Color(0xFF3b5998),
                                      icon: Icon(
                                        FontAwesomeIcons.facebookF,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        'Facebook',
                                        style: kButtonTextStyle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 180.0,
                                    child: RaisedButton.icon(
                                      onPressed: () =>
                                          _loginWithTwitter(context),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                      ),
                                      color: Color(0xFF00acee),
                                      icon: Icon(
                                        FontAwesomeIcons.twitter,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        'Twitter',
                                        style: kButtonTextStyle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 180.0,
                                    child: RaisedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PhoneLogin()),
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                      ),
                                      color: Color(0xFFED6361),
                                      icon: Icon(
                                        FontAwesomeIcons.phone,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        'Phone',
                                        style: kButtonTextStyle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 180.0,
                                    child: RaisedButton.icon(
                                      onPressed: () => anonymousSignIn(context),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                      ),
                                      color: Colors.white,
                                      icon: Icon(
                                        FontAwesomeIcons.userAlt,
                                        color: Colors.black,
                                      ),
                                      label: Text(
                                        'Anonymous',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 180.0,
                                    child: RaisedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LinkedInLogin()),
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                      ),
                                      color: Color(0xFF006FAB),
                                      icon: Icon(
                                        FontAwesomeIcons.linkedinIn,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        'Linkedin',
                                        style: kButtonTextStyle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 180.0,
                                    child: RaisedButton.icon(
                                      onPressed: () {},
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                      ),
                                      color: Colors.blueGrey,
                                      icon: Icon(
                                        FontAwesomeIcons.apple,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        'Apple',
                                        style: kButtonTextStyle,
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
                  ),
                ),
              );
            },
          );
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.black54,
        child: Text(
          'Sign in with..',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
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
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 50.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Hero(
                            tag: 'login',
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Icon(
                                FontAwesomeIcons.user,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          _buildForm(),
                          _buildLoginBtn(),
                          _buildSignInWithText(),
                          _buildDialogueBtn(),
                          _buildSignupBtn(),
                        ],
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
