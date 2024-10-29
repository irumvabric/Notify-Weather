import 'package:flutter/material.dart';
import 'package:notifyweather/routes.dart';
import 'package:notifyweather/screens/Sign_up_screen.dart';
// import 'screens/login_screen.dart'; // for social icons
// import 'screens/Sign_up_screen.dart'; // for social icons
import 'screens/home_screen.dart'; //
import 'assets/theme/theme.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notify Weather',
      theme: AppTheme.lightTheme, // Use the theme defined in theme.dart
      darkTheme: AppTheme.darkTheme,

      debugShowCheckedModeBanner: false,
      initialRoute: '/Home',
      onGenerateRoute: (route) => onGeneratedRoute(route),
      navigatorKey: navigatorKey,

      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const LoginScreen(),
      //   '/signup': (context) => const SignUpScreen(),
      //   '/home': (context) => const HomeScreen(), // Define your home screen
      // },

      home: const SignUpScreen(),
    );
  }
}
