import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/model_forecast.dart';

import 'package:geolocator/geolocator.dart';

class weather_service {
  static const String BASE_URL =
      "https://api.openweathermap.org/data/2.5/weather";
  static const String FORECAST_URL =
      "http://api.weatherapi.com/v1/forecast.json?";

  final String apiKey;

  weather_service({required this.apiKey});

  Future<Weather> get_weather(String cityname, String temp) async {
    final response = await http
        .get(Uri.parse("$BASE_URL?q=$cityname&appid=$apiKey&units=$temp"));

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

  Future<List<Placemark>> get_Location_lat_long() async {
    // Get allow location permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Fetch current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //return position.toString();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return placemarks;
  }

  // Future<Weather> getWeatherByName(String cityName,
  //     {String countryCode = ""}) async {
  //   final query = countryCode.isNotEmpty ? "$cityName,$countryCode" : cityName;
  //   final response = await http
  //       .get(Uri.parse("$BASE_URL?q=$query&appid=$apiKey&units=metric"));

  //   if (response.statusCode == 200) {
  //     return Weather.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load weather');
  //   }
  // }

  // Future<Weather> getWeatherByCoordinates(
  //     double latitude, double longitude) async {
  //   final response = await http.get(Uri.parse(
  //       "$BASE_URL?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric"));

  //   if (response.statusCode == 200) {
  //     return Weather.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load weather');
  //   }
  // }

  // Future<List<FlSpot>> getHistoricalData(
  //     double latitude, double longitude, int days, String temp) async {
  //   final response = await http.get(Uri.parse(
  //       "https://api.openweathermap.org/data/2.5/onecall/timemachine"
  //       "?lat=$latitude&lon=$longitude&dt=${DateTime.now().subtract(Duration(days: days)).millisecondsSinceEpoch ~/ 1000}"
  //       "&appid=$apiKey&units=$temp"));

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return (data['hourly'] as List)
  //         .asMap()
  //         .entries
  //         .map((entry) => FlSpot(entry.key.toDouble(), entry.value['temp']))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to load historical data');
  //   }
  // }

  Future<WeatherResponse> getForecast(
      double latitude, double longitude, int days, String temp) async {
    final response = await http.get(Uri.parse(
        "$FORECAST_URL?key=$apiKey&q=$latitude,$longitude&days=$days"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherResponse.fromJson(data);
    } else {
      throw Exception('Failed to load forecast');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherForecast(
      double lat, double lon) async {
    const String apiKey = "f2e5a934bf6e77754ad4c5c1521c0f96";
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<Map<String, dynamic>> fetchWeatherForecastUnits(
      double lat, double lon, String units) async {
    const String apiKey = "f2e5a934bf6e77754ad4c5c1521c0f96";
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=$units");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}
