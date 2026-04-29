// lib/collector_views/collector_dashboard_view.dart
import 'package:collector_app/constants/routes.dart';
import 'package:flutter/material.dart';

class CollectorDashboardView extends StatelessWidget {
  const CollectorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Collector Dashboard"),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, collectorProfileRoute),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            const Text(
              "Good morning, Collector!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text("Here's your today's summary", style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 24),

            // Stats Cards
            Row(
              children: [
                _buildStatCard("Today's Pickups", "8", "Assigned", primaryGreen),
                const SizedBox(width: 12),
                _buildStatCard("Completed", "5", "Today", Colors.green),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                _buildStatCard("Earnings Today", "320", "ETB", Colors.orange),
                const SizedBox(width: 12),
                _buildStatCard("Rating", "4.8", "★", Colors.amber),
              ],
            ),

            const SizedBox(height: 30),

            // Quick Actions
            const Text("Quick Actions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _buildActionCard(
              "Available Requests",
              "12 new requests nearby",
              Icons.list_alt,
              () => Navigator.pushNamed(context, collectorAvailableRequestsRoute),
            ),

            const SizedBox(height: 12),

            _buildActionCard(
              "My Current Tasks",
              "3 pickups in progress",
              Icons.work,
              () => Navigator.pushNamed(context, collectorMyTasksRoute),
            ),

            const SizedBox(height: 30),

            // Recent Activity
            const Text("Recent Activity", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Card(
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text("Completed Pickup #SWC-7842"),
                subtitle: Text("2 hours ago • 4.5 kg"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String unit, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
              Text(unit, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: Icon(icon, size: 40, color: const Color(0xFF3C8D3E)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 20),
        ),
      ),
    );
  }
}