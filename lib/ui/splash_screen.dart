import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash_screen';

  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _splashScreenHandler();
  }

  void _splashScreenHandler() {
    Future.delayed(Duration(seconds: 3)).then((_) =>
        Navigator.pushReplacementNamed(context, HomePage.routeName)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/ic_launcher_round.png',
          width: 96,
          height: 96,
        ),
      ),
    );
  }
}