import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const WeatherCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final weather = data['weather'][0];
    final main = data['main'];
    final name = data['name'];
    final temp = main['temp'].toDouble();
    final icon = weather['icon'];

    print("$icon hello");
    print("$weather");

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.withOpacity(0.8),
              Colors.lightBlueAccent.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.blue,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            buildWeatherIcon(icon),
            const SizedBox(height: 10),
            Text(
              "${temp.toStringAsFixed(1)} °C",
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              weather['description'].toString().toUpperCase(),

              style: const TextStyle(
                color: Colors.white70,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoTile("Humidity", "${main['humidity']}%"),
                _infoTile("Pressure", "${main['pressure']} hPa"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  /// This widget handles special icons (like 01d) and fallbacks
  Widget buildWeatherIcon(String icon) {
    const iconsToIgnore = ['01d', '01n']; // You can add more here

    if (icon.isEmpty || iconsToIgnore.contains(icon)) {
      return Image.asset(
        'assets/images/img.png',
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      'https://openweathermap.org/img/wn/$icon@4x.png',
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/img.png',
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
