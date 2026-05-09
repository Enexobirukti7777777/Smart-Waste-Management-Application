// lib/views/my_requests_view.dart
import 'package:alpha/constants/routes.dart';
import 'package:alpha/services/api_service.dart';
import 'package:flutter/material.dart';

class MyRequestsView extends StatefulWidget {
  final String userEmail;

const MyRequestsView({super.key, required this.userEmail});

  @override
  State<MyRequestsView> createState() => _MyRequestsViewState();
}

class _MyRequestsViewState extends State<MyRequestsView> {
  List<dynamic> requests = [];
  bool isLoading = true;
  String errorMessage = '';

  // Use real email or fallback
String get userEmail => widget.userEmail;
  @override
  void initState() {
    super.initState();
    _fetchMyRequests();
  }

  Future<void> _fetchMyRequests() async {
  setState(() => isLoading = true);
  
  print("🔄 Fetching MY REQUESTS for: $userEmail");

  try {
    final data = await ApiService().getMyPickups(userEmail);
    
    print("✅ Got ${data.length} requests");
    print("Requests data: $data");

    setState(() {
      requests = data;
      isLoading = false;
    });
  } catch (e) {
    print("❌ Error: $e");
    setState(() => isLoading = false);
  }
}
  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("My Pickup Requests"),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchMyRequests,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : requests.isEmpty
                  ? const Center(
                      child: Text(
                        "No pickup requests yet\nTap + to create new",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final req = requests[index];

                        final status = (req['status'] ?? 'pending').toString().toLowerCase();
                        final isApproved = status == 'approved' || status == 'completed';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: primaryGreen.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.recycling, color: primaryGreen, size: 32),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "#${req['id'] ?? 'N/A'}",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        req['createdAt']?.toString().substring(0, 10) ?? 'No date',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                      Text(
                                        "${req['kg'] ?? req['weight'] ?? 'N/A'} kg",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isApproved ? Colors.green.shade100 : Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status.toUpperCase(),
                                    style: TextStyle(
                                      color: isApproved ? Colors.green.shade800 : Colors.orange.shade800,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, pickupTypeSelectionRoute),
        backgroundColor: primaryGreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}