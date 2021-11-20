import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/services/auth.dart';
import 'package:firebase_authentication/views/email_sign_in.dart';
import 'package:firebase_authentication/widgets/my_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
    });

    // Listen false because we are not listener we would access the method
    await Provider.of<Auth>(context, listen: false).signInAnonymously();
    setState(() {
      _isLoading = false;
    });
    /*
    * Google ile giriş yapar butonları da deaktif eder.
    *
    *
    */
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    // Listen false because we are not listener we would access the method
    await Provider.of<Auth>(context, listen: false).signInWithGoogle();

    setState(() {
      _isLoading = false;
    });
    /*
    * Anonim olarak giris yapar ve uid degeri yeniden baslatsa bile degismez
    * Sadece log out oldugunda degisir
    *
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                // Cikis yapmak isin ifade
                await Provider.of<Auth>(context, listen: false).singOut();
                print("Logout Yapıldı");
              })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign In Page",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 30,
            ),
            MyRaiseButton(
              color: Colors.teal,
              child: Text("Sign In Anonymously"),

              // _isLoadinf false oldugu icin async dönecektir
              // _isLoadinf true yapılıp disable edildikten sonra
              // Giriş islemi çağırılacak
              // Giris yapılınca da tekrar false yapılacak.

              onPressed: _isLoading
                  ? null
                  // Parantezsiz yazıyoruz.
                  : _signInAnonymously,
            ),
            SizedBox(
              height: 10,
            ),
            MyRaiseButton(
              color: Colors.orangeAccent,
              child: Text("Sign In Mail/Password"),
              onPressed: _isLoading ? null:() {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EmailSignInPage();
                }));
              },
            ),
            SizedBox(
              height: 10,
            ),
            MyRaiseButton(
              color: Colors.lightBlue,
              child: Text("Sign In With Google"),
              onPressed: _isLoading ? null : _signInWithGoogle,
            ),
          ],
        ),
      ),
    );
  }
}
