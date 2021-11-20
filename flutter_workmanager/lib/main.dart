import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() async {
  late var preferences;

  Workmanager().executeTask((task, inputData) async {
    if (task == 'uniqueKey') {
      SharedPreferences.getInstance().then((value) {
        preferences = value;
        String? lastDataDate = preferences.getString('lastDataAsGregorian');

        if (lastDataDate == null) {
          log('Veri daha önce yok bu yüzden çekilecek');
        } else {
          List<String> dateArray = lastDataDate.split('-');
          log(dateArray.toString());
          if (DateTime.now().isAfter(DateTime(
            int.parse(dateArray[2]),
            int.parse(dateArray[1]),
            int.parse(dateArray[0]),
          ))) {
            log('Verinin tarihi geçmiş');
          } else {
            log("Veri Güncel");
          }
        }
      });

      ///do the task in Backend for how and when to send notification
      ///
      ///

      // var response =
      //     await http.get(Uri.parse('https://api.aladhan.com/v1/calendar?latitude=41.017541&longitude=28.847969&method=13&month=11&year=2021'));
      // // log(json.decode(response.body));
      // log(json.decode((response.body as Map)['data']));
      // log(json.decode((response.body as Map)['data']));

      // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      // const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('your channel id', 'your channel name',
      //     channelDescription: 'your channel description', importance: Importance.max, priority: Priority.high, showWhen: false);
      // const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      // await flutterLocalNotificationsPlugin.show(
      //     0, dataComingFromTheServer['data']['first_name'], dataComingFromTheServer['data']['email'], platformChannelSpecifics,
      //     payload: 'item x');
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
  const MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  Workmanager().registerPeriodicTask(
    "1",
    "uniqueKey",
    frequency: const Duration(minutes: 15),
  );
  // Workmanager().cancelAll();
  // log('Task ended');
  runApp(MyApp());
}

Future selectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  SharedPreferences? sharedPreferences;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Notification in Background'),
      ),
      body: Row(
        children: [
          TextButton(
              child: const Text('Kaydet'),
              onPressed: () async {
                var response = await http
                    .get(Uri.parse('https://api.aladhan.com/v1/calendar?latitude=41.017541&longitude=28.847969&method=13&month=10&year=2021'));

                if (response.statusCode == 200) {
                  var map = jsonDecode(response.body);
                  // log((map['data'] as List).toString());
                  SharedPreferences.getInstance().then((sp) async {
                    var daysDataList = map['data'] as List;
                    log(daysDataList.last['date']['gregorian']['date']);

                    var res = await sp.setString("lastDataAsTimestamp", daysDataList.last['date']['timestamp']);
                    res = await sp.setString("lastDataAsGregorian", daysDataList.last['date']['gregorian']['date']);
                    if (res) {
                      log('LastDate Save Success');
                    } else {
                      log('LastDate Save Fail');
                    }
                  });
                } else {
                  log(response.statusCode.toString());
                }
              }),
          TextButton(
            child: const Text('Oku'),
            onPressed: () {
              if (sharedPreferences == null) {
                SharedPreferences.getInstance().then((sp) {
                  sharedPreferences = sp;
                  var lastDataDate = sharedPreferences!.getString('date');
                  log(lastDataDate.toString());
                });
              } else {
                log(sharedPreferences!.getString('date') ?? 'null');
                log(DateTime.now().year.toString() + DateTime.now().month.toString() + DateTime.now().day.toString());
              }
            },
          ),
          TextButton(
            onPressed: () {
              Workmanager().cancelAll();
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }
}
