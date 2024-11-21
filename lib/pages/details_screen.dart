import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/weather.dart';
import 'package:weather/services/services_service.dart';

class WeatherDetailsView extends StatefulWidget {
  // final Weather weatherData;
  // final List<Weather> forecast;

  const WeatherDetailsView({super.key});

  @override
  State<WeatherDetailsView> createState() => _WeatherDetailsViewState();
}

class _WeatherDetailsViewState extends State<WeatherDetailsView> {
  final _weather_Service_current =
      weather_service(apiKey: "f2e5a934bf6e77754ad4c5c1521c0f96");
  final _weather_Service_forecast =
      weather_service(apiKey: "f85ba90750234215936103831243110");
  late Future<Map<String, dynamic>> weatherForecast;

  List<Weather> _forecast = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    weatherForecast =
        _weather_Service_current.fetchWeatherForecast(-3.38193, 29.36142);
  }

  IconData _getWeatherIcon(String condition) {
    // Customize based on your weather condition strings
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.water_drop;
      case 'storm':
        return Icons.thunderstorm;
      default:
        return Icons.cloud;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for the graph - replace with actual historical data
    final List<FlSpot> spots = [
      FlSpot(0, 700),
      FlSpot(1, 500),
      FlSpot(2, 600),
      FlSpot(3, 800),
      FlSpot(4, 850),
      FlSpot(5, 600),
      FlSpot(6, 650),
      FlSpot(7, 700),
      FlSpot(8, 900),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Details'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Current Weather Card
            Container(
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
                    "widget.weatherData.cityName",
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
                          Icon(
                            Icons.thermostat,
                            color: Colors.white,
                            size: 32,
                          ),
                          SizedBox(width: 8),
                          Text(
                            // '${widget.weatherData.temperature}°C',
                            '20 °C',
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.water_drop,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '50 %',
                                // '${widget.weatherData.humidity}%',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.air,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                // '${widget.weatherData.windspeed} km/h',
                                '20 km/h',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Historical Weather Graph
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(2011 + value.toInt()).toString()}',
                            style: TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 2,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),

            FutureBuilder<Map<String, dynamic>>(
              future: weatherForecast,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  final forecastList = snapshot.data!['list'] as List;

                  return ListView.builder(
                    itemCount: forecastList.length,
                    itemBuilder: (context, index) {
                      final forecast = forecastList[index];
                      final dateTime = DateTime.parse(forecast['dt_txt']);
                      final temperature = forecast['main']['temp'];
                      final humidity = forecast['main']['humidity'];
                      final description = forecast['weather'][0]['description'];
                      final icon = forecast['weather'][0]['icon'];

                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: Image.network(
                              "http://openweathermap.org/img/wn/$icon@2x.png"),
                          title: Text(
                            "${dateTime.day}/${dateTime.month} ${dateTime.hour}:00",
                          ),
                          subtitle: Text(description),
                          trailing: Column(children: [
                            Text("${temperature.toStringAsFixed(1)}°C"),
                            Text("${humidity.toStringAsFixed(1)} %"),
                          ]),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
