import 'package:flutter/material.dart';
import 'package:weather/pages/home_screen.dart';
import 'package:weather/pages/login_screen.dart';
import 'package:weather/pages/weatherscreen.dart';
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
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set text direction (optional, defaults to system locale)
      // You can remove this if you want to use system default
      locale: const Locale('en', 'US'),
      home: WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
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
      initialRoute: '/login', // Set initial route to login screen
      routes: {
        '/home': (context) => const Home_Screen(),
        '/login': (context) => LoginScreen(), // Add login route
        '/register': (context) => RegisterScreen(), // Add register route
      },
    );
  }
}
