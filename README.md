## Flutter Weather App

### Overview
This project aims to create a comprehensive weather application using Flutter for the frontend and Django for the backend.

### Features
* **User authentication** with Google Sign-In
* **Real-time weather data** from OpenWeatherMap
* **Interactive map** using Google Maps
* **Data storage** in SqLite
* **Customization** options for units and widgets
* **History** of weather data

### Technology Stack
* **Frontend:** Flutter, Dart
* **Backend:** Django, Python, SqLite
* **APIs:** OpenWeatherMap, Google Maps Geocoding API

### Project Structure
#### Flutter
* **lib:**
    * **screens:** Contains all screens (login, home, settings, history).
    * **models:** Defines data models for weather data, user, etc.
    * **services:** Handles API calls and data fetching.
    * **utils:** Helper functions.
* **assets:** Stores images, icons, and other assets.

#### Django
* **weatherapp:**
    * **models:** Defines Django models (User, WeatherData).
    * **serializers:** Serializes models for API responses.
    * **views:** Handles API requests and returns JSON responses.
    * **urls:** Defines URL patterns.

### Development Steps
1. **Set up Django backend:**
   * Create a Django project and app.
   * Configure database (SqLite).
   * Create models and serializers.
   * Define API endpoints.
2. **Set up Flutter frontend:**
   * Create a Flutter project.
   * Integrate Google Sign-In.
   * Fetch weather data from the Django backend.
   * Display weather data using Flutter widgets.
   * Implement map functionality using `google_maps_flutter`.
   * Store user preferences and history.
3. **Deployment:**
   * Deploy the Django backend to a cloud platform (e.g., Heroku, AWS).
   * Deploy the Flutter frontend to a platform like Firebase or a custom server.

### Additional Considerations
* **Error handling:** Implement robust error handling for API calls and data fetching.
* **Caching:** Cache weather data to reduce API calls and improve performance.
* **Notifications:** Send notifications for weather alerts or significant changes.
* **Offline functionality:** Allow users to access cached data when offline.
* **Testing:** Write unit and integration tests to ensure code quality.

### Diagrams
* **Architecture diagram:** [Image of a diagram showing the interaction between the Flutter frontend and Django backend]
* **Sequence diagrams:** [Image of sequence diagrams illustrating the flow of data between components]

### Future Improvements
* **Dark mode:** Implement a dark theme for better user experience.
* **Widget marketplace:** Allow users to create and share custom widgets.
* **Machine learning:** Use machine learning to provide more accurate weather forecasts.

**Note:** This is a high-level overview of the project. You can customize and expand on this based on your specific requirements and preferences.

**Would you like to dive deeper into any specific part of the project?**

=====================

# Explanation

=====================

