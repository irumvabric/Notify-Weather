import 'package:flutter/material.dart';
import 'package:weather/pages/Profile_Screen.dart';
import 'package:weather/pages/forecast_screen.dart';
import 'package:weather/pages/login_screen.dart';
import 'package:weather/pages/maps_screen.dart';
import 'package:weather/pages/weatherscreen.dart';

class Home_Screen extends StatefulWidget {
  Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  int _selectIndex = 0;

  void _navigator(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  List _pages = [
    Weather_screen(),
    Map_Screen(),
    Forecast_Screen(),
    Profile_Screen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed, // Shifting
            backgroundColor: Theme.of(context).primaryColor,
            fixedColor: Theme.of(context).dialogBackgroundColor,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: "Forecast"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Personalisation"),
            ],
            currentIndex: _selectIndex,
            onTap: _navigator),
        body: _pages[_selectIndex]);
  }
}
