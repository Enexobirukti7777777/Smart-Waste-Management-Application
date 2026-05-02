// lib/widgets/notification_sheet.dart
import 'package:alpha/services/notification_service.dart';
import 'package:flutter/material.dart';


class NotificationSheet extends StatelessWidget {
  final NotificationService service;

  const NotificationSheet({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Notifications",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: service.notifications.isEmpty
                ? const Center(child: Text("No notifications yet"))
                : ListView.builder(
                    itemCount: service.notifications.length,
                    itemBuilder: (context, index) {
                      final n = service.notifications[index];
                      return ListTile(
                        leading: const Icon(Icons.notifications, color: Colors.green),
                        title: Text(n['message'] ?? "Pickup Update"),
                        subtitle: Text("Price: ${n['price']} ETB"),
                        trailing: Text(
                          (n['status'] ?? "").toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}