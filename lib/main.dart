import 'package:flutter/material.dart';
import 'package:weather/pages/home_screen.dart';
import 'package:weather/pages/login_screen.dart';
import 'package:weather/pages/weatherscreen.dart';
import 'package:weather/pages/original_screen_weather.dart';
import 'package:weather/pages/register_screen.dart';
import 'package:weather/services/weather_service_old.dart';
import 'package:weather/ui_settings/themes.dart';
import 'package:weather/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyTheme.light,
      darkTheme: MyTheme.dark,
      themeMode: ThemeMode.light,
      initialRoute: '/home', // Set initial route to login screen
      routes: {
        '/home': (context) => Home_Screen(),
        '/weather': (context) => const WeatherPage(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
