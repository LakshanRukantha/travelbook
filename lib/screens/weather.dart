import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  String? error;

  void _getWeatherByLocation() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final position = await LocationService.getCurrentLocation();
      final data = await WeatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void _getWeatherByCity(String city) async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final data = await WeatherService.getWeatherByCity(city);
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getWeatherByLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Travel Weather"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          children: [
            Material(
              elevation: 2,
              shadowColor: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  hintText: "Search city...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _getWeatherByCity(value.trim());
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : error != null
                        ? Text(
                            "Error: $error",
                            style: const TextStyle(color: Colors.red),
                          )
                        : weatherData != null
                            ? WeatherCard(data: weatherData!)
                            : const Text("No data",
                                style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
