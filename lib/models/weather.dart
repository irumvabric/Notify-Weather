class Weather {
  final String cityName;
  final double temperature;
  final String weatherIcon;
  final double windspeed;
  final double humidity;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.weatherIcon,
    required this.windspeed,
    required this.humidity,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      mainCondition: json['weather'][0]['main'],
      temperature: json['main']['temp'].toDouble(),
      weatherIcon: json['weather'][0]['icon'],
      windspeed: json['main']['humidity'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
    );
  }
}
