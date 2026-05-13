// lib/models/collector_stats_model.dart

class CollectorStats {
  final int? assignedToday;
  final int? completedToday;
  final double? earningsToday;
  final double? rating;
  final List<Map<String, dynamic>> recentActivity;

  CollectorStats({
    this.assignedToday,
    this.completedToday,
    this.earningsToday,
    this.rating,
    this.recentActivity = const [],
  });

  factory CollectorStats.fromJson(Map<String, dynamic> json) {
    return CollectorStats(
      assignedToday: json['assignedToday'] as int?,
      completedToday: json['completedToday'] as int?,
      earningsToday: (json['earningsToday'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      recentActivity: (json['recentActivity'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
    );
  }
}