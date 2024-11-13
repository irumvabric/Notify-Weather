import 'package:flutter/material.dart';
import 'package:weather/pages/home_screen.dart';
import 'package:weather/services/weather_service.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  bool _isLoading = false;
  Map<String, dynamic>? _currentWeather;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() => _isLoading = true);
    try {
      // Get current location
      final position = await _weatherService.getCurrentLocation();
      print('Location: ${position.latitude}, ${position.longitude}');

      // Get weather data
      final weatherData = await _weatherService.getWeatherData(
        position.latitude,
        position.longitude,
      );

      // Save to Firestore
      await _weatherService.saveWeatherData(weatherData);

      setState(() => _currentWeather = weatherData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Home_Screen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadWeatherData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentWeather == null
              ? Center(child: Text('No weather data available'))
              : _buildWeatherDisplay(),
    );
  }

  Widget _buildWeatherDisplay() {
    final weather = _currentWeather!;
    final temp = weather['main']['temp'].round();
    final condition = weather['weather'][0]['main'];
    final humidity = weather['main']['humidity'];
    final windSpeed = weather['wind']['speed'];

    return RefreshIndicator(
      onRefresh: _loadWeatherData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                weather['name'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20),
              _buildWeatherIcon(weather['weather'][0]['icon']),
              Text(
                '$temp°C',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                condition,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 20),
              _buildWeatherDetails(humidity, windSpeed),
              SizedBox(height: 20),
              _buildSavedWeatherList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherIcon(String iconCode) {
    return Image.network(
      'https://openweathermap.org/img/w/$iconCode.png',
      scale: 0.5,
    );
  }

  Widget _buildWeatherDetails(int humidity, double windSpeed) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Icon(Icons.water_drop),
              Text('Humidity'),
              Text('$humidity%'),
            ],
          ),
          Column(
            children: [
              Icon(Icons.wind_power),
              Text('Wind Speed'),
              Text('${windSpeed.toStringAsFixed(1)} m/s'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavedWeatherList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _weatherService.getSavedWeatherData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final docs = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Weather History',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                return _buildWeatherHistoryItem(data, docs[index].id);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeatherHistoryItem(Map<String, dynamic> data, String docId) {
    final timestamp = (data['timestamp'] as Timestamp).toDate();
    final formattedDate = DateFormat('MMM d, y HH:mm').format(timestamp);

    return Card(
      child: ListTile(
        leading: _buildWeatherIcon(data['icon']),
        title: Text(data['location_name']),
        subtitle: Text(
            '$formattedDate\n${data['temperature']}°C, ${data['condition']}'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _weatherService.deleteWeatherData(docId),
        ),
      ),
    );
  }
}
