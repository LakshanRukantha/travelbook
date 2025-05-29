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
  bool isLoading = false;
  GoogleMapController? mapController;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  final LatLng _initialPosition = const LatLng(7.8731, 80.7718);

  Future<void> _getRoute() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });

    try {
      String origin = fromController.text;
      String destination = toController.text;
      String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

      if (origin.isEmpty || destination.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter both locations")),
        );
        return;
      }

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

        final startLocation = data["routes"][0]["legs"][0]["start_location"];
        final endLocation = data["routes"][0]["legs"][0]["end_location"];
        LatLng startLatLng = LatLng(startLocation["lat"], startLocation["lng"]);
        LatLng endLatLng = LatLng(endLocation["lat"], endLocation["lng"]);

        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId("route"),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            )
          };

          _markers = {
            Marker(
              markerId: const MarkerId("start"),
              position: startLatLng,
              infoWindow: const InfoWindow(title: "From"),
            ),
            Marker(
              markerId: const MarkerId("end"),
              position: endLatLng,
              infoWindow: const InfoWindow(title: "To"),
            ),
          };
        });

        // Proper zoom to fit both points
        final bounds = _boundsFromLatLngList([startLatLng, endLatLng]);
        await mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100),
        );
      } else {
        setState(() {
          _polylines = {};
          _markers = {};
        });

        await mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_initialPosition, 6),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "No route found. Please check your inputs or try another route."),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0 = list.first.latitude;
    double x1 = list.first.latitude;
    double y0 = list.first.longitude;
    double y1 = list.first.longitude;

    for (LatLng latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(x0, y0),
      northeast: LatLng(x1, y1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _initialPosition, zoom: 6),
            onMapCreated: (controller) => mapController = controller,
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(child: _buildTextField("From:", fromController)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField("To:", toController)),
                const SizedBox(width: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: isLoading ? null : _getRoute,
                    icon: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Icon(Icons.arrow_forward),
                    color: Colors.white,
                    iconSize: 24,
                  ),
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
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
