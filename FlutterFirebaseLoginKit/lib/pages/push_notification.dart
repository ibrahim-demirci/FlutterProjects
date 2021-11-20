import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class PushNotification extends StatefulWidget {
  @override
  _PushNotificationState createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {

  final FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  void initState() {
    _messaging.getToken().then((token){
      print(token);
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}

//To test Get the token and put to firebase console & send test massage.