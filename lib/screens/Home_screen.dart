import 'package:flutter/material.dart';
import 'package:notifyweather/screens/map.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E56A0), Color(0xFF1E56A0), Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Hinted search text',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixIcon: const Icon(Icons.menu, color: Colors.white),
                    suffixIcon: const Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
            ),

            // Weather Icon
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFB74D),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 15,
                        child: Container(
                          width: 40,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Temperature
            const Text(
              '28°C',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Temperature',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 40),

            // Weather Info Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWeatherCard('Wind', '8 Km/h'),
                _buildWeatherCard('Humidity', '25 %'),
                _buildWeatherCard('Precipitation', '28°C'),
              ],
            ),

            const Spacer(),

            // Bottom Navigation Bar
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
