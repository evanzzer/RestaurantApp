import 'package:flutter/material.dart';

class ThemeSelector {
  ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  ThemeData darkTheme = ThemeData(brightness: Brightness.dark);
}