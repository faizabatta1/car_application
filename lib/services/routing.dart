import 'package:car_app/screens/MainScreen.dart';
import 'package:car_app/screens/car_number_choice.dart';
import 'package:car_app/screens/map_screen.dart';
import 'package:car_app/screens/terms_screen.dart';
import 'package:car_app/screens/violations_details.dart';
import 'package:flutter/material.dart';

import '../screens/notifications_screen.dart';


class HomeRouter{
  static Route<dynamic> generatedRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (context) => MainScreen());

      case NotificationsScreen.route:
        return MaterialPageRoute(builder: (context) => NotificationsScreen());


      case TermsScreen.route:
        return MaterialPageRoute(builder: (context) => TermsScreen());

      case ViolationsDetails.route:
        return MaterialPageRoute(builder: (context) => ViolationsDetails());

      case MapsScreen.route:
        return MaterialPageRoute(builder: (context) => MapsScreen());

      case CarNumberChoiceScreen.route:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return CarNumberChoiceScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
              ),
              child: child,
            );
          },
          transitionDuration: Duration(seconds: 1),
        );
      default:
        return MaterialPageRoute(builder: (context) => Container());
    }
  }
}