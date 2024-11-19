import 'package:flutter/material.dart';
import 'package:weather/services/services_service.dart';
import 'package:lottie/lottie.dart';
import '../models/weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Weather_screen extends StatefulWidget {
  const Weather_screen({super.key});

  @override
  State<Weather_screen> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<Weather_screen> {
  // get api key
  final _weather_Service =
      weather_service(apiKey: "f2e5a934bf6e77754ad4c5c1521c0f96");
  Weather? _weatherData;
  Weather? _weather;
  TextEditingController _searchController = TextEditingController();
  bool _isLiked = false;

  Future<void> _fetchWeatherData(String cityName) async {
    final weatherService =
        weather_service(apiKey: 'f2e5a934bf6e77754ad4c5c1521c0f96');
    Weather weather = await weatherService.get_weather(cityName, "metric");
    setState(() {
      _weatherData = weather;
    });
  }

  // fech weather

  _fetchweather() async {
    // get city name
    String nameCity = await _weather_Service.get_Location();

    // get weather of the city
    try {
      final weather = await _weather_Service.get_weather(nameCity, "metric");
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City name
            Text(_weather?.cityName ?? "Loading city .."),

            // Animation

            Lottie.asset(getAnimationByCondition(_weather?.mainCondition),
                height: 200, width: 200),

            // City name
            Text('${_weather?.temperature.round()}°C' ??
                "Loading Temperature .."),

            Text(_weather?.mainCondition ?? "Loading Condition .."),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _weatherData?.cityName ?? "",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "${_weatherData?.temperature ?? ""}°C",
            style: TextStyle(fontSize: 18),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                onPressed: _toggleLike,
              ),
              ElevatedButton(
                onPressed: () {
                  // Add additional functionality if needed
                },
                child: Text("Details"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
