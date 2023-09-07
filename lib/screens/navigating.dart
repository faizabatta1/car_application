import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/MainScreen.dart';
import 'package:car_app/screens/map_screen.dart';
import 'package:car_app/screens/terms_screen.dart';
import 'package:car_app/screens/violations_details.dart';
import 'package:car_app/services/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class NavigatingScreen extends StatefulWidget {
  const NavigatingScreen({Key? key}) : super(key: key);

  @override
  State<NavigatingScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<NavigatingScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    bool _showExitSnackbar = false;

    return WillPopScope(
      onWillPop: () async{
        if (navigatorKey.currentState!.canPop()) {
          navigatorKey.currentState!.pop();
          return false;
        } else {
          if (_showExitSnackbar) {
            SystemNavigator.pop();
            return true;
          } else {
            _showExitSnackbar = true;
            _showExitSnackbarSnackbar();
            SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
              Future.delayed(Duration(seconds: 5), () {
                setState(() {
                  _showExitSnackbar = false;
                });
              });
            });
            return false;
          }
        }
      },
      child: Scaffold(
        body: Navigator(
          key: navigatorKey,
          onGenerateRoute: HomeRouter.generatedRoute,
        ),
      ),
    );
  }

  void _showExitSnackbarSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Are you sure you want to exit the app"),
        duration: Duration(seconds: 5),
      ),
    );
  }
}
