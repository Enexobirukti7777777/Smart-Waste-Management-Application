import 'package:collector_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'home_view.dart';

class CollectorLoginView extends StatefulWidget {
  const CollectorLoginView({super.key});

  @override
  State<CollectorLoginView> createState() => _CollectorLoginViewState();
}

class _CollectorLoginViewState extends State<CollectorLoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final result = await ApiService().login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (result['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CollectorHomeView(
            userEmail: result['user']['email'],
            userName: result['user']['name'] ?? "Collector",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Login Failed")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_pin, size: 100, color: Colors.green),
            const Text("Collector Login", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading ? const CircularProgressIndicator() : const Text("Login as Collector"),
            ),
          ],
        ),
      ),
    );
  }
}