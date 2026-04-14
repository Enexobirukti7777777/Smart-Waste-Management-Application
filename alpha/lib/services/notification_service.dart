//import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

//   Future<void> initialize() async {
//     // Request permission
//     await _fcm.requestPermission();

//     // Local notification setup
//     const AndroidInitializationSettings android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initSettings = InitializationSettings(android: android);

//     await _localNotifications.initialize(initSettings);
//   }

//   // Show popup notification 
//   Future<void> showNotification({
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'main_channel',
//       'Main Notifications',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const NotificationDetails details = NotificationDetails(android: androidDetails);

//     await _localNotifications.show(0, title, body, details);
//   }

//   // For future backend integration
//   void setupFirebaseListeners() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       showNotification(
//         title: message.notification?.title ?? "Smart Waste",
//         body: message.notification?.body ?? "You have a new update",
//       );
//     });
//   }
// }