import 'package:flutter/material.dart';
import 'package:glance/glance.dart';
import 'package:weather/services/services_service.dart';
import '../models/weather.dart';

class WeatherHomeWidgetProvider extends GlanceAppWidgetProvider {
  @override
  Future<Widget> buildWidget(BuildContext context) async {
    final weatherService =
        weather_service(apiKey: "f2e5a934bf6e77754ad4c5c1521c0f96");

    // Fetch the weather for a default city
    Weather weather =
        await weatherService.get_weather('Bujumbura'); // Example city

    return WeatherWidget(weather: weather);
  }
}

class WeatherWidget extends StatelessWidget {
  final Weather weather;

  WeatherWidget({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weather.cityName,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            "${weather.temperature.round()}°C",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            weather.mainCondition,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
