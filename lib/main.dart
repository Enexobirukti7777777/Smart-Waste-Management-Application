import 'package:collector_app/constants/routes.dart';
import 'package:collector_app/views/collector_available_requests_view.dart';
import 'package:collector_app/views/collector_dashboard_view.dart';
// ignore: unused_import
import 'package:collector_app/views/collector_home_view.dart';
import 'package:collector_app/views/collector_job_history.dart';
import 'package:collector_app/views/collector_my_tasks_view.dart';
import 'package:collector_app/views/collector_pickup_detail_view.dart';
import 'package:collector_app/views/collector_profile_view.dart';
// ignore: unused_import
import 'package:collector_app/views/collector_register_view.dart';
import 'package:flutter/material.dart';
import 'views/collector_login_view.dart';

void main() {
  runApp(const CollectorApp());
}

class CollectorApp extends StatelessWidget {
  const CollectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuralewo Collector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const CollectorDashboardView(),
      routes: {
collectorLoginRoute: (context) => const CollectorLoginView(),
collectorMyTasksRoute: (context) => const CollectorMyTasksView(),
  collectorDashboardRoute: (context) => const CollectorDashboardView(),
  collectorAvailableRequestsRoute: (context) => const CollectorAvailableRequestsView(),
  collectorRegisterRoute: (_) => const CollectorRegisterView(),
  collectorPickupDetailRoute: (ctx) => CollectorPickupDetailView(
    request: ModalRoute.of(ctx)!.settings.arguments as Map<String, dynamic>,
  ),
  collectorProfileRoute: (_) => const CollectorProfileView(),
  collectorJobHistoryRoute: (_) => const CollectorJobHistoryView(),
      
      },
    );
  }
}