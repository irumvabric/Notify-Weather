import 'package:flutter/material.dart';
import 'package:notifyweather/screens/Home_screen.dart';
import 'package:notifyweather/screens/Sign_up_screen.dart';
import 'package:notifyweather/screens/login_screen.dart';

Route onGeneratedRoute(RouteSettings settings) {
  return MaterialPageRoute(builder: (context) {
    switch (settings.name) {
      case '/screens/Home':
        return const HomeScreen();
      case '/screens/login':
        return const LoginScreen();
      case '/screens/signup':
        return const SignUpScreen();
      case '/screens/map':
        return const SignUpScreen();

      default:
        return const SignUpScreen();
    }
  });
}
