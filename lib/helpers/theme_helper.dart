import 'package:flutter/material.dart';

class ThemeHelper{
  static Color primaryColor = Colors.blue;
  static Color secondaryColor = Colors.blueGrey;

  static Color scaffoldColor = Colors.black12;

  static Color buttonPrimaryColor = const Color(0xFF123456);
  static TextStyle primaryButtonTextStyle = const TextStyle(
    fontSize: 20
  );

  static get primaryButtonStyle => _primaryButtonStyle();

  static ButtonStyle _primaryButtonStyle(){
    return ElevatedButton.styleFrom(
      backgroundColor: buttonPrimaryColor,
      minimumSize: const Size(200,50),
      textStyle: primaryButtonTextStyle
    );
  }
}