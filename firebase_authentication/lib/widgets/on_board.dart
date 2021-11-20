import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/services/auth.dart';
import 'package:firebase_authentication/views/home_page.dart';
import 'package:firebase_authentication/views/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnBoardWidget extends StatefulWidget {
  @override
  _OnBoardWidgetState createState() => _OnBoardWidgetState();
}

class _OnBoardWidgetState extends State<OnBoardWidget> {


  @override
  Widget build(BuildContext context) {
    // _auth ile Auth servisine Provider sayesinde erisebiliyoruz.
    final _auth = Provider.of<Auth>(context, listen: false);

    return StreamBuilder<User>(

        // Dinledigi yer
        stream: _auth.authStatus(),

        // Dinlenen metoda gore buiilder metodu
        builder: (BuildContext context, AsyncSnapshot<dynamic> snaphot) {
          // Eger baglanti tamam ise
          if (snaphot.connectionState == ConnectionState.active) {
            return snaphot.data != null ? HomePage() : SignInPage();
          } else {
            return SizedBox(
              width: 300,
              height: 300,
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
