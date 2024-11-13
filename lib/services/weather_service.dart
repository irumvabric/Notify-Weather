import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeatherService {
  final String apiKey =
      'AIzaSyCxEyWHL7Lnowaa-p0K9eGCXOIq2SBpGmg'; // OpenWeatherMap API key
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current location
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  // Fetch weather data from API
  Future<Map<String, dynamic>> getWeatherData(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Save weather data to Firestore
  Future<void> saveWeatherData(Map<String, dynamic> weatherData) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore.collection('weather_data').add({
      'user_id': user.uid,
      'location_name': weatherData['name'],
      'temperature': weatherData['main']['temp'],
      'humidity': weatherData['main']['humidity'],
      'wind_speed': weatherData['wind']['speed'],
      'condition': weatherData['weather'][0]['main'],
      'description': weatherData['weather'][0]['description'],
      'icon': weatherData['weather'][0]['icon'],
      'timestamp': FieldValue.serverTimestamp(),
      'coordinates': {
        'latitude': weatherData['coord']['lat'],
        'longitude': weatherData['coord']['lon'],
      },
    });
  }

  // Get user's saved weather data
  Stream<QuerySnapshot> getSavedWeatherData() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('weather_data')
        .where('user_id', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Delete saved weather data
  Future<void> deleteWeatherData(String documentId) async {
    await _firestore.collection('weather_data').doc(documentId).delete();
  }

  // Get weather history for a specific location
  Stream<QuerySnapshot> getLocationHistory(String locationName) {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('weather_data')
        .where('user_id', isEqualTo: user.uid)
        .where('location_name', isEqualTo: locationName)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
