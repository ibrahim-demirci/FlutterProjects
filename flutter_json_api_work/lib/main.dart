import 'package:flutter/material.dart';
import 'package:flutter_json_api_work/read_json_from_local.dart';

/* json javascript object notation.
* key ve valuelerdan olusur
*
*
*  sadece bir gosterim bicimidir.
*
* */

/*
* api ile database üzerine gitmeden belirli parametreler ile verilere erişebilirsin
* json formatında ver ben bunu islerim diyoruz
*
*/

void main() {
  runApp(MaterialApp(
    title: "Json App",
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlatButton(
              color: Colors.green,
              child: Text(
                'Open route',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocalJson()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
