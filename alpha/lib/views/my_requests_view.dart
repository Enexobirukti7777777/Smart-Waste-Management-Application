// lib/views/my_requests_view.dart
import 'package:flutter/material.dart';

class MyRequestsView extends StatelessWidget {
  const MyRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    // Dummy data (we will replace this with real data later)
    final List<Map<String, dynamic>> requests = [
      {
        "id": "#SWC-7842",
        "date": "April 5, 2026",
        "time": "2:30 PM",
        "type": "Recyclable",
        "weight": "4.5 kg",
        "status": "Completed",
        "amount": "45 Birr"
      },
      {
        "id": "#SWC-7841",
        "date": "April 3, 2026",
        "time": "10:15 AM",
        "type": "Non-Recyclable",
        "weight": "7.2 kg",
        "status": "Completed",
        "amount": "60 Birr"
      },
      {
        "id": "#SWC-7840",
        "date": "April 1, 2026",
        "time": "4:00 PM",
        "type": "Mixed",
        "weight": "3.0 kg",
        "status": "In Progress",
        "amount": "35 Birr"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("My Requests"),
        foregroundColor: Colors.white,
      ),
      body: requests.isEmpty
          ? const Center(child: Text("No requests yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                final isCompleted = request["status"] == "Completed";

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(request["id"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: isCompleted ? Colors.green.shade100 : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                request["status"],
                                style: TextStyle(
                                  color: isCompleted ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildRow("Date & Time", "${request["date"]} • ${request["time"]}"),
                        _buildRow("Type", request["type"]),
                        _buildRow("Weight", request["weight"]),
                        _buildRow("Amount", request["amount"], isBold: true),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w500),
          ),
        ],
      ),
    );
  }
}