import 'dart:async';

import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/LoginScreen.dart';
import 'package:flutter/material.dart';

import 'MainScreen.dart';
import 'home_screen.dart';


class SplashScreen extends StatefulWidget {
  final String? token;
  const SplashScreen({super.key,required this.token});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2),(){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => widget.token == null ? SignInScreen() : MainScreen())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ThemeHelper.buttonPrimaryColor,
        alignment: Alignment.center,
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
