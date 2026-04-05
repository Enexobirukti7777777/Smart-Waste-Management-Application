// lib/views/status_check_view.dart
import 'package:flutter/material.dart';

class StatusCheckView extends StatelessWidget {
  const StatusCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    // Dynamic Status List (Easy to update later from database)
    final List<Map<String, dynamic>> statusSteps = [
      {
        "title": "Your request is on process",
        "time": "Just now",
        "isCompleted": true,
      },
      {
        "title": "A collector is assigned to you",
        "time": "15 minutes ago",
        "isCompleted": true,
      },
      {
        "title": "Collector is on the way",
        "time": "Pending",
        "isCompleted": false,
      },
      {
        "title": "The waste collected",
        "time": "Pending",
        "isCompleted": false,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Request Status"),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Pickup Request",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "#SWC-7842 • April 5, 2026",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 50),

            // Dynamic Timeline
            Expanded(
              child: ListView.builder(
                itemCount: statusSteps.length,
                itemBuilder: (context, index) {
                  final step = statusSteps[index];
                  final isLast = index == statusSteps.length - 1;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: step["isCompleted"] ? primaryGreen : Colors.grey.shade300,
                            ),
                            child: step["isCompleted"]
                                ? const Icon(Icons.check, color: Colors.white, size: 16)
                                : null,
                          ),
                          if (!isLast)
                            Container(
                              width: 3,
                              height: 70,
                              color: step["isCompleted"] ? primaryGreen : Colors.grey.shade300,
                            ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step["title"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: step["isCompleted"] ? FontWeight.w600 : FontWeight.normal,
                                color: step["isCompleted"] ? Colors.black : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              step["time"],
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Back to Home", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}