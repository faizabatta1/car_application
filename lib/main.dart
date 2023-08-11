import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString('token');

  runApp(AppEntryPoint(token: token));
}

class AppEntryPoint extends StatelessWidget {
  final String? token;
  const AppEntryPoint({super.key,required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BilSjekk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ThemeHelper.secondaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: ThemeHelper.secondaryColor,
        )
      ),

      home: SplashScreen(token: token),
    );
  }
}


