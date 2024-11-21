import 'package:flutter/material.dart';
import 'package:weather/services/services_service.dart';
import 'package:lottie/lottie.dart';
import '../models/weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherScreen> {
  final _weatherService =
      weather_service(apiKey: "f2e5a934bf6e77754ad4c5c1521c0f96");
  Weather? _weatherData;
  bool _isLoading = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  bool _isCelsius = true; // Toggle between Celsius and Fahrenheit

  Future<void> _fetchWeatherData(String cityName) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      Weather weather = await _weatherService.get_weather(
          cityName, _isCelsius ? "metric" : "imperial");
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherByLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      String cityName = await _weatherService.get_Location();
      Weather weather = await _weatherService.get_weather(
          cityName, _isCelsius ? "metric" : "imperial");
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeatherByLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
              hintText: 'Search for a location',
              prefixIcon: Icon(Icons.search),
              fillColor: Color(0xFF1E4289)),
          onSubmitted: (value) {
            _fetchWeatherData(value);
          },
        ),
        actions: [
          // Temperature Unit Toggle
          IconButton(
            icon: Text(
              _isCelsius ? '°C' : '°F',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                _isCelsius = !_isCelsius;
                if (_weatherData != null) {
                  _fetchWeatherByLocation(); // Refresh weather data
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWeatherByLocation,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(_error!,
                            style: const TextStyle(color: Colors.red)),
                        ElevatedButton(
                          onPressed: _fetchWeatherByLocation,
                          child: const Text("Retry"),
                        )
                      ],
                    ),
                  )
                : _weatherData != null
                    ? WeatherWidget(
                        weather: _weatherData!,
                        isCelsius: _isCelsius,
                      )
                    : const Center(
                        child: Text("No weather data available"),
                      ),
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  final bool isCelsius;

  const WeatherWidget(
      {Key? key, required this.weather, required this.isCelsius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Temperature
          Text(
            '${weather.temperature.toStringAsFixed(1)} ${isCelsius ? "°C" : "°F"}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Weather Icon
          Image.network(
            'https://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 16),

          // Additional Weather Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Wind Speed
              Column(
                children: [
                  const Icon(Icons.air, color: Colors.white, size: 32),
                  Text(
                    '${weather.windspeed.toStringAsFixed(1)} km/h',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              // Humidity
              Column(
                children: [
                  const Icon(Icons.water_drop, color: Colors.white, size: 32),
                  Text(
                    '${weather.humidity}%',
                    style: const TextStyle(
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
