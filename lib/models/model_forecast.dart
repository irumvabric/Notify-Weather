import 'dart:convert';

class Condition {
  final String text;
  final String icon;
  final int? code;

  Condition({required this.text, required this.icon, this.code});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'],
      icon: json['icon'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'icon': icon,
        'code': code,
      };
}

class Hour {
  final int timeEpoch;
  final String time;
  final double tempC;
  final int isDay;
  final Condition condition;
  final double windKph;
  final double precipMm;
  final int humidity;

  Hour({
    required this.timeEpoch,
    required this.time,
    required this.tempC,
    required this.isDay,
    required this.condition,
    required this.windKph,
    required this.precipMm,
    required this.humidity,
  });

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      timeEpoch: json['time_epoch'],
      time: json['time'],
      tempC: json['temp_c'].toDouble(),
      isDay: json['is_day'],
      condition: Condition.fromJson(json['condition']),
      windKph: json['wind_kph'].toDouble(),
      precipMm: json['precip_mm'].toDouble(),
      humidity: json['humidity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'time_epoch': timeEpoch,
        'time': time,
        'temp_c': tempC,
        'is_day': isDay,
        'condition': condition.toJson(),
        'wind_kph': windKph,
        'precip_mm': precipMm,
        'humidity': humidity,
      };
}

class Day {
  final double maxtempC;
  final double maxwindKph;
  final double totalprecipMm;
  final int avghumidity;
  final Condition condition;

  Day({
    required this.maxtempC,
    required this.maxwindKph,
    required this.totalprecipMm,
    required this.avghumidity,
    required this.condition,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxtempC: json['maxtemp_c'].toDouble(),
      maxwindKph: json['maxwind_kph'].toDouble(),
      totalprecipMm: json['totalprecip_mm'].toDouble(),
      avghumidity: json['avghumidity'],
      condition: Condition.fromJson(json['condition']),
    );
  }

  Map<String, dynamic> toJson() => {
        'maxtemp_c': maxtempC,
        'maxwind_kph': maxwindKph,
        'totalprecip_mm': totalprecipMm,
        'avghumidity': avghumidity,
        'condition': condition.toJson(),
      };
}

class ForecastDay {
  final String date;
  final int dateEpoch;
  final Day day;
  final List<Hour> hour;

  ForecastDay({
    required this.date,
    required this.dateEpoch,
    required this.day,
    required this.hour,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      dateEpoch: json['date_epoch'],
      day: Day.fromJson(json['day']),
      hour: (json['hour'] as List).map((h) => Hour.fromJson(h)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'date_epoch': dateEpoch,
        'day': day.toJson(),
        'hour': hour.map((h) => h.toJson()).toList(),
      };
}

class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final int localtimeEpoch;
  final String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      tzId: json['tz_id'],
      localtimeEpoch: json['localtime_epoch'],
      localtime: json['localtime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'region': region,
        'country': country,
        'lat': lat,
        'lon': lon,
        'tz_id': tzId,
        'localtime_epoch': localtimeEpoch,
        'localtime': localtime,
      };
}

class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      forecastday: (json['forecastday'] as List)
          .map((fd) => ForecastDay.fromJson(fd))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'forecastday': forecastday.map((fd) => fd.toJson()).toList(),
      };
}

class WeatherResponse {
  final Location location;
  final Map<String, dynamic> current;
  final Forecast forecast;

  WeatherResponse({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      location: Location.fromJson(json['location']),
      current: json['current'],
      forecast: Forecast.fromJson(json['forecast']),
    );
  }

  Map<String, dynamic> toJson() => {
        'location': location.toJson(),
        'current': current,
        'forecast': forecast.toJson(),
      };
}

// Example Usage
void main() {
  final jsonData = {
    'location': {
      'name': 'New York',
      'region': 'New York City',
      'country': 'United States',
      'lat': 40.7128,
      'lon': -74.0060,
      'tz_id': 'America/New_York',
      'localtime_epoch': 1640995200,
      'localtime': '2022-01-01 12:00:00',
    },
    'current': {
      'temp_c': 25.0,
      'is_day': 1,
      'condition': {
        'text': 'Sunny',
        'icon': '//cdn.weatherapi.com/weather/64x64/day/113.png',
        'code': 1000
      },
    }
  };

  WeatherResponse weatherResponse = WeatherResponse.fromJson(jsonData);
  print(weatherResponse.location.name);
}
