
import 'package:alpha/services/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TrackCollectorView extends StatefulWidget {
  const TrackCollectorView({super.key});

  @override
  State<TrackCollectorView> createState() => _TrackCollectorViewState();
}

class _TrackCollectorViewState extends State<TrackCollectorView> {
  final MapController _mapController = MapController();

  LatLng _userLocation = const LatLng(9.0200, 38.7600);
  LatLng _collectorLocation = const LatLng(9.0300, 38.7400);

  List<LatLng> _routePoints = [];
  late WebSocketService _wsService;

  @override
  void initState() {
    super.initState();
    _wsService = WebSocketService(
      onLocationUpdate: (newLocation) {
        setState(() {
          _collectorLocation = newLocation;
        });
        _drawRoute();
      },
    );
    _wsService.connect();        // Start listening to backend
    _drawRoute();
  }

  void _drawRoute() {
    setState(() {
      _routePoints = [_userLocation, _collectorLocation];
    });
  }

  @override
  void dispose() {
    _wsService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Collector"),
        backgroundColor: primaryGreen,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation,
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: primaryGreen,
                    strokeWidth: 6,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _collectorLocation,
                    child: const Icon(Icons.local_shipping, color: Color(0xFF3C8D3E), size: 42),
                  ),
                  Marker(
                    point: _userLocation,
                    child: const Icon(Icons.my_location, color: Colors.blue, size: 42),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Text("Collector is nearby", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Estimated arrival: 10-15 minutes"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}