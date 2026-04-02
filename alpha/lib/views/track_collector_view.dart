// lib/views/track_collector_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrackCollectorView extends StatefulWidget {
  const TrackCollectorView({super.key});

  @override
  State<TrackCollectorView> createState() => _TrackCollectorViewState();
}

class _TrackCollectorViewState extends State<TrackCollectorView> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  final LatLng _collectorLocation = const LatLng(9.0300, 38.7400); // Example: Addis Ababa

  List<LatLng> _routePoints = [];
  final TextEditingController _searchController = TextEditingController();
  // ignore: unused_field
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getRoute(); // Draw initial route
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("Location services disabled");

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });

      _mapController.move(_userLocation!, 15.0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not get location: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Get simple route line between user and collector
  Future<void> _getRoute() async {
    if (_userLocation == null) return;

    try {
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${_collectorLocation.longitude},${_collectorLocation.latitude};'
        '${_userLocation!.longitude},${_userLocation!.latitude}'
        '?overview=full&geometries=geojson',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coordinates = data['routes'][0]['geometry']['coordinates'] as List;

        setState(() {
          _routePoints = coordinates
              .map((coord) => LatLng(coord[1], coord[0]))
              .toList();
        });
      }
    } catch (e) {
      print("Route error: $e");
      // Fallback: straight line
      setState(() {
        _routePoints = [_collectorLocation, _userLocation!];
      });
    }
  }

  // Search address using free Nominatim
  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1',
      );

      final response = await http.get(url, headers: {
        'User-Agent': 'SmartWasteCollectorApp'
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);

          final newLocation = LatLng(lat, lon);

          setState(() {
            _userLocation = newLocation;
          });

          _mapController.move(newLocation, 16.0);
          await _getRoute(); // Update route after search
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Address not found")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Search failed. Try again.")),
      );
    } finally {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Track Collector"),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation ?? const LatLng(9.0300, 38.7400),
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.smartwaste',
              ),

              // Route Line
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: primaryGreen,
                      strokeWidth: 5.0,
                      borderStrokeWidth: 2,
                      borderColor: Colors.white,
                    ),
                  ],
                ),

              // Markers
              MarkerLayer(
                markers: [
                  // Collector (Green Truck)
                  Marker(
                    point: _collectorLocation,
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.local_shipping, color: Color(0xFF3C8D3E), size: 42),
                  ),

                  // User Location (Blue)
                  if (_userLocation != null)
                    Marker(
                      point: _userLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(Icons.my_location, color: Colors.blue, size: 42),
                    ),
                ],
              ),
            ],
          ),

          // Search Box
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search address (e.g. Bole, Addis Ababa)",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onSubmitted: _searchAddress,
              ),
            ),
          ),

          // Info Card
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Collector is nearby", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Estimated arrival: 10-15 minutes", style: TextStyle(fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: primaryGreen),
                      const SizedBox(width: 8),
                      Text(_userLocation != null ? "Your location detected" : "Searching location..."),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Refresh Button
          Positioned(
            top: 80,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: primaryGreen,
              onPressed: () {
                _getCurrentLocation();
                _getRoute();
              },
              child: const Icon(Icons.refresh, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}