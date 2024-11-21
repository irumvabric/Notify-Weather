// lib/home_widget_helper.dart
import 'package:home_widget/home_widget.dart';
import 'models/weather.dart';

void updateWeatherWidget(Weather weather) {
  HomeWidget.saveWidgetData<String>('city', weather.cityName);
  HomeWidget.saveWidgetData<String>('temp', '${weather.temperature}°C');
  HomeWidget.saveWidgetData<String>('icon', weather.weatherIcon);

  // Notify the widget to refresh-k
  HomeWidget.updateWidget(
    name:
        'WeatherWidgetProvider', // Name of the widget provider in AndroidManifest.xml
    androidName: 'WeatherWidgetProvider',
    iOSName: 'WeatherWidget',
  );
}
