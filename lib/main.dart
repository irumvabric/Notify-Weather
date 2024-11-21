// Flutter Core Imports
import 'package:flutter/material.dart';

// Third-Party Package Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:weather/pages/details_screen.dart';
import 'package:workmanager/workmanager.dart';

// Project-Specific Imports
import 'package:weather/firebase_options.dart';
import 'package:weather/pages/home_screen.dart';
import 'package:weather/pages/login_screen.dart';
import 'package:weather/pages/register_screen.dart';
import 'package:weather/pages/forecast_screen.dart';
import 'package:weather/pages/maps_screen.dart';
import 'package:weather/pages/weatherscreen.dart';
import 'package:weather/pages/Profile_Screen.dart';
import 'package:weather/services/services_service.dart';
import 'package:weather/ui_settings/themes.dart';
import 'home_widget_helper.dart';

/// Background Task Dispatcher for WorkManager
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     print("Native called background task: $task");

//     // Handle widget updates specifically
//     if (task == "updateWeatherWidget") {
//       final weatherService =
//           weather_service(apiKey: 'f2e5a934bf6e77754ad4c5c1521c0f96');
//       final weatherWidgetHelper =
//           WeatherWidgetHelper(weatherService: weatherService);

//       // Update HomeWidget with weather data
//       await weatherWidgetHelper.updateWeatherWidget();
//       print("Weather widget updated in background.");
//     }

//     // Indicate the task completed successfully
//     return Future.value(true);
//   });
// }

/// Main Entry Point
Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize WorkManager for background tasks
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Register a periodic task for widget updates
  // Workmanager().registerPeriodicTask(
  //   "weatherUpdateTask", // Unique task name
  //   "updateWeatherWidget", // Task identifier
  //   frequency: Duration(seconds: 3600), // Update every hour
  // );

  // Run the Flutter app
  runApp(const MyApp());
}

/// Main Application Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyTheme.light, // Light theme
      darkTheme: MyTheme.dark, // Dark theme
      themeMode: ThemeMode.light, // Default theme mode
      initialRoute: '/home', // Set initial route to login screen
      routes: {
        '/home': (context) => Home_Screen(),
        '/details': (context) => WeatherDetailsScreen(),
        '/forecast': (context) => WeatherForecastScreen(),
        '/weather': (context) => const WeatherScreen(),
        '/maps': (context) => Map_Screen(),
        '/personalisation': (context) => Profile_Screen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
