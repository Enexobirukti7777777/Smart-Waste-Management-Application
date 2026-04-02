import 'package:alpha/constants/routes.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        title: const Text("Smart Waste Collector", style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () {}),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/waste_header.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Smart Waste Collector",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text("Services", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),

            const SizedBox(height: 16),

            _buildServiceCard(
              context,
              icon: Icons.local_shipping,
              title: "Extra Pickup Request",
              onTap: () => Navigator.pushNamed(context, pickupRequestRoute),
            ),
            const SizedBox(height: 12),

            _buildServiceCard(
              context,
              icon: Icons.chat_bubble_outline,
              title: "AI Chat",
              onTap: () => Navigator.pushNamed(context, aiChatRoute),
            ),
            const SizedBox(height: 12),

            _buildServiceCard(
              context,
              icon: Icons.location_on,
              title: "Track Collector",
              onTap: () => Navigator.pushNamed(context, trackCollectorRoute),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.recycling), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: ""),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
              child: Icon(icon, color: const Color(0xFF3C8D3E), size: 28),
            ),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}