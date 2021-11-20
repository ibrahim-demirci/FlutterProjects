import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () async {
              var _instance = FirebaseFirestore.instance;

              await _instance.collection('main').doc("QBBZQ4amsADLzg6Rr2Kw").get();
              
            },
            child: const Text('Kaydet'),
          ),
        ),
      ),
    );
  }
}
