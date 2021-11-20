import 'package:flutter/material.dart';

import 'bloc_using_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: BlocUsingPage(),
    );
  }
}
