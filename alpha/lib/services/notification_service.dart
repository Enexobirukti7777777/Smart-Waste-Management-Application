// lib/services/notification_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  late IO.Socket socket;
  List<dynamic> notifications = [];
  int unreadCount = 0;
  String? userEmail;

  final String baseUrl = "http://192.168.1.11:5000";   

  // Initialize Socket
  void init(String email) {
    userEmail = email;
    _connectSocket();
  }

  void _connectSocket() {
    socket = IO.io(baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });

    socket.onConnect((_) {
      print("✅ Socket Connected");
      if (userEmail != null) socket.emit("join-user", userEmail);
    });

    socket.on("price-notification", (data) {
      notifications.insert(0, data);
      unreadCount++;
      print("🔔 New Notification Received");
    });

    socket.onDisconnect((_) => print("🔴 Socket Disconnected"));
  }

  // Fetch notifications from backend
  Future<List<dynamic>> fetchNotifications() async {
    if (userEmail == null) return [];

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/notifications?userEmail=$userEmail"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        notifications = data['notifications'] ?? [];
        unreadCount = notifications.length;
        return notifications;
      }
    } catch (e) {
      print("❌ Error fetching notifications: $e");
    }
    return [];
  }

  // Clear unread count when user opens notifications
  void markAsRead() {
    unreadCount = 0;
  }

  void dispose() {
    socket.disconnect();
  }
}