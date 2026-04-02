
import 'package:alpha/constants/routes.dart';
import 'package:alpha/firebase_options.dart';
import 'package:alpha/views/ai_chat_view.dart';
import 'package:alpha/views/dashboard_view.dart';
import 'package:alpha/views/login_view.dart';
import 'package:alpha/views/pickup_request_view.dart';
import 'package:alpha/views/register_view.dart';
import 'package:alpha/views/role_selection_view.dart';   // ← Add this if you have it
import 'package:alpha/views/status_check_view.dart';
import 'package:alpha/views/track_collector_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Waste Collector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3C8D3E)),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        roleSelectionRoute: (context) => const RoleSelectionView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        dashboardRoute: (context) => const DashboardView(),
        trackCollectorRoute: (context) => const TrackCollectorView(),
        pickupRequestRoute: (context) => const PickupRequestView(),
        aiChatRoute: (context) => const AiChatView(),
        statusCheckRoute: (context) => const StatusCheckView(),
        
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // If user is already logged in → go to Dashboard
    if (user != null) {
      return const DashboardView();
    }

    // Otherwise start with Role Selection
    return const RoleSelectionView();
  }
}