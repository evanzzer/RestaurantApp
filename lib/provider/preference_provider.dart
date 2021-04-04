import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurant_app/common/style.dart';
import 'package:restaurant_app/data/preference/preference_helper.dart';

class PreferenceProvider extends ChangeNotifier {
  PreferenceHelper preferenceHelper;
  ThemeSelector _theme = new ThemeSelector();

  PreferenceProvider({@required this.preferenceHelper}) {
    _getTheme();
    _getNotifActive();
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  bool _isNotifActive = false;
  bool get isNotifActive => _isNotifActive;

  ThemeData get themeData => _isDarkTheme ? _theme.darkTheme : _theme.lightTheme;

  void _getTheme() async {
    _isDarkTheme = await preferenceHelper.isDarkTheme;
    notifyListeners();
  }

  void _getNotifActive() async {
    _isNotifActive = await preferenceHelper.isNotificationActive;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    preferenceHelper.setDarkTheme(value);
    _getTheme();
  }

  void toggleNotification(bool value) {
    preferenceHelper.setNotification(value);
    _getNotifActive();
  }
}