import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final _firebaseAuth = FirebaseAuth.instance;

  //async varsa future olmalidir.

  // Anonim olarak giriş yapmamızı sağlar.
  Future<User> signInAnonymously() async {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  // Kullanıcıyı çıkış yapar.
  Future<void> singOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  // Kullanıcı sign in out durumu hakkında stream döndürür.
  Stream<User> authStatus() {
    // Methot zaten bir stream donduruyordu
    // Biz de o streami aliyoruz.

    return _firebaseAuth.authStateChanges();
  }

  // Email ve şifre ile kullanıcı oluşturur ardından giriş yapar !!!.
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {

      print(e.code);
      print(e.message);
      rethrow;

    }
  }

  // Email ve şifre ile giriş yapmak için.
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  // Geri dönüş değeri yoktur ve şifre sıfırlamak için mail gönderir.
  Future<void> sendPassworkResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Google ile giriş yapmak için.
  Future<User> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Giriş yapmazsa null döner.
    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the User
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } else {
      return null;
    }
  }
}

//provider paketi olustur
