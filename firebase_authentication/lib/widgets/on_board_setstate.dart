import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/views/home_page.dart';
import 'package:firebase_authentication/views/sign_in_page.dart';
import 'package:flutter/material.dart';

class OnBoardWidget extends StatefulWidget {
  @override
  _OnBoardWidgetState createState() => _OnBoardWidgetState();
}

class _OnBoardWidgetState extends State<OnBoardWidget> {
  bool _isLogged;

  // Widget ilk yuklendiginde calisir.
  @override
  void initState() {

    // Abone olunca ilk bilgi bir kez geldi
    FirebaseAuth.instance.authStateChanges().listen(
      (User user) {
        if (user == null) {
          print(' User is currently signed out!');
          _isLogged = false;
        } else {
          print('User is signed in!');
          _isLogged = true;
        }

        setState(() {});
      },
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLogged == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isLogged
            ? HomePage()
            : SignInPage();
  }
}
