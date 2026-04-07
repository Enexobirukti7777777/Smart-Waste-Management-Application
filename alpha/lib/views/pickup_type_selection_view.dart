import 'package:alpha/constants/routes.dart';
import 'package:flutter/material.dart';

class PickupTypeSelectionView extends StatelessWidget {
  const PickupTypeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Pickup Request"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "What type of waste?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Recyclable Button
            _buildCard(
              title: "Recyclable",
              subtitle: "Plastic, Metal, Paper...",
              icon: Icons.recycling,
              onTap: () => Navigator.pushNamed(context, pickupRequestRoute, arguments: true),
            ),

            const SizedBox(height: 20),

            // Non-Recyclable Button
            _buildCard(
              title: "Non-Recyclable",
              subtitle: "General waste, food waste...",
              icon: Icons.delete_outline,
              onTap: () => Navigator.pushNamed(context, pickupRequestRoute, arguments: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: const Color(0xFF3C8D3E)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}