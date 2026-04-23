import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _listenForJobs();
  }

  void _listenForJobs() {
    // Socket will listen here for new pickup requests
    // We will implement this after backend is ready
  }

  Future<void> toggleOnline() async {
    setState(() => isOnline = !isOnline);
    // TODO: Send status to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isOnline ? "You are now Online ✅" : "You are Offline")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Collector Dashboard"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Online Toggle Card
            Card(
              child: ListTile(
                leading: Icon(isOnline ? Icons.circle : Icons.circle_outlined, color: isOnline ? Colors.green : Colors.grey),
                title: Text(isOnline ? "You are Online" : "Go Online to receive jobs"),
                trailing: Switch(value: isOnline, onChanged: (_) => toggleOnline()),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Available Pickup Requests", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            Expanded(
              child: availableJobs.isEmpty
                  ? const Center(child: Text("No jobs available yet.\nGo Online to receive requests."))
                  : ListView.builder(
                      itemCount: availableJobs.length,
                      itemBuilder: (context, index) {
                        final job = availableJobs[index];
                        return Card(
                          child: ListTile(
                            title: Text("${job['kg']} kg - ${job['address'] ?? 'Nearby'}"),
                            subtitle: Text("Distance: ~2.3 km"),
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
    // TODO: Open Google Maps + Job Details
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Job Accepted! Route opening...")));
  }
}