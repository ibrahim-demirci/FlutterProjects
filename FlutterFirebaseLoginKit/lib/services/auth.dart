import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:meta/meta.dart';

@immutable
class User {
  const User({
    @required this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
}

abstract class BaseAuth{
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<User> currentUser();
  Future<void> signOut();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInAnonymously();
}

class Auth implements BaseAuth{

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  final FirebaseAuth fireBaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = (await fireBaseAuth.signInWithEmailAndPassword(email:email,password:password)).user;
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = (await fireBaseAuth.signInWithEmailAndPassword(email:email,password:password)).user;
    try {
      await user.sendEmailVerification();
      return user.uid;
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
    }
    return user.uid;
  }


  @override
  Future<User> signInAnonymously() async {
    final AuthResult authResult = await fireBaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }


  @override
  Future<User> currentUser() async {
    final FirebaseUser user = await fireBaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    return fireBaseAuth.signOut();
  }

  @override
  void dispose() {}

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final AuthResult authResult = await fireBaseAuth
            .signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Authentication Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted');
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final FacebookLoginResult result =
    await facebookLogin.logIn(<String>['public_profile']);
    if (result.accessToken != null) {
      final AuthResult authResult = await fireBaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token),
      );
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted');
    }
  }

}