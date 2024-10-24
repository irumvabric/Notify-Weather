import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherData _weatherData = WeatherData(
    locationName: 'Loading...',
    temperature: 0.0,
    humidity: 0,
    windSpeed: 0.0,
    condition: 'Loading...',
    timestamp: DateTime.now(),
  );
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    // TODO: Implement API call to fetch weather data
    await Future.delayed(const Duration(seconds: 2)); // Simulated delay
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWeatherData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchWeatherData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLocationHeader(),
                      const SizedBox(height: 24),
                      _buildWeatherCard(),
                      const SizedBox(height: 24),
                      _buildForecastList(),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Forecast',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          // TODO: Implement navigation
        },
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _weatherData.locationName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              DateFormat('EEEE, MMMM d').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.location_on),
          onPressed: () {
            // TODO: Implement location selection
          },
        ),
      ],
    );
  }

  Widget _buildWeatherCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_weatherData.temperature.round()}°C',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Text(
                      _weatherData.condition,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const Icon(
                  Icons.cloud,
                  size: 64,
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfo(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${_weatherData.humidity}%',
                ),
                _buildWeatherInfo(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '${_weatherData.windSpeed} km/h',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 8),
        Text(label),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildForecastList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hourly Forecast',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 24,
            itemBuilder: (context, index) {
              final hour = DateTime.now().add(Duration(hours: index));
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('HH:mm').format(hour)),
                      const Icon(Icons.cloud),
                      Text('${(_weatherData.temperature + index).round()}°C'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class WeatherData {
  final String locationName;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String condition;
  final DateTime timestamp;

  WeatherData({
    required this.locationName,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.timestamp,
  });
}
