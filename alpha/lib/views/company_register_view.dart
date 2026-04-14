// lib/views/company_register_view.dart
import 'package:alpha/constants/routes.dart';
import 'package:alpha/services/api_service.dart';
import 'package:alpha/utils/dialog_helper.dart';
import 'package:flutter/material.dart';

class CompanyRegisterView extends StatefulWidget {
  const CompanyRegisterView({super.key});

  @override
  State<CompanyRegisterView> createState() => _CompanyRegisterViewState();
}

class _CompanyRegisterViewState extends State<CompanyRegisterView> {
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;
  bool _agreeToTerms = false;

  Future<void> _registerCompany() async {
  setState(() => _isLoading = true);

  if (_passwordController.text != _confirmPasswordController.text) {
    await showErrorDialog(context, "Passwords do not match");
    setState(() => _isLoading = false);
    return;
  }

  try {
    final result = await ApiService().registerCompany(
      companyName: _companyNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
     // confirmPassword: _confirmPasswordController.text.trim(),
      //phone: _phoneController.text.trim(),
);
    if (result['accessToken'] != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
    } else {
      await showErrorDialog(context, result['message'] ?? "Registration failed");
    }
  } catch (e) {
    await showErrorDialog(context, "Cannot connect to server");
  } finally {
    setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(title: const Text("Company Registration"), backgroundColor: primaryGreen),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Company Registration", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            _buildTextField(_companyNameController, "Company Name", Icons.business),
            const SizedBox(height: 16),
            _buildTextField(_emailController, "Email Address", Icons.email),
            const SizedBox(height: 16),
            _buildTextField(_phoneController, "Phone Number", Icons.phone),
            const SizedBox(height: 16),
            _buildTextField(_addressController, "Company Address", Icons.location_on),
            const SizedBox(height: 16),
            _buildPasswordField(_passwordController, "Password"),
            const SizedBox(height: 16),
            _buildPasswordField(_confirmPasswordController, "Confirm Password"),

            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(value: _agreeToTerms, onChanged: (v) => setState(() => _agreeToTerms = v!)),
                const Expanded(child: Text("I agree to the terms & policy")),
              ],
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _registerCompany,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                minimumSize: const Size(double.infinity, 56),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Register Company", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}