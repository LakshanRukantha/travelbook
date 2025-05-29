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

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color.fromARGB(71, 33, 149, 243),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
                color: Colors.black,
              ),
            ),
            Text(
              weather['description'].toString().toUpperCase(),
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
                fontWeight: FontWeight.w500,
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
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget buildWeatherIcon(String icon) {
    // const iconsToIgnore = ['01d', '01n'];
    const iconsToIgnore = [''];

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
