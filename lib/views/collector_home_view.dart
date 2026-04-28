import 'package:flutter/material.dart';
import 'job_detail_view.dart';

class CollectorHomeView extends StatefulWidget {
  final String userEmail;
  final String userName;

  const CollectorHomeView({super.key, required this.userEmail, required this.userName});

  @override
  State<CollectorHomeView> createState() => _CollectorHomeViewState();
}

class _CollectorHomeViewState extends State<CollectorHomeView> {
  bool isOnline = false;
  List<Map<String, dynamic>> availableJobs = [];
  List<Map<String, dynamic>> acceptedJobs = [];

  // Demo jobs
  final List<Map<String, dynamic>> demoJobs = [
    {
      "id": 101,
      "kg": 12.5,
      "address": "Bole Road, Near Edna Mall, Addis Ababa",
      "distance": "1.8 km",
      "time": "10 min ago",
      "type": "Recyclable (Plastic & Paper)",
      "phone": "0911-234-567",
      "status": "pending"
    },
    {
      "id": 102,
      "kg": 8.0,
      "address": "Piassa, Around St. George Church",
      "distance": "3.2 km",
      "time": "25 min ago",
      "type": "Mixed Household Waste",
      "phone": "0912-345-678",
      "status": "pending"
    },
  ];

  void toggleOnline() {
    setState(() {
      isOnline = !isOnline;
      availableJobs = isOnline ? List.from(demoJobs) : [];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isOnline 
            ? "🟢 You are now Online - New jobs will appear" 
            : "🔴 You are now Offline"),
        backgroundColor: isOnline ? Colors.green : Colors.red,
      ),
    );
  }

  void _acceptJob(Map<String, dynamic> job) {
    // Move job from available to accepted
    setState(() {
      availableJobs.removeWhere((j) => j['id'] == job['id']);
      acceptedJobs.add({...job, "status": "accepted"});
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailView(job: job),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.userName}"),
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(isOnline ? Icons.circle : Icons.circle_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(isOnline ? "Online" : "Offline", style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Online Status
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(isOnline ? Icons.check_circle : Icons.access_time, color: isOnline ? Colors.green : Colors.grey, size: 48),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isOnline ? "You are Online" : "Go Online to receive jobs", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(isOnline ? "Waiting for nearby pickup requests..." : "Toggle to start receiving jobs", style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    Switch(value: isOnline, onChanged: (_) => toggleOnline(), activeColor: Colors.green),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Available Jobs
            const Text("Available Pickup Requests", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Expanded(
              child: availableJobs.isEmpty && acceptedJobs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hourglass_empty, size: 90, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(isOnline ? "No jobs available right now" : "Go Online to see nearby requests", 
                              textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        // Available Jobs Section
                        if (availableJobs.isNotEmpty) ...[
                          const Text("New Requests", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
                          const SizedBox(height: 8),
                          ...availableJobs.map((job) => _buildJobCard(job, true)),
                        ],

                        // Accepted Jobs Section
                        if (acceptedJobs.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Text("Accepted Jobs", style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          ...acceptedJobs.map((job) => _buildJobCard(job, false)),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, bool isAvailable) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text("${job['kg']} kg • ${job['type']}", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job['address']),
            Text("${job['distance']} • ${job['time']}", style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        trailing: isAvailable 
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => _acceptJob(job),
                child: const Text("Accept"),
              )
            : const Text("Accepted", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
      ),
    );
  }
}