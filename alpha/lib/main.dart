// lib/main.dart
import 'package:alpha/constants/routes.dart';
import 'package:alpha/firebase_options.dart';
import 'package:alpha/localization/app_localizations.dart';
import 'package:alpha/views/ai_chat_view.dart';
import 'package:alpha/views/company_register_view.dart';
import 'package:alpha/views/dashboard_view.dart';
import 'package:alpha/views/login_view.dart';
import 'package:alpha/views/my_requests_view.dart';
import 'package:alpha/views/payment_view.dart';
import 'package:alpha/views/pickup_request_view.dart';
import 'package:alpha/views/pickup_type_selection_view.dart';
import 'package:alpha/views/profile_view.dart';
import 'package:alpha/views/register_view.dart';
import 'package:alpha/views/role_selection_view.dart';
import 'package:alpha/views/status_check_view.dart';
import 'package:alpha/views/track_collector_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      title: 'kuralewo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3C8D3E)),
        useMaterial3: true,
      ),

      // Localization
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('am')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const HomePage(),
      routes: {
        roleSelectionRoute: (context) => const RoleSelectionView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        dashboardRoute: (context) => const DashboardView(),
        profileRoute: (context) => const ProfileView(),
        trackCollectorRoute: (context) => const TrackCollectorView(),
        pickupRequestRoute: (context) => const PickupRequestView(),
        aiChatRoute: (context) => const AiChatView(),
        statusCheckRoute: (context) => const StatusCheckView(),
        paymentRoute: (context) => const PaymentView(),
        myRequestsRoute: (context) => const MyRequestsView(),
        pickupTypeSelectionRoute: (context) => const PickupTypeSelectionView(),
        companyRegisterRoute: (context) => const CompanyRegisterView(),

      },
    );
  } 
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;   // We still use this to check login

    if (user == null) {
      return const RoleSelectionView();   // Always show role selection if not logged in
    }

    return const DashboardView();   // Logged in user goes to Dashboard
  }
}