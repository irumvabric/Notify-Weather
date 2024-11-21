import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/services/services_service.dart';
import '../models/weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather/pages/details_screen.dart';

class Map_Screen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<Map_Screen> {
  late GoogleMapController _mapController;
  TextEditingController _searchController = TextEditingController();
  late LatLng _currentPosition = LatLng(-3.38229, 29.3644);
  Weather? _weatherData;
  bool _isLiked = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
  }

  Future<void> _fetchWeatherData(String cityName) async {
    final weatherService =
        weather_service(apiKey: 'f2e5a934bf6e77754ad4c5c1521c0f96');
    Weather weather = await weatherService.get_weather(cityName, "metric");
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

  Future<void> _navigateToDetails() async {
    if (_weatherData != null) {
      final weatherService =
          weather_service(apiKey: 'f2e5a934bf6e77754ad4c5c1521c0f96');
      // final historicalData = await weatherService.getHistoricalData(
      //     _currentPosition.latitude, _currentPosition.longitude, 7, "metric");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherDetailsView(
              // Replace with actual forecast data if needed
              ),
        ),
      );
    }
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 12,
                  ),
                  markers: _weatherData != null
                      ? {
                          Marker(
                            markerId: MarkerId("weather_marker"),
                            position: _currentPosition,
                            infoWindow: InfoWindow(
                              title: "${_weatherData?.temperature}°C",
                              snippet: _weatherData?.mainCondition,
                            ),
                          ),
                        }
                      : {},
                ),
                if (_weatherData != null)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: _buildBottomSheet(),
                  ),
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
                onPressed: _navigateToDetails,
                child: Text("Details"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
