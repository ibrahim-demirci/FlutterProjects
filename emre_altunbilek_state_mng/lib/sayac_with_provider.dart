
import 'auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter.dart';


class ProviderSayac extends StatefulWidget {
  @override
  _ProviderSayacState createState() => _ProviderSayacState();
}

class _ProviderSayacState extends State<ProviderSayac> {
  @override
  Widget build(BuildContext context) {

    final myAuth = Provider.of<AuthService>(context);

    switch (myAuth.userStatus) {
      case UserStatus.Signing:
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      case UserStatus.SignedOut:
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Oturum Açın'),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () async {
                    await myAuth.signInWithEmailAndPassword(
                        "bmi.demirci@gmail.com", "123456");
                  },
                  child: Text('Oturum Aç'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  onPressed: () async {
                    await myAuth.createUserWithEmailAndPassword(
                        "bmi.demirci@gmail.com", "123456");
                  },
                  child: Text('Kaydol'),
                ),
              ],
            ),
          ),
        );
      case UserStatus.SignedIn:
        return Scaffold(
          appBar: AppBar(
            title: Text('Provider Sayac'),
          ),
          body: Center(
            child: MyColumn(),
          ),
          floatingActionButton: MyFloatingActionButtons(),
        );
    }
  }
}

class MyFloatingActionButtons extends StatelessWidget {
  const MyFloatingActionButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(" myfloating action button build");

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            // Listen false demek counter içinde sadece kullanmak istiyorum demektir.
            Provider.of<MyCounter>(context, listen: false).arttir();
          },
          heroTag: '1',
          child: Icon(Icons.add),
        ),
        SizedBox(
          height: 5,
        ),
        FloatingActionButton(
          onPressed: () {
            Provider.of<MyCounter>(context, listen: false).azalt();
          },
          heroTag: '2',
          child: Icon(Icons.remove),
        ),
      ],
    );
  }
}

class MyColumn extends StatelessWidget {
  const MyColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(" mycolumn action button build");

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.watch<MyCounter>().sayac.toString(),
          style: TextStyle(fontSize: 32),
        ),
        Text(
          Provider.of<AuthService>(context).user.email,
          style: TextStyle(fontSize: 32),
        ),
        ElevatedButton(
          onPressed: () async{

            await context.read<AuthService>().signOut();

          },
          child: Text('Oturumu Kapat'),
        )
      ],
    );
  }
}
