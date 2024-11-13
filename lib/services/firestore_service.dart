import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Weather Data Methods
  Future<void> addWeatherData({
    required String locationName,
    required double temperature,
    required int humidity,
    double? windSpeed,
    required String condition,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('weather_data').add({
      'user_id': user.uid,
      'location_name': locationName,
      'temperature': temperature,
      'humidity': humidity,
      'wind_speed': windSpeed,
      'condition': condition,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // User Preferences Methods
  Future<void> setUserPreferences({
    required String unit,
    required String theme,
    required bool notificationEnabled,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('user_preferences').doc(user.uid).set({
      'user_id': user.uid,
      'unit': unit,
      'theme': theme,
      'notification_enabled': notificationEnabled,
    });
  }

  // History Methods
  Future<void> addToHistory({
    required String locationName,
    required String weatherDataId,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('history').add({
      'user_id': user.uid,
      'location_name': locationName,
      'weather_data_id': weatherDataId,
      'searched_at': FieldValue.serverTimestamp(),
    });
  }

  // Location Methods
  Future<void> saveLocation({
    required String locationName,
    required double latitude,
    required double longitude,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('locations').add({
      'user_id': user.uid,
      'location_name': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'saved_at': FieldValue.serverTimestamp(),
    });
  }

  // Settings Methods
  Future<void> updateSetting({
    required String name,
    required String value,
  }) async {
    await _firestore.collection('settings').doc(name).set({
      'name': name,
      'value': value,
    });
  }

  // Fetch Methods
  Stream<QuerySnapshot> getUserWeatherData() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('weather_data')
        .where('user_id', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getUserPreferences() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore.collection('user_preferences').doc(user.uid).get();
  }

  Stream<QuerySnapshot> getUserHistory() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('history')
        .where('user_id', isEqualTo: user.uid)
        .orderBy('searched_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserLocations() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('locations')
        .where('user_id', isEqualTo: user.uid)
        .orderBy('saved_at', descending: true)
        .snapshots();
  }
}
