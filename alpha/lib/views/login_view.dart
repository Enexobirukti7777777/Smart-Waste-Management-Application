// lib/views/login_view.dart
import 'package:alpha/constants/routes.dart';
import 'package:alpha/services/api_service.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
      final result = await ApiService().login(email, password);

      if (result['success'] == true || result['accessToken'] != null) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, dashboardRoute, (_) => false);
        }
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);
    const bgColor = Color(0xFFF2FFEE);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(child: Image.asset('assets/images/logo.png', height: 100)),
              const SizedBox(height: 20),
              const Text("Smart Waste Collector",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryGreen)),

              const SizedBox(height: 60),

              _buildTextField(_emailController, "Enter your email", Icons.email_outlined),
              const SizedBox(height: 20),
              _buildPasswordField(),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login", style: TextStyle(fontSize: 18)),
              ),

              const SizedBox(height: 30),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, registerRoute),
                child: const Text("Don't have an account? Register Now",
                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600)),
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
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: "Enter your password",
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}