import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/services/auth.dart';
import 'package:firebase_authentication/views/sign_in_page.dart';
import 'package:firebase_authentication/widgets/on_board.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  // widget agacini kurmadan once bunu yapmalisin.
  WidgetsFlutterBinding.ensureInitialized();

  /*
  uygulama witget agacini cizmeden firebase baslatiliyor.
  bu bir future islemidir.
  bu işlem 2. yöntemdir async eklemeyi unutma.
  */
  await Firebase.initializeApp();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Provider<Auth>(
      // Kendisine bir obje veriyor
      create: (context) => Auth(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: OnBoardWidget(),

      ),
    );
  }
}

