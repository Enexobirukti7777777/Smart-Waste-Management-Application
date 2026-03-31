import 'package:alpha/constants/routes.dart';
import 'package:alpha/views/login_view.dart' show showErrorDialog;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  int _step = 1; // 1 = personal, 2 = address, 3 = success

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _homeNumberController = TextEditingController();

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
    super.dispose();
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (password != confirm) {
      await showErrorDialog(context, 'Passwords do not match');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.sendEmailVerification();

      // TODO: Save extra fields to Firestore / your database
      // Example:
      // await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
      //   'name': _nameController.text.trim(),
      //   'phone': _phoneController.text.trim(),
      //   'city': _cityController.text.trim(),
      //   'street': _streetController.text.trim(),
      //   'homeNumber': _homeNumberController.text.trim(),
      // });

      setState(() {
        _step = 3;
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      String msg = e.message ?? 'Error occurred';
      if (e.code == 'weak-password') msg = 'Password is too weak';
      if (e.code == 'email-already-in-use') msg = 'Email already in use';
      if (e.code == 'invalid-email') msg = 'Invalid email';
      await showErrorDialog(context, msg);
      setState(() => _isLoading = false);
    } catch (e) {
      await showErrorDialog(context, e.toString());
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
        child: _step == 3
            ? _buildSuccessScreen(primaryGreen)
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Logo (recycling leaf)
                    Image.asset(
                    'assets/istockphoto-1384532150-612x612-removebg-preview (1).png',
             height: 100,   // ← adjust size to match your Figma (e.g. 90, 120, 140)
               fit: BoxFit.contain,   // keeps proportions, no stretching
                    ),
                    // Or use Image.asset('assets/logo.png') if you have custom asset

                    const SizedBox(height: 32),

                    Text(
                      _step == 1 ? 'Personal Information' : 'Address Details',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _step == 1
                          ? 'Please fill in your details'
                          : 'Where do you live?',
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height:20),

                    if (_step == 1) ...[
                      _buildTextField(_nameController, 'Full Name', 'Enter full name', Icons.person_outline),
                      const SizedBox(height: 20),
                      _buildTextField(_emailController, 'Email Address', 'Enter email', Icons.email_outlined,
                          keyboard: TextInputType.emailAddress),
                      const SizedBox(height: 20),
                      _buildPasswordField(_passwordController, 'Password', 'Enter password', _obscurePassword,
                          () => setState(() => _obscurePassword = !_obscurePassword)),
                      const SizedBox(height: 20),
                      _buildPasswordField(_confirmPasswordController, 'Confirm Password', 'Confirm password',
                          _obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm)),
                      const SizedBox(height: 20),
                      _buildTextField(_phoneController, 'Phone', 'Enter phone number', Icons.phone_outlined,
                          keyboard: TextInputType.phone),
                    ] else ...[
                      _buildTextField(_cityController, 'City', 'Enter your city', Icons.location_city_outlined),
                      const SizedBox(height: 20),
                      _buildTextField(_streetController, 'Street Address', 'Enter your street address', Icons.home_outlined),
                      const SizedBox(height: 20),
                      _buildTextField(_homeNumberController, 'Home Number', 'Enter your home number', Icons.pin),
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
                          const Expanded(
                            child: Text(
                              'I agree to the terms & policy',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 32),

                    // Buttons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_step == 2)
                          OutlinedButton(
                            onPressed: () => setState(() => _step = 1),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryGreen,
                              side: BorderSide(color: primaryGreen),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
                                    if (_nameController.text.trim().isEmpty ||
                                        _emailController.text.trim().isEmpty ||
                                        _passwordController.text.isEmpty) {
                                      showErrorDialog(context, 'Please fill required fields');
                                      return;
                                    }
                                    setState(() => _step = 2);
                                  } else {
                                    if (!_agreeToTerms) {
                                      showErrorDialog(context, 'You must agree to the terms');
                                      return;
                                    }
                                    _register();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : Text(_step == 1 ? 'Next' : 'Agree and Register'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                      },
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    String hint,
    bool obscure,
    VoidCallback toggle,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }

  Widget _buildSuccessScreen(Color primaryGreen) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10)),
                ],
              ),
              child: Icon(
                Icons.check_circle,
                size: 120,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Successful Registration!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Please check your email to verify your account.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Back to Login', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}