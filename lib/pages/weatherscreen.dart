import 'package:flutter/material.dart';
import 'package:weather/services/services_service.dart';
import 'package:lottie/lottie.dart';
import '../models/weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../WeatherWidget.dart';
import '../home_widget_helper.dart';

class Weather_screen extends StatefulWidget {
  const Weather_screen({super.key});

  @override
  State<Weather_screen> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<Weather_screen> {
  final _weather_Service =
      weather_service(apiKey: "f2e5a934bf6e77754ad4c5c1521c0f96");
  Weather? _weatherData;
  bool _isLoading = false;
  String? _error;
  TextEditingController _searchController = TextEditingController();
  bool _isLiked = false;

  Future<void> _fetchWeatherData(String cityName) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weatherService =
          weather_service(apiKey: 'f2e5a934bf6e77754ad4c5c1521c0f96');
      Weather weather = await weatherService.get_weather(cityName, "metric");
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

  _fetchweather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      String nameCity = await _weather_Service.get_Location();
      final weather = await _weather_Service.get_weather(nameCity, "metric");
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
      updateWeatherWidget(weather);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print(e);
    }
  }

  String getAnimationByCondition(String? condition) {
    if (condition == null) return "assets/sun.json";

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
    _fetchweather();
  }

  void _saveWeatherData() async {
    await FirebaseFirestore.instance.collection('weather_likes').add({
      'location': _weatherData?.cityName,
      'temperature': _weatherData?.temperature,
      'liked': _isLiked,
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _saveWeatherData();
      }
    });
  }

  // Convert your Weather model to WeatherModel
  Weather _convertToWeatherModel(Weather weather) {
    return Weather(
      cityName: weather.cityName,
      temperature: weather.temperature,
      mainCondition: weather.mainCondition ?? "Unknown",
      weatherIcon:
          "01d", // You might need to map your conditions to OpenWeather icons
      windspeed: weather.windspeed ?? 0.0,
      humidity: weather.humidity ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for a location',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            _fetchWeatherData(value);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchweather,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isLoading)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Loading weather data...")
                  ],
                ),
              )
            else if (_error != null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red),
                    SizedBox(height: 16),
                    Text(_error!, style: TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: _fetchweather,
                      child: Text("Retry"),
                    )
                  ],
                ),
              )
            else if (_weatherData != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Weather Widget
                      WeatherWidget(
                        weather: _convertToWeatherModel(_weatherData!),
                      ),
                      // SizedBox(height: 20),
                      // // Lottie Animation
                      // Lottie.asset(
                      //   getAnimationByCondition(_weatherData?.mainCondition),
                      //   height: 200,
                      //   width: 200,
                      // ),

                      // // Like Button
                      // IconButton(
                      //   icon: Icon(
                      //       _isLiked ? Icons.favorite : Icons.favorite_border),
                      //   onPressed: _toggleLike,
                      //   color: _isLiked ? Colors.red : null,
                      // ),
                    ],
                  ),
                ),
              )
            else
              Center(
                child: Text("No weather data available"),
              ),
          ],
        ),
      ),
    );
  }
}
