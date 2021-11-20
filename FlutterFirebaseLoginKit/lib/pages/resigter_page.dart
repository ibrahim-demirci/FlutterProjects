import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterx_firebaselogin/constants/strings.dart';
import 'package:flutterx_firebaselogin/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterx_firebaselogin/constants/constants.dart';
import 'package:flutterx_firebaselogin/services/platform_alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final usersRef = Firestore.instance.collection('users');

final DateTime timestamp = DateTime.now();

class RegisterScreen extends StatefulWidget {
  RegisterScreen({this.auth});
  final BaseAuth auth;
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email;
  String _password;
  String _displayName;

  final formKey = new GlobalKey<FormState>();

  Future<void> _showRegisterError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.registrationFailed,
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
    if (validateLoginAndSave()) {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

      FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: _email, password: _password)).user;
        usersRef.document(user.uid).setData({
          "id": user.uid,
          "email": user.email,
          "displayName": _displayName,
          "status":0,
          "timestamp": timestamp
        });
      try {
        await user.sendEmailVerification();
        if(user.isEmailVerified){
          await user.reload();
          Navigator.of(context).pushReplacementNamed('/welcomepage').catchError((e) {
            _showRegisterError(context, e);
          });
        }else{
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Verify"),
                  content: Text("Registration Successfull. Please verify your email and Login."),
                  actions: <Widget>[
                    GestureDetector(
                      onTap: ()=> Navigator.of(context).pushReplacementNamed('/landingpage'),
                      child: Row(
                        children: <Widget>[Text('Login',style: TextStyle(fontSize: 20.0),)],
                      ),
                    ),
                  ],
                );
              }
          );
        }
      } on PlatformException catch (e) {
        _showRegisterError(context, e);
      }
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
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.account_box,
                          color: Colors.white,
                        ),
                        hintText: 'Name',
                        hintStyle: kHintTextStyle,
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Name Can\'t be Empty' : null,
                      onSaved: (value) => _displayName = value,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              alignment: Alignment.centerLeft,
              decoration: kBoxDecorationStyle,
              height: 60.0,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
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
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              alignment: Alignment.centerLeft,
              decoration: kBoxDecorationStyle,
              height: 60.0,
              child: Column(
                children: <Widget>[
                  Expanded(
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
          ],
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
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
          'Register',
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

  Widget _buildSignupBtn() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Already have an Account? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Log in',
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                              'REGISTER',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 25.0),
                          _buildForm(),
                          _buildLoginBtn(),
                          _buildSignupBtn(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
