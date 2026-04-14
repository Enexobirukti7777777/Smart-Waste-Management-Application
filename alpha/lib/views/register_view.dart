// lib/views/register_view.dart
import 'package:alpha/constants/routes.dart';
import 'package:alpha/services/api_service.dart';
import 'package:alpha/utils/dialog_helper.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  int _step = 1; // 1 = Personal, 2 = Address, 3 = OTP, 4 = Success

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _homeNumberController = TextEditingController();
  final _otpController = TextEditingController();

  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _homeNumberController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (password != confirm) {
      await showErrorDialog(context, 'Passwords do not match');
      setState(() => _isLoading = false);
      return;
    }

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      await showErrorDialog(context, 'Full Name, Email and Password are required');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final result = await ApiService().sendOtp(name: name, email: email);

      if (result['success'] == true) {
        setState(() => _step = 3); // Go to OTP screen
      } else {
        await showErrorDialog(context, result['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      await showErrorDialog(context, 'Cannot connect to server');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    setState(() => _isLoading = true);

    try {
      final result = await ApiService().verifyOtpAndRegister(
        email: _emailController.text.trim(),
        otp: _otpController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (result['success'] == true) {
        setState(() => _step = 4);
      } else {
        await showErrorDialog(context, result['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      await showErrorDialog(context, 'Verification failed');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);
    const bgGreen = Color(0xFFF2FFEE);

    return Scaffold(
      backgroundColor: bgGreen,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 1,
      ),
      body: SafeArea(
        child: _step == 4
            ? _buildSuccessScreen(primaryGreen)
            : _step == 3
                ? _buildOtpScreen(primaryGreen)
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Image.asset('assets/images/logo.png', height: 100),
                        const SizedBox(height: 30),

                        Text(
                          _step == 1 ? 'Personal Information' : 'Address Details',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _step == 1 ? 'Please fill in your details' : 'Where do you live?',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 30),

                        if (_step == 1) ...[
                          _buildTextField(_nameController, 'Full Name', 'Enter full name', Icons.person_outline),
                          const SizedBox(height: 18),
                          _buildTextField(_emailController, 'Email Address', 'Enter your email', Icons.email_outlined, keyboard: TextInputType.emailAddress),
                          const SizedBox(height: 18),
                          _buildPasswordField(_passwordController, 'Password', _obscurePassword),
                          const SizedBox(height: 18),
                          _buildPasswordField(_confirmPasswordController, 'Confirm Password', _obscureConfirm),
                          const SizedBox(height: 18),
                          _buildTextField(_phoneController, 'Phone', 'Enter phone number', Icons.phone_outlined, keyboard: TextInputType.phone),
                        ] else ...[
                          _buildTextField(_cityController, 'City', 'Enter your city', Icons.location_city),
                          const SizedBox(height: 18),
                          _buildTextField(_streetController, 'Street Address', 'Enter your street address', Icons.home),
                          const SizedBox(height: 18),
                          _buildTextField(_homeNumberController, 'Home Number', 'Enter your home number', Icons.pin_drop),
                        ],

                        const SizedBox(height: 24),

                        if (_step == 2)
                          Row(
                            children: [
                              Checkbox(
                                value: _agreeToTerms,
                                activeColor: primaryGreen,
                                onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                              ),
                              const Expanded(child: Text('I agree to the terms & policy', style: TextStyle(fontSize: 14))),
                            ],
                          ),

                        const SizedBox(height: 40),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_step == 2)
                              OutlinedButton(
                                onPressed: () => setState(() => _step = 1),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primaryGreen,
                                  side: const BorderSide(color: primaryGreen),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Back'),
                              )
                            else
                              const SizedBox.shrink(),

                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      if (_step == 1) {
                                        setState(() => _step = 2);
                                      } else {
                                        if (!_agreeToTerms) {
                                          showErrorDialog(context, 'You must agree to the terms & policy');
                                          return;
                                        }
                                        _sendOtp();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _isLoading
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                                  : Text(_step == 1 ? 'Next' : 'Send OTP'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, loginRoute, (_) => false),
                          child: const Text('Back to Login', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  
  Widget _buildOtpScreen(Color primaryGreen) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Enter OTP", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("We sent a code to ${_emailController.text}", textAlign: TextAlign.center),
          const SizedBox(height: 40),

          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            decoration: const InputDecoration(hintText: "000000", border: OutlineInputBorder()),
          ),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _isLoading ? null : _verifyOtp,
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, minimumSize: const Size(double.infinity, 56)),
            child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Verify OTP"),
          ),
        ],
      ),
    );
  }

  
  Widget _buildSuccessScreen(Color primaryGreen) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)]),
              child: Icon(Icons.check_circle, size: 110, color: primaryGreen),
            ),
            const SizedBox(height: 40),
            const Text('Successful Registration!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
            const SizedBox(height: 12),
            const Text('Please check your email to verify your account.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, loginRoute, (_) => false),
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Back to Login', style: TextStyle(fontSize: 17)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => obscure == _obscurePassword ? _obscurePassword = !_obscurePassword : _obscureConfirm = !_obscureConfirm),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}