import 'dart:convert';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'key1',
        channelName: 'Proto Coders Point',
        channelDescription: 'Notification Example',
        defaultColor: Colors.red,
        ledColor: Colors.white,
        enableLights: true,
        enableVibration: true,
      )
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    log('init state');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('widget build');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  notify();
                },
                child: const Icon(Icons.circle_notifications)),
            ElevatedButton(
                onPressed: () {
                  cancel();
                },
                child: const Icon(Icons.circle_notifications)),
            ElevatedButton(
                onPressed: () async {
                  var str = await rootBundle.loadString('assets/dates.json');
                  var data = jsonDecode(str);
                  var list = [];
                  var now = DateTime.now();

                  for (var i = 0; i < 3; i++) {
                    log('${now.year}-${now.month}-${now.day + i}');
                    list.add(data['${now.year}-${now.month}-${now.day + i}']['time1']);
                  }
                  log(list.toString());

                  // notifyThreeTimes(list);
                },
                child: const Icon(Icons.date_range)),
          ],
        ),
      ),
    );
  }

  void notifyThreeTimes(List<dynamic> list) async {
    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

    var now = DateTime.now();
    var scheduleTime = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second + 10);
    log(scheduleTime.toString());

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: '2021, 11, 2, 17, 00, 0',
        body: 'This notification was schedule to repeat at every single minute at clock.',
      ),
      schedule: NotificationCalendar.fromDate(date: scheduleTime),
      // schedule: NotificationInterval(interval: 5, timeZone: localTimeZone, repeats: true),
    );
  }

  void cancel() async {
    AwesomeNotifications().cancelNotificationsByChannelKey('key1');
  }

  void notify() async {
    // await AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: 1,
    //     channelKey: 'key1',
    //     title: 'This is notification title',
    //     body: 'This is body',
    //   ),
    // );

    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    // String utcTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

    // DateTime schedule = DateTime(2021, 11, 2, 17, 00, 0);
    // DateTime schedule1 = DateTime(2021, 11, 3, 05, 00, 0);
    // DateTime schedule2 = DateTime(2021, 11, 3, 17, 00, 0);
    // DateTime schedule3 = DateTime(2021, 11, 4, 05, 00, 0);

    // var date = DateTime.now().add(Duration(minutes: 5));

    // log(localTimeZone.toString());
    // log(schedule.toString());
    // log(date.toString());

    // await AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: 1,
    //     channelKey: 'key1',
    //     title: '2021, 11, 2, 17, 00, 0',
    //     body: 'This notification was schedule to repeat at every single minute at clock.',
    //   ),
    //   schedule: NotificationCalendar.fromDate(date: schedule),
    // );

    // schedule = schedule.add(
    //   const Duration(hours: 12),
    // );

    var date = DateTime(2021, 11, 7, 23, 52, 0);

    var now = DateTime.now();
    if (date.difference(now).isNegative) {
      log(date.difference(now).inDays.toString());
      log('son bildirim tarihi geçmiş yenilencek');
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: '2021, 11, 2, 17, 00, 0',
        body: 'This notification was schedule to repeat at every single minute at clock.',
      ),
      schedule: NotificationInterval(interval: 5, timeZone: localTimeZone, repeats: true),
    );

    // log(date.difference(now).toString());
  }
}
