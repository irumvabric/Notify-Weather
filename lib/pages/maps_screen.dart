import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather.dart';
import '../services/services_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final weather_service _weatherService =
      weather_service(apiKey: 'f2e5a934bf6e77754ad4c5c1521c0f96');

  Map<MarkerId, Marker> _markers = {};
  LatLng _currentPosition = LatLng(-3.38229, 29.3644);
  Weather? _selectedWeather;
  bool _isLoading = true;
  bool _isCelsius = true;
  bool _isWeatherLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      _addMarkerAtPosition(_currentPosition, "Current Location");
    } catch (e) {
      print('Error getting location: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleMapTap(LatLng position) async {
    setState(() => _isWeatherLoading = true);

    try {
      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String locationName = placemarks.first.locality ??
          placemarks.first.subAdministrativeArea ??
          'Unknown Location';

      // Get weather for tapped location using corrected coordinates format
      Weather weather = await _weatherService.get_weather_lat_long(
          position.latitude.toString(),
          position.longitude.toString(),
          _isCelsius ? "metric" : "imperial");

      // Add or update marker
      _addMarkerAtPosition(position, locationName, weather: weather);

      setState(() {
        _selectedWeather = weather;
        _isWeatherLoading = false;
      });

      // Show weather details bottom sheet
      _showWeatherDetails(weather);
    } catch (e) {
      print('Error fetching weather: $e'); // For debugging
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching weather data. Please try again.'),
        backgroundColor: Colors.red,
      ));
      setState(() => _isWeatherLoading = false);
    }
  }

  void _addMarkerAtPosition(LatLng position, String title, {Weather? weather}) {
    final markerId = MarkerId(position.toString());
    final marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(
        title: title,
        snippet: weather != null
            ? '${weather.temperature}°C, ${weather.mainCondition}'
            : 'Tap for weather',
      ),
      onTap: () {
        if (weather != null) {
          _showWeatherDetails(weather);
        }
      },
    );

    setState(() {
      _markers[markerId] = marker;
    });
  }

  void _showWeatherDetails(Weather weather) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weather.cityName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                WeatherInfoTile(
                  icon: Icons.thermostat,
                  label: 'Temperature',
                  value: '${weather.temperature}°C',
                ),
                WeatherInfoTile(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${weather.humidity}%',
                ),
                WeatherInfoTile(
                  icon: Icons.air,
                  label: 'Wind',
                  value: '${weather.windspeed} m/s',
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('weather_history')
                    .add({
                  'location': weather.cityName,
                  'temperature': weather.temperature,
                  'condition': weather.mainCondition,
                  'timestamp': DateTime.now(),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Weather data saved!')));
              },
              child: Text('Save to History'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Notify Map'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.history),
        //     onPressed: () {
        //       // Navigate to weather history screen
        //     },
        //   ),
        // ],
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 12,
                  ),
                  markers: Set<Marker>.of(_markers.values),
                  onTap: _handleMapTap,
                ),
          if (_isWeatherLoading)
            Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Fetching weather data...'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _getCurrentLocation,
      //   child: Icon(Icons.my_location),
      // ),
    );
  }
}

class WeatherInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