# Weather Application Documentation
## Tech Stack: Flutter + Django

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Features Implementation](#features-implementation)
4. [API Integration](#api-integration)
5. [Database Schema](#database-schema)
6. [Setup Instructions](#setup-instructions)

## Project Overview
A comprehensive weather application that provides real-time weather data, interactive maps, and personalized user experiences using Flutter for the frontend and Django for the backend.

## Architecture

### Frontend (Flutter)
```
lib/
├── models/
│   ├── user_model.dart
│   ├── weather_model.dart
│   └── location_model.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── weather/
│   │   ├── home_screen.dart
│   │   ├── map_screen.dart
│   │   └── forecast_screen.dart
│   └── settings/
│       └── preferences_screen.dart
├── services/
│   ├── auth_service.dart
│   ├── weather_service.dart
│   └── location_service.dart
└── widgets/
    ├── weather_card.dart
    ├── custom_map.dart
    └── forecast_chart.dart
```

### Backend (Django)
```
weather_project/
├── accounts/
│   ├── models.py
│   ├── views.py
│   └── urls.py
├── weather/
│   ├── models.py
│   ├── views.py
│   └── urls.py
└── config/
    ├── settings.py
    └── urls.py
```

## Features Implementation

### 1. User Authentication
- Email verification using Django's built-in authentication system
- Google Sign-In integration
- JWT token-based authentication

#### Django Implementation
```python
# accounts/models.py
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    email_verified = models.BooleanField(default=False)
    google_id = models.CharField(max_length=100, null=True, blank=True)
```

### 2. Real-time Weather Data
- Integration with OpenWeatherMap API
- Current weather conditions
- Hourly forecasts

#### API Endpoint
```
GET /api/weather/current/
Parameters:
- lat: float
- lon: float
```

### 3. Interactive Weather Map
- Google Maps integration
- Weather overlay
- Location selection

### 4. Historical Weather Data
#### SqLite Schema
```javascript
{
  user_id: ObjectId,
  location: {
    lat: Double,
    lon: Double
  },
  timestamp: DateTime,
  weather_data: {
    temperature: Double,
    conditions: String,
    humidity: Integer
  }
}
```

### 5. Customizable Widgets
- Home screen widgets
- Quick access weather information
- Configurable layouts

### 6. Unit Preferences
#### User Preferences Model
```python
# weather/models.py
class UserPreferences(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    temperature_unit = models.CharField(
        max_length=1,
        choices=[('C', 'Celsius'), ('F', 'Fahrenheit')],
        default='C'
    )
```

## API Integration

### OpenWeatherMap API
```dart
// weather_service.dart
class WeatherService {
  final String apiKey = 'f2e5a934bf6e77754ad4c5c1521c0f960';
  
  Future<WeatherData> getCurrentWeather(double lat, double lon) async {
    final url = 'https://api.openweathermap.org/data/3.0/onecall'
        '?lat=$lat&lon=$lon&appid=$apiKey';
    // Implementation
  }
}
```

## Database Schema

### Django Models
```python
# weather/models.py
class WeatherHistory(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    location = models.CharField(max_length=100)
    temperature = models.FloatField()
    conditions = models.CharField(max_length=50)
    timestamp = models.DateTimeField(auto_now_add=True)
```

## Setup Instructions

### Prerequisites
- Flutter SDK
- Python 3.8+
- Django 4.0+
- SqLite

### Environment Setup
1. Clone the repository
2. Set up virtual environment
3. Install dependencies
4. Configure environment variables

### API Keys Required
- Google Maps API Key
- OpenWeatherMap API Key
- Google Sign-In Client ID

### Running the Application
bash
# Backend
python manage.py migrate
python manage.py runserver

# Frontend
flutter pub get
flutter 



I have flutter and Django

The requirements are :

Basic of flutter + Django 

### 1. Inscription avec vérification de l'adresse email et authentification des utilisateurs pour personnaliser l'expérience

=> Utilisation de l'api de google pour verification de l'email    on  

###### 1. Login google sign in

[Optional](https://pub.dev/packages/google_sign_in)

Or

[Some how](https://dev.to/noel_ethan/how-to-develop-an-email-verification-api-using-django-rest-framework-23k2)


### 2. Prévisions météo locales avec données en temps réel

=> Utilisation d'api de weather in real time

#### - Openweathermap

[openweathermap](https://openweathermap.org/api)


[Geolocateur Package](https://pub.dev/packages/geolocator)



link how to call it : 

    `https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}api key : f2e5a934bf6e77754ad4c5c1521c0f960)`

[openweathermap.org/history](https://openweathermap.org/history)

[openweathermap.org/api/one-call-3](https://openweathermap.org/api/one-call-3#current)

### 3. Carte météo interactive pour visualiser les conditions sur différentes régions

=> Google maps to display the weather by region

[geolocator](https://pub.dev/packages/geolocator)

[google-maps-in-flutter](https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#0)

[Youtube : Google cloud platforms](https://www.youtube.com/watch?v=eycjk3APuoI)


[console.cloud.google](https://console.cloud.google.com/)

### 4. Historique des données météo pour consulter les tendances passées

=> Django Modele and database for the users have  consulted : 

5 (Ou par rapport des utilisateurs connecte fait en sorte que quelque uns fait un j'aime ou consulte cette meteo il devient une tendance)

uses looked on it it will be a tendance and i will have to put it in a database a temporaly one 

[SqLite with Django](https://www.youtube.com/watch?v=oUIjHQMBdD4) Or i can replace it with another one.
[SqLite with Django](https://www.djongomapper.com/integrating-django-with-SqLite/) Or Read this.
 
### 5. Widgets personnalisables pour un accès rapide sur l’écran d’accueil

[home+widget+flutter](https://www.youtube.com/results?search_query=home+widget+flutter)

### 6. Options de personnalisation pour choisir les unités de mesure (Celsius/Fahrenheit)

=> UI and Code

### 6. Système de géolocalisation pour afficher automatiquement la météo de la position actuelle

=> Include above

### 8. Prévisions à long terme (jusqu'à 14 jours) avec des graphiques interactifs

=> No api or pay , but i can generate random data for upcoming days

### 8. Backend pour la gestion des données météorologiques et des utilisateurs

# Great Experience
# Great Experience
# Great Experience
# Great Experience

