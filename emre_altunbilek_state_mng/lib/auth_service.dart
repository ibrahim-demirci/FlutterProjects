import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum UserStatus {
  SignedIn,
  SignedOut,
  Signing,
}

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserStatus _userStatus = UserStatus.SignedOut;

  UserStatus get userStatus => _userStatus;
  User _user;


  User get user => _user;

  set setUserStatus(UserStatus value) {
    _userStatus = value;
    // Uygulamayı haberdar ediyoruz değişiklikten.
    notifyListeners();
  }

  AuthService() {
    _auth.authStateChanges().listen(_authStateChanged);
  }

  void _authStateChanged(User user) {
    if (user == null) {
      _user = null;
      setUserStatus = UserStatus.SignedOut;
    } else {
      _user = user;
      setUserStatus = UserStatus.SignedIn;
    }
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      setUserStatus = UserStatus.Signing;
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User _newUser = _userCredential.user;
      _user = _newUser;
      return _newUser;
    } catch (e) {
      setUserStatus = UserStatus.SignedOut;
      print("Create User Hata var $e");
      return null;
    }
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      setUserStatus = UserStatus.Signing;
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User _signedUser = _userCredential.user;
      _user = _signedUser;
      return _signedUser;
    } catch (e) {
      setUserStatus = UserStatus.SignedOut;
      print("Sign in Hata var $e");
      return null;
    }
  }

  Future<bool> signOut() async {

     try {
       await _auth.signOut();
       _user = null;
       setUserStatus = UserStatus.SignedOut;
     } catch(e){
       print("Sign Out Hata var $e");
       return false;

     }
  }
}
