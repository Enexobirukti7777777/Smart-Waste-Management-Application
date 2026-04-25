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
      home: const CollectorLoginView(),
    );
  }
}