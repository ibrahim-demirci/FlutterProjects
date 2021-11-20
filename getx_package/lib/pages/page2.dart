import 'package:flutter/material.dart';
import 'package:getxfire/getxfire.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Page 2'),
          ),
          ElevatedButton.icon(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_new),
              label: Text('Back'))
        ],
      ),
    );
  }
}
