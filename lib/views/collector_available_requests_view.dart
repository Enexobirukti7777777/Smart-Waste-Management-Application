// lib/collector_views/collector_available_requests_view.dart
import 'package:collector_app/constants/routes.dart';
import 'package:collector_app/services/api_service.dart';
import 'package:flutter/material.dart';

class CollectorAvailableRequestsView extends StatefulWidget {
  const CollectorAvailableRequestsView({super.key});

  @override
  State<CollectorAvailableRequestsView> createState() => _CollectorAvailableRequestsViewState();
}

class _CollectorAvailableRequestsViewState extends State<CollectorAvailableRequestsView> {
  static const primaryGreen = Color(0xFF3C8D3E);
  static const bgColor = Color(0xFFF2FFEE);

  List<dynamic> _requests = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final Set<String> _acceptingIds = {};

  @override
  void initState() {
    super.initState();
    _fetchAvailableRequests();
  }

  Future<void> _fetchAvailableRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final data = await ApiService().getAvailableRequests();
      setState(() {
        _requests = data;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _errorMessage = "Failed to load requests";
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptRequest(String requestId) async {
    setState(() => _acceptingIds.add(requestId));
    try {
      final result = await ApiService().acceptPickup(requestId);
      if (result['success'] == true) {
        setState(() => _requests.removeWhere((r) => r['id'].toString() == requestId));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Request accepted! Check My Tasks."),
                ],
              ),
              backgroundColor: primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              action: SnackBarAction(
                label: "View Tasks",
                textColor: Colors.white,
                onPressed: () => Navigator.pushNamed(context, collectorMyTasksRoute),
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Failed to accept')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connection error. Please try again.")),
      );
    } finally {
      setState(() => _acceptingIds.remove(requestId));
    }
  }

  Future<void> _rejectRequest(String requestId) async {
    setState(() => _requests.removeWhere((r) => r['id'].toString() == requestId));
    // Optionally call backend to track rejections
    try {
      await ApiService().rejectPickup(requestId);
    } catch (_) {
      // Silent fail — we already removed from UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        title: const Text("Available Requests"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _fetchAvailableRequests,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingSkeleton()
          : _errorMessage.isNotEmpty
              ? _buildError()
              : _requests.isEmpty
                  ? _buildEmpty()
                  : _buildRequestList(),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(_errorMessage, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchAvailableRequests,
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("No requests nearby right now", style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text("Pull down to refresh", style: TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _fetchAvailableRequests,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Refresh"),
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestList() {
    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: _fetchAvailableRequests,
      child: Column(
        children: [
          // Count banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: primaryGreen.withOpacity(0.08),
            child: Text(
              "${_requests.length} request${_requests.length > 1 ? 's' : ''} near you",
              style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _requests.length,
              itemBuilder: (context, index) => _buildRequestCard(_requests[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> req) {
    final id = req['id'].toString();
    final isAccepting = _acceptingIds.contains(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          // Top strip: distance + type badge
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.near_me_rounded, size: 14, color: primaryGreen),
                      const SizedBox(width: 4),
                      Text(
                        req['distance']?.toString() ?? '',
                        style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    req['type']?.toString() ?? 'Waste',
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
                const Spacer(),
                Text(
                  req['postedTime']?.toString() ?? '',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          // Main info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFE8F5E9),
                      child: Icon(Icons.person, color: primaryGreen, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(req['userName'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Row(
                          children: [
                            const Icon(Icons.scale_outlined, size: 13, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text("${req['weight'] ?? 'N/A'} kg", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Estimated earnings badge
                    if (req['estimatedEarnings'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Est. Earnings", style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text(
                            "${req['estimatedEarnings']} ETB",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: primaryGreen, fontSize: 15),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        req['address'] ?? 'N/A',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isAccepting ? null : () => _rejectRequest(id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Skip"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: isAccepting ? null : () => _acceptRequest(id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: isAccepting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text("Accept Request", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}