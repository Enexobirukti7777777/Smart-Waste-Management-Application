import 'package:flutter/material.dart';
import 'collector_home_view.dart';

class CollectorLoginView extends StatefulWidget {
  const CollectorLoginView({super.key});

  @override
  State<CollectorLoginView> createState() => _CollectorLoginViewState();
}

class _CollectorLoginViewState extends State<CollectorLoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
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

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Login Successful"), backgroundColor: Colors.green),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CollectorHomeView(
            userEmail: email,
            userName: email.split('@').first,
          ),
        ),
      );
    }

    setState(() => _isLoading = false);
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

              // Logo with fallback
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  
                  
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Collector Portal",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: primaryGreen),
              ),
              const Text(
                "Sign in to manage pickups",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

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
                    : const Text("Login as Collector", style: TextStyle(fontSize: 18)),
              ),

              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Collector registration coming soon")),
                  );
                },
                child: const Text(
                  "Don't have a collector account? Contact Admin",
                  style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                ),
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