import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/weather.dart';

class WeatherHistoryWidget extends StatelessWidget {
  const WeatherHistoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('weather_history')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red)),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No weather history available'));
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(6.0, 15.0, 8.0, 6.0),
          child: Container(
            height: 200, // Fixed height for the history section
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 24, 76, 180),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Weather History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_sweep, color: Colors.white),
                        onPressed: () => _showDeleteConfirmation(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final timestamp =
                          (data['timestamp'] as Timestamp).toDate();

                      return Dismissible(
                        key: Key(doc.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteRecord(doc.id);
                        },
                        child: Card(
                          color: Colors.white.withOpacity(0.1),
                          child: ListTile(
                            leading: _getWeatherIcon(data['condition']),
                            title: Text(
                              data['location'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${data['temperature'].toStringAsFixed(1)}°C - ${data['condition']}\n${DateFormat('MMM d, y HH:mm').format(timestamp)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getWeatherIcon(String condition) {
    IconData iconData;
    switch (condition.toLowerCase()) {
      case 'clear':
        iconData = Icons.wb_sunny;
        break;
      case 'rain':
        iconData = Icons.water_drop;
        break;
      case 'clouds':
        iconData = Icons.cloud;
        break;
      case 'snow':
        iconData = Icons.ac_unit;
        break;
      default:
        iconData = Icons.cloud;
    }
    return Icon(iconData, color: Colors.white);
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear History'),
          content:
              const Text('Are you sure you want to clear all weather history?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _clearAllHistory();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRecord(String docId) async {
    await FirebaseFirestore.instance
        .collection('weather_history')
        .doc(docId)
        .delete();
  }

  Future<void> _clearAllHistory() async {
    final batch = FirebaseFirestore.instance.batch();
    final snapshots =
        await FirebaseFirestore.instance.collection('weather_history').get();

    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}

// Update your WeatherWidget class to include the history section:

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  final bool isCelsius;

  const WeatherWidget({
    Key? key,
    required this.weather,
    required this.isCelsius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E4289),
                  Color(0xFF4B7BF5),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Your existing weather display widgets...
                Text(
                  weather.cityName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${weather.temperature.toStringAsFixed(1)} ${isCelsius ? "°C" : "°F"}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // ... rest of your existing weather display widgets

                // Add Save button
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save to History'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF1E4289),
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('weather_history')
                        .add({
                      'location': weather.cityName,
                      'temperature': weather.temperature,
                      'condition': weather.mainCondition,
                      'timestamp': DateTime.now(),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Weather data saved!')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Add the history widget below the weather display
          const WeatherHistoryWidget(),
        ],
      ),
    );
  }
}
