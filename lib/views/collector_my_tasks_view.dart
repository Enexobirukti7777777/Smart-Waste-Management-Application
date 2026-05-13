// lib/collector_views/collector_my_tasks_view.dart
import 'package:collector_app/constants/routes.dart';
import 'package:collector_app/services/api_service.dart';
import 'package:flutter/material.dart';

class CollectorMyTasksView extends StatefulWidget {
  const CollectorMyTasksView({super.key});

  @override
  State<CollectorMyTasksView> createState() => _CollectorMyTasksViewState();
}

class _CollectorMyTasksViewState extends State<CollectorMyTasksView>
    with SingleTickerProviderStateMixin {
  static const primaryGreen = Color(0xFF3C8D3E);
  static const bgColor = Color(0xFFF2FFEE);

  late TabController _tabController;
  List<dynamic> _activeTasks = [];
  List<dynamic> _pendingTasks = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchMyTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchMyTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final data = await ApiService().getMyTasks();
      setState(() {
        // ignore: unnecessary_cast
        _activeTasks = (data as List).where((t) =>
          ['accepted', 'on_the_way', 'arrived', 'collecting'].contains(t['status'])
        ).toList();
        _pendingTasks = (data).where((t) => t['status'] == 'pending').toList();
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _errorMessage = "Failed to load tasks. Pull down to retry.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("My Tasks"),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _fetchMyTasks,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(text: "Active (${_activeTasks.length})"),
            Tab(text: "Pending (${_pendingTasks.length})"),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage.isNotEmpty
              ? _buildErrorState()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTaskList(_activeTasks, isActive: true),
                    _buildTaskList(_pendingTasks, isActive: false),
                  ],
                ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 110,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: _fetchMyTasks,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(_errorMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchMyTasks,
                  style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                  child: const Text("Retry"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<dynamic> tasks, {required bool isActive}) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.assignment_turned_in_outlined : Icons.pending_actions_outlined,
              size: 72,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? "No active tasks right now" : "No pending assignments",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: _fetchMyTasks,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) => _buildTaskCard(tasks[index]),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final status = task['status'] ?? 'pending';
    final statusConfig = _getStatusConfig(status);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        collectorPickupDetailRoute,
        arguments: task,
      ).then((_) => _fetchMyTasks()),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            // Status strip at top
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusConfig['color'].withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(statusConfig['icon'], color: statusConfig['color'], size: 16),
                  const SizedBox(width: 6),
                  Text(
                    statusConfig['label'],
                    style: TextStyle(color: statusConfig['color'], fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const Spacer(),
                  Text(
                    task['scheduledTime'] ?? '',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.recycling_rounded, color: primaryGreen, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Request #${task['id'] ?? ''}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(task['userName'] ?? 'Unknown', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                task['address'] ?? 'N/A',
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.scale_outlined, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              "${task['weight'] ?? 'N/A'} kg • ${task['type'] ?? 'Waste'}",
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'accepted':
        return {'label': 'Accepted', 'color': Colors.blue, 'icon': Icons.check_circle_outline};
      case 'on_the_way':
        return {'label': 'On the Way', 'color': Colors.orange, 'icon': Icons.directions_car_outlined};
      case 'arrived':
        return {'label': 'Arrived', 'color': Colors.purple, 'icon': Icons.location_on_outlined};
      case 'collecting':
        return {'label': 'Collecting', 'color': Colors.teal, 'icon': Icons.recycling_outlined};
      case 'pending':
        return {'label': 'Pending', 'color': Colors.grey, 'icon': Icons.access_time};
      default:
        return {'label': status.toUpperCase(), 'color': Colors.grey, 'icon': Icons.info_outline};
    }
  }
}