import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterx_firebaselogin/constants/constants.dart';
import 'package:flutterx_firebaselogin/constants/strings.dart';
import 'package:flutterx_firebaselogin/pages/chat/chat_screen.dart';
import 'package:flutterx_firebaselogin/pages/resigter_page.dart';
import 'package:flutterx_firebaselogin/services/platform_alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
class ChatLogin extends StatefulWidget {
  @override
  _ChatLoginState createState() => _ChatLoginState();
}

class _ChatLoginState extends State<ChatLogin> {
  bool showSpinner = false;
  String email = '';
  String displayName = '';
  String photoUrl = '';
  String uid = '';
  String _email;
  String _password;
  final formKey = new GlobalKey<FormState>();



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

  validateAndSubmit() async {
    setState(() {
      showSpinner = true;
    });
    if (validateLoginAndSave()) {
      try {
        FirebaseUser user = (await _fireBaseAuth.signInWithEmailAndPassword(
            email: _email, password: _password))
            .user;
        if (user.isEmailVerified) {
          usersRef.document(user.uid).updateData({
            "status":1,
          });
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen()),
          );
          setState(() {
            showSpinner = false;
          });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Verify"),
                  content: Text("Please Verify your email to continue Login"),
                );
              });
          setState(() {
            showSpinner = false;
          });
        }
        print('Logged User: $user');
      } on PlatformException catch (e) {
        _showSignInError(context, e);
      }
      setState(() {
        showSpinner = false;
      });
    }
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
    return GestureDetector(
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
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              BackgroundWidget(size: size),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 50.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag:'chat',
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Icon(
                            FontAwesomeIcons.paperPlane,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'CHAT',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      _buildForm(),
                      _buildLoginBtn(),
                      _buildSignInWithText(),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
