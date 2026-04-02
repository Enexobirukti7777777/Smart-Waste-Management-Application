import 'package:flutter/material.dart';

class StatusCheckView extends StatelessWidget {
  const StatusCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

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
          children: [
            const SizedBox(height: 40),
            const Text(
              "Your Pickup Request",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Timeline
            _buildTimelineStep("Your request is on process", true),
            _buildTimelineStep("A collector is assigned to you", true),
            _buildTimelineStep("The waste collected", false),

            const Spacer(),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(String title, bool isCompleted) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? const Color(0xFF3C8D3E) : Colors.grey.shade300,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            Container(
              width: 2,
              height: 60,
              color: isCompleted ? const Color(0xFF3C8D3E) : Colors.grey.shade300,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
              color: isCompleted ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}