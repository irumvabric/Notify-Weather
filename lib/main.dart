import 'package:flutter/material.dart';
import 'package:notifyweather/routes.dart';
import 'package:notifyweather/screens/Sign_up_screen.dart';
// import 'screens/login_screen.dart'; // for social icons
// import 'screens/Sign_up_screen.dart'; // for social icons
import 'package:notifyweather/screens/home_screen.dart'; //
import 'package:notifyweather/screens/map.dart';
import 'assets/theme/theme.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectIndex = 0;

  void _navigator(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  List _pages = [HomeScreen(), map_Screen(), map_Screen(), map_Screen()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Notify Weather',
        theme: AppTheme.lightTheme, // Use the theme defined in theme.dart
        //darkTheme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/Home',
        onGenerateRoute: (route) => onGeneratedRoute(route),
        navigatorKey: navigatorKey,
        home: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.amberAccent,
                fixedColor: Colors.black,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.history), label: "Forecast"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: "Personalisation"),
                ],
                currentIndex: _selectIndex,
                onTap: _navigator),
            body: _pages[_selectIndex]));
  }
}
