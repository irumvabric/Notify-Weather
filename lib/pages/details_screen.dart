import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/weather.dart';
import 'package:weather/services/services_service.dart';

class WeatherDetailsScreen extends StatefulWidget {
  const WeatherDetailsScreen({super.key});

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  final weatherService =
      weather_service(apiKey: 'f2e5a934bf6e77754ad4c5c1521c0f96');
  Weather? currentWeather;
  List<dynamic>? forecastData;
  bool _isCelsius = true; // Temperature unit state
  bool _isLoading = false;
  String? _error;
  TextEditingController _searchController = TextEditingController();

  // Toggle between Celsius and Fahrenheit
  void _toggleTemperatureUnit() {
    setState(() {
      _isCelsius = !_isCelsius;
      if (currentWeather != null) {
        _fetchWeather(currentWeather!.cityName);
      }
    });
  }

  // Fetch both current weather and forecast
  Future<void> _fetchWeather(String cityName) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final current = await weatherService.get_weather(
          cityName, _isCelsius ? "metric" : "imperial");
      final forecast = await weatherService.fetchWeatherForecastUnits(
          23, 23, _isCelsius ? "metric" : "imperial");

      setState(() {
        currentWeather = current;
        forecastData = forecast['list'];
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
    _fetchWeather("Bujumbura"); // Default city
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for a city',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            _fetchWeather(value);
          },
        ),
        actions: [
          IconButton(
            icon: Text(_isCelsius ? '°C' : '°F',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            onPressed: _toggleTemperatureUnit,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text('Error: $_error',
                      style: TextStyle(color: Colors.red)))
              : currentWeather == null
                  ? Center(child: Text('No data available'))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildCurrentWeatherCard(),
                          _buildForecastList(),
                        ],
                      ),
                    ),
    );
  }

  // Current Weather Card
  Widget _buildCurrentWeatherCard() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentWeather!.cityName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.thermostat, color: Colors.white, size: 32),
                  SizedBox(width: 8),
                  Text(
                    '${currentWeather!.temperature.toStringAsFixed(1)} ${_isCelsius ? "°C" : "°F"}',
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.water_drop, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('${currentWeather!.humidity}%',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.air, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('${currentWeather!.windspeed} km/h',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Forecast List
  Widget _buildForecastList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: forecastData?.length ?? 0,
        itemBuilder: (context, index) {
          final forecast = forecastData![index];
          final dateTime = DateTime.parse(forecast['dt_txt']);
          final temperature = forecast['main']['temp'];
          final description = forecast['weather'][0]['description'];
          final icon = forecast['weather'][0]['icon'];

          return Card(
            color: Colors.blue[100],
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Image.network(
                  "http://openweathermap.org/img/wn/$icon@2x.png"),
              title:
                  Text('${dateTime.day}/${dateTime.month} ${dateTime.hour}:00'),
              subtitle: Text(description),
              trailing: Text(
                '${temperature.toStringAsFixed(1)} ${_isCelsius ? "°C" : "°F"}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
