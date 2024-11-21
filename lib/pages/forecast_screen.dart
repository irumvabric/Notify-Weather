import 'package:flutter/material.dart';
import 'package:weather/services/services_service.dart';

class WeatherForecastScreen extends StatefulWidget {
  @override
  _WeatherForecastScreenState createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  late Future<Map<String, dynamic>> weatherForecast;
  final weather_service weatherService =
      weather_service(apiKey: 'f2e5a934bf6e77754ad4c5c1521c0f96');
  @override
  void initState() {
    super.initState();
    weatherForecast = weatherService.fetchWeatherForecast(
        -3.38193, 29.36142); // Your latitude and longitude
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Forecast"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
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
              scrollDirection: Axis.vertical,
              itemCount: forecastList.length,
              itemBuilder: (context, index) {
                final forecast = forecastList[index];
                final dateTime = DateTime.parse(forecast['dt_txt']);
                final temperature = forecast['main']['temp'];
                final humidity = forecast['main']['humidity'];
                final description = forecast['weather'][0]['description'];
                final icon = forecast['weather'][0]['icon'];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(
                        "http://openweathermap.org/img/wn/$icon@2x.png"),
                    title: Text(
                      "${dateTime.day}/${dateTime.month} ${dateTime.hour}:00",
                    ),
                    subtitle: Text(description),
                    trailing: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Text("${temperature.toStringAsFixed(1)}°C"),
                        Text("${humidity.toStringAsFixed(1)} %"),
                      ]),
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
