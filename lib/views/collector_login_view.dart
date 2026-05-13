// lib/collector_views/collector_login_view.dart
// ignore_for_file: unused_element

import 'package:collector_app/constants/routes.dart';
import 'package:collector_app/services/api_service.dart';
import 'package:collector_app/views/collector_register_view.dart';
import 'package:flutter/material.dart';

class CollectorLoginView extends StatefulWidget {
  const CollectorLoginView({super.key});

  @override
  State<CollectorLoginView> createState() => _CollectorLoginViewState();
}

class _CollectorLoginViewState extends State<CollectorLoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  // ignore: unused_field
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and Password are required")),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      // TODO: Use collector specific login endpoint later
      final result = await ApiService().login(email, password);

      if (result['success'] == true) {
        Navigator.pushNamedAndRemoveUntil(context, collectorDashboardRoute, (_) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot connect to server")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Image.asset('assets/images/logo.png', height: 120),
              ),
              const SizedBox(height: 20),
              const Text(
                "Collector Portal",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen),
              ),
              const Text("Smart Waste Collector", style: TextStyle(fontSize: 16, color: Colors.grey)),

              const SizedBox(height: 60),

              _buildTextField(_emailController, "Email Address", Icons.email),
              const SizedBox(height: 20),
              _buildPasswordField(),

              const SizedBox(height: 40),

                            const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CollectorRegisterView(),
                        ),
                      );
                    },
                    child: const Text(
                      "Register as Collector",
                      style: TextStyle(
                        color: Color(0xFF3C8D3E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {},
                child: const Text("Forgot Password?", style: TextStyle(color: primaryGreen)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}