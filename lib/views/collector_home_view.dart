import 'package:flutter/material.dart';
// ignore: unused_import
import '../services/api_service.dart';

class CollectorHomeView extends StatefulWidget {
  final String userEmail;
  final String userName;

  const CollectorHomeView({super.key, required this.userEmail, required this.userName});

  @override
  State<CollectorHomeView> createState() => _CollectorHomeViewState();
}

class _CollectorHomeViewState extends State<CollectorHomeView> {
  bool isOnline = false;
  List<dynamic> availableJobs = [];

  void toggleOnline() {
    setState(() => isOnline = !isOnline);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isOnline ? "🟢 You are now Online - Waiting for jobs" : "🔴 You are Offline"),
        backgroundColor: isOnline ? Colors.green : Colors.red,
      ),
    );
    // TODO: Send online status to backend later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.userName}"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(isOnline ? Icons.circle : Icons.circle_outlined),
            onPressed: toggleOnline,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: Icon(isOnline ? Icons.check_circle : Icons.access_time, color: isOnline ? Colors.green : Colors.grey, size: 40),
                title: Text(isOnline ? "You are Online" : "Go Online to receive jobs"),
                subtitle: Text(isOnline ? "Waiting for nearby pickup requests..." : "Tap to go online"),
                trailing: Switch(value: isOnline, onChanged: (_) => toggleOnline()),
              ),
            ),

            const SizedBox(height: 24),

            const Text("Available Jobs", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Expanded(
              child: availableJobs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hourglass_empty, size: 80, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            isOnline ? "No jobs nearby right now" : "Go Online to see jobs",
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: availableJobs.length,
                      itemBuilder: (context, index) {
                        final job = availableJobs[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text("${job['kg'] ?? 'N/A'} kg Pickup"),
                            subtitle: Text("Distance: ~${job['distance'] ?? '2.5'} km"),
                            trailing: ElevatedButton(
                              onPressed: () => _acceptJob(job),
                              child: const Text("Accept"),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _acceptJob(dynamic job) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Job Accepted! Opening route...")),
    );
    // TODO: Later open Google Maps with user location
  }
}