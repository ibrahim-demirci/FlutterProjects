
import 'package:emre_altunbilek_state_mng/sayac_with_provider.dart';
import 'package:emre_altunbilek_state_mng/stream_kullanimi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'bloc/bloc_using.dart';
import 'counter.dart';

void main()async {
  // Bu varsa uygulama başlamadan gereken yapılar varsa
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Blabla',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
              ),
                child: Text("Authentication ve Provider ile Sayaç"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MultiProvider(providers: [
                        ChangeNotifierProvider<MyCounter>(
                          create: (_) => MyCounter(0),
                        ),
                        ChangeNotifierProvider<AuthService>(
                          create: (_) => AuthService(),
                        ),
                      ],
                      child: ProviderSayac(),)
                    ),
                  );
                }),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigoAccent),
                ),
                child: Text("Stream İle Sayac"),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StreamUsing(),));
                }),

            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                ),
                child: Text("Bloc Kullanımı"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => BlocUsing()
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
