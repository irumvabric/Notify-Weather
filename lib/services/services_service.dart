import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

import 'package:geolocator/geolocator.dart';

class weather_service {
  static const String BASE_URL =
      "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  weather_service({required this.apiKey});

  Future<Weather> get_weather(String cityname) async {
    final response = await http
        .get(Uri.parse("$BASE_URL?q=$cityname&appid=$apiKey&units=metric"));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<String> get_Location() async {
    // Get allow location permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Fetch current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //return position.toString();

    // Convert  the location to a list of placemark objets

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract the city from the placemark object

    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
