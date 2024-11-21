// lib/widgets/weather_widget.dart
import 'package:flutter/material.dart';
import '../models/weather.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;

  const WeatherWidget({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E4289),
            Color(0xFF4B7BF5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // City Name
          Text(
            weather.cityName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),

          // Temperature
          Text(
            '${weather.temperature.toStringAsFixed(1)}°C',
            style: TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),

          // Weather Icon
          Image.network(
            'https://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png',
            width: 80,
            height: 80,
          ),
          SizedBox(height: 16),

          // // Weather Description
          // Text(
          //   weather.weatherDescription,
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 18,
          //     fontStyle: FontStyle.italic,
          //   ),
          // ),
          SizedBox(height: 16),

          // Additional Weather Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Wind Speed
              Column(
                children: [
                  Icon(Icons.air, color: Colors.white, size: 32),
                  Text(
                    '${weather.windspeed} km/h',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              // Humidity
              Column(
                children: [
                  Icon(Icons.water_drop, color: Colors.white, size: 32),
                  Text(
                    '${weather.humidity}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
