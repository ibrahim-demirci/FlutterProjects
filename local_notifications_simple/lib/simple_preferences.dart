import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SimplePreferences {
  static SharedPreferences? _preferences;

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future<bool> setDate(DateTime datetime) async {
    log(datetime.toString());
    var result = await _preferences!.setString('lastNotification', datetime.toString());

    return result;
  }

  static String? getDate() => _preferences!.getString('lastNotification');
}
