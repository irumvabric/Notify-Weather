import 'package:flutter/material.dart';
import '../models/weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather/services/services_service.dart';

class Forecast_Screen extends StatefulWidget {
  const Forecast_Screen({super.key});

  @override
  State<Forecast_Screen> createState() => _Forecast_ScreenState();
}

class _Forecast_ScreenState extends State<Forecast_Screen> {
  bool _isLiked = false;
  Weather? _weatherData;
  TextEditingController _searchController = TextEditingController();

  Future<void> _fetchWeatherData(String cityName) async {
    final weatherService =
        weather_service(apiKey: 'f2e5a934bf6e77754ad4c5c1521c0f96');
    Weather weather = await weatherService.get_weather(cityName);
    setState(() {
      _weatherData = weather;
    });
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
      body: Stack(
        children: [
          Text('Ok ok ok ok ok ok ok ok ok ok ok ok ok ok ok ok o'),
          if (_weatherData != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _buildBottomSheet(),
            )
        ],
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
