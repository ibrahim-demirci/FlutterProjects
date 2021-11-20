import 'package:flutter/material.dart';
import 'package:responsive_code_works/ui/column_design_view.dart';
import 'package:responsive_code_works/ui/list_view_design.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: ListViewDesing(),
    );
  }
}
