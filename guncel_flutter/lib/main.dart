import 'package:flutter/material.dart';
import 'package:guncel_flutter/ui/liste_dersleri.dart';
import 'package:vector_math/vector_math_lists.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Dersleri",
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Liste Dersleri",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListeKonuAnlatimi(),
      ),
    );
  }

}
