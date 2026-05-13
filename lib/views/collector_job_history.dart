// lib/collector_views/collector_job_history_view.dart
import 'package:collector_app/services/api_service.dart';
import 'package:flutter/material.dart';

class CollectorJobHistoryView extends StatefulWidget {
  const CollectorJobHistoryView({super.key});

  @override
  State<CollectorJobHistoryView> createState() => _CollectorJobHistoryViewState();
}

class _CollectorJobHistoryViewState extends State<CollectorJobHistoryView>
    with SingleTickerProviderStateMixin {
  static const primaryGreen = Color(0xFF3C8D3E);
  static const bgColor = Color(0xFFF2FFEE);

  late TabController _tabController;
  List<dynamic> _completed = [];
  List<dynamic> _cancelled = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Summary stats
  int _totalCompleted = 0;
  double _totalEarnings = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final data = await ApiService().getJobHistory();
      // ignore: unnecessary_cast
      final all = data as List;
      setState(() {
        _completed = all.where((j) => j['status'] == 'completed').toList();
        _cancelled = all.where((j) => j['status'] == 'cancelled').toList();
        _totalCompleted = _completed.length;
        _totalEarnings = _completed.fold(0.0, (sum, j) => sum + ((j['earnings'] ?? 0) as num).toDouble());
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _errorMessage = "Failed to load history";
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
        foregroundColor: Colors.white,
        title: const Text("Job History"),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(text: "Completed (${_completed.length})"),
            Tab(text: "Cancelled (${_cancelled.length})"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : _errorMessage.isNotEmpty
              ? _buildError()
              : Column(
                  children: [
                    if (_tabController.index == 0 || true) _buildSummaryBanner(),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildHistoryList(_completed, showEarnings: true),
                          _buildHistoryList(_cancelled, showEarnings: false),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSummaryBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: primaryGreen.withOpacity(0.08),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Completed", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("$_totalCompleted jobs", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          Container(width: 1, height: 36, color: Colors.grey.shade300),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Total Earned", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  "${_totalEarnings.toStringAsFixed(0)} ETB",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryGreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(_errorMessage, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadHistory, style: ElevatedButton.styleFrom(backgroundColor: primaryGreen), child: const Text("Retry")),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<dynamic> jobs, {required bool showEarnings}) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off_outlined, size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text("No records yet", style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (_, i) => _buildHistoryCard(jobs[i], showEarnings: showEarnings),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> job, {required bool showEarnings}) {
    final isCompleted = job['status'] == 'completed';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: (isCompleted ? primaryGreen : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCompleted ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
              color: isCompleted ? primaryGreen : Colors.red,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Request #${job['id']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 3),
                Text(job['address'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text("${job['weight'] ?? '?'} kg", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const Text(" · ", style: TextStyle(color: Colors.grey)),
                    Text(job['completedAt'] ?? job['date'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          if (showEarnings && job['earnings'] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+${job['earnings']} ETB",
                  style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                if (job['rating'] != null)
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                      Text(job['rating'].toString(), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }
}