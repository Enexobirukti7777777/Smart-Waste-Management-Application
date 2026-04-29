// lib/collector_views/collector_available_requests_view.dart
// ignore: unused_import
import 'package:collector_app/constants/routes.dart';
import 'package:collector_app/services/api_service.dart';
import 'package:flutter/material.dart';

class CollectorAvailableRequestsView extends StatefulWidget {
  const CollectorAvailableRequestsView({super.key});

  @override
  State<CollectorAvailableRequestsView> createState() => _CollectorAvailableRequestsViewState();
}

class _CollectorAvailableRequestsViewState extends State<CollectorAvailableRequestsView> {
  List<dynamic> requests = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAvailableRequests();
  }

  Future<void> _fetchAvailableRequests() async {
    setState(() => isLoading = true);

    try {
      final data = await ApiService().getAvailableRequests();
      setState(() {
        requests = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load available requests";
        isLoading = false;
      });
    }
  }

  Future<void> _acceptRequest(String requestId) async {
    try {
      final result = await ApiService().acceptPickup(requestId);
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Request accepted successfully!")),
        );
        _fetchAvailableRequests(); // Refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Failed to accept')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connection error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Available Requests"),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchAvailableRequests),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : requests.isEmpty
                  ? const Center(child: Text("No available requests nearby right now"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final req = requests[index];

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
                                    Text(req['id']?.toString() ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    Text(req['distance']?.toString() ?? '', style: TextStyle(color: primaryGreen)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text("User: ${req['userName'] ?? 'Unknown'}"),
                                Text("Address: ${req['address'] ?? 'N/A'}"),
                                const SizedBox(height: 8),
                                Text("${req['type'] ?? 'Waste'} • ${req['weight'] ?? 'N/A'} kg"),

                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        child: const Text("Reject"),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => _acceptRequest(req['id'].toString()),
                                        style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                                        child: const Text("Accept"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}