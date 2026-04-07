import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:latlong2/latlong.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final Function(LatLng) onLocationUpdate;

  WebSocketService({required this.onLocationUpdate});

  void connect() {
    // Replace with your backend WebSocket URL
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://your-backend.com/ws/track-collector'), 
    );

    _channel!.stream.listen((message) {
      final data = Map<String, dynamic>.from(message);
      final newLocation = LatLng(data['lat'], data['lng']);
      onLocationUpdate(newLocation);
    });
  }

  void disconnect() {
    _channel?.sink.close();
  }
}