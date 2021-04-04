import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferenceHelper({@required this.sharedPreferences});

  static const DARK_THEME = 'DARK_THEME';
  static const ALARM_NOTIF = 'ALARM_NOTIFS';

  Future<bool> get isDarkTheme async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DARK_THEME) ?? false;
  }

  void setDarkTheme(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DARK_THEME, value);
  }

  Future<bool> get isNotificationActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(ALARM_NOTIF) ?? false;
  }

  void setNotification(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(ALARM_NOTIF, value);
  }
}