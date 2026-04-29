// lib/collector_views/collector_pickup_detail_view.dart
import 'package:flutter/material.dart';

class CollectorPickupDetailView extends StatelessWidget {
  final Map<String, dynamic> request;

  const CollectorPickupDetailView({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: Text("Request ${request['id'] ?? ''}"),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer: ${request['userName'] ?? 'User'}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("Address: ${request['address'] ?? 'N/A'}"),
                    const SizedBox(height: 8),
                    Text("Weight: ${request['weight'] ?? 'N/A'}"),
                    Text("Type: ${request['type'] ?? 'N/A'}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text("Update Pickup Status", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),

            _buildStatusButton("On the way", Colors.blue, () {}),
            _buildStatusButton("Arrived at Location", Colors.orange, () {}),
            _buildStatusButton("Collecting Waste", Colors.purple, () {}),
            _buildStatusButton("Completed", Colors.green, () {}),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt),
              label: const Text("Upload Collection Photo"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label),
      ),
    );
  }
}