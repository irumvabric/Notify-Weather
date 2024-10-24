import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // for social icons
import 'screens/home_screen.dart'; //
import 'assets/theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login/Sign Up',
      theme: AppTheme.lightTheme, // Use the theme defined in theme.dart
      darkTheme: AppTheme.darkTheme,
      home: LoginScreen(),
    );
  }
}
