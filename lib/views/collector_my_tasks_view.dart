// lib/collector_views/collector_my_tasks_view.dart
// ignore: unused_import
import 'package:collector_app/constants/routes.dart';
import 'package:collector_app/services/api_service.dart';
import 'package:flutter/material.dart';

class CollectorMyTasksView extends StatefulWidget {
  const CollectorMyTasksView({super.key});

  @override
  State<CollectorMyTasksView> createState() => _CollectorMyTasksViewState();
}

class _CollectorMyTasksViewState extends State<CollectorMyTasksView> {
  List<dynamic> tasks = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchMyTasks();
  }

  Future<void> _fetchMyTasks() async {
    setState(() => isLoading = true);

    try {
      final data = await ApiService().getMyTasks();
      setState(() {
        tasks = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load your tasks";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("My Tasks"),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchMyTasks),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : tasks.isEmpty
                  ? const Center(child: Text("You have no assigned tasks yet"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            leading: const Icon(Icons.recycling, color: primaryGreen, size: 40),
                            title: Text("Request ${task['id'] ?? ''}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("User: ${task['userName'] ?? 'N/A'}"),
                                Text("${task['weight'] ?? 'N/A'} kg • ${task['type'] ?? ''}"),
                              ],
                            ),
                            trailing: Chip(
                              label: Text((task['status'] ?? 'pending').toUpperCase()),
                              backgroundColor: Colors.orange.shade100,
                            ),
                            onTap: () {
                              // Navigate to detail screen later
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}