import 'package:flutter/material.dart';
import 'package:weather/models/weather.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/services/services_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // get api key
  final _weather_Service =
      weather_service(apiKey: "f2e5a934bf6e77754ad4c5c1521c0f96");

  Weather? _weather;

  // fech weather

  _fetchweather() async {
    // get city name
    String nameCity = await _weather_Service.get_Location();

    // get weather of the city
    try {
      final weather = await _weather_Service.get_weather(nameCity);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animation

  String getAnimationByCondition(String? condition) {
    if (condition == null) return "assets/sun.json"; //Default to sunny

    switch (condition.toLowerCase()) {
      case "cloud":
        return "assets/cloud.json";
      case "fog":
        return "assets/cloud.json";
      case "rain":
        return "assets/rain.json";
      case "sunny":
        return "assets/sun.json";
      case "snow":
        return "assets/snow.json";
      case "shower rain":
        return "assets/rain.json";
      case "thunderstorm":
        return "assets/cloud_thunder.json";
      default:
        return "assets/sun.json";
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch data on startup
    _fetchweather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City name
            Text(_weather?.cityName ?? "Loading city .."),

            // Animation

            Lottie.asset(getAnimationByCondition(_weather?.mainCondition),
                height: 100, width: 100),

            // City name
            Text('${_weather?.temperature.round()}°C' ??
                "Loading Temperature .."),

            Text(_weather?.mainCondition ?? "Loading Condition .."),
          ],
        ),
      ),
    );
  }
}
