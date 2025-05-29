import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  final LatLng _initialPosition = const LatLng(7.8731, 80.7718);

  Future<void> _getRoute() async {
    String origin = fromController.text;
    String destination = toController.text;
    String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data["status"] == "OK") {
      final points = PolylinePoints().decodePolyline(
        data["routes"][0]["overview_polyline"]["points"],
      );

      List<LatLng> polylineCoordinates = points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          )
        };

        final startLocation = data["routes"][0]["legs"][0]["start_location"];
        final endLocation = data["routes"][0]["legs"][0]["end_location"];

        _markers = {
          Marker(
            markerId: const MarkerId("start"),
            position: LatLng(startLocation["lat"], startLocation["lng"]),
            infoWindow: const InfoWindow(title: "From"),
          ),
          Marker(
            markerId: const MarkerId("end"),
            position: LatLng(endLocation["lat"], endLocation["lng"]),
            infoWindow: const InfoWindow(title: "To"),
          ),
        };

        mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(startLocation["lat"], startLocation["lng"]),
              northeast: LatLng(endLocation["lat"], endLocation["lng"]),
            ),
            100,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Route not found!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Map",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _initialPosition, zoom: 12),
            onMapCreated: (controller) => mapController = controller,
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                _buildTextField("From:", fromController),
                const SizedBox(height: 10),
                _buildTextField("To:", toController),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _getRoute,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Search",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }
}
