import 'package:home_widget/home_widget.dart';
import 'package:weather/services/services_service.dart';
import '../models/weather.dart';

class WeatherWidgetHelper {
  final weather_service weatherService;

  WeatherWidgetHelper({required this.weatherService});

  Future<void> updateWeatherWidget() async {
    try {
      String city = await weatherService.get_Location();
      Weather weather = await weatherService.get_weather(city, "metric");

      // Update widget data
      await HomeWidget.saveWidgetData<String>('weather_city', city);
      await HomeWidget.saveWidgetData<String>(
          'weather_temp', '${weather.temperature.toStringAsFixed(1)}°C');

      // Trigger widget update
      await HomeWidget.updateWidget(
        androidName: 'HomeWeatherWidgetProvider',
        iOSName: 'HomeWeatherWidget',
      );
    } catch (e) {
      print('Error updating widget: $e');
    }
  }
}
