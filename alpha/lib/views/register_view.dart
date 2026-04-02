
import 'package:alpha/constants/routes.dart';
import 'package:alpha/utils/dialog_helper.dart';           
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  int _step = 1; // 1 = Personal Info, 2 = Address, 3 = Success

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

    if (email.isEmpty || password.isEmpty) {
      await showErrorDialog(context, 'Email and Password are required');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.sendEmailVerification();

      // TODO: Save additional user data to Firestore later

      setState(() {
        _step = 3;
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      String msg = 'Registration failed';
      if (e.code == 'weak-password') msg = 'Password is too weak';
      if (e.code == 'email-already-in-use') msg = 'This email is already registered';
      if (e.code == 'invalid-email') msg = 'Invalid email address';

      await showErrorDialog(context, msg);
      setState(() => _isLoading = false);
    } catch (e) {
      await showErrorDialog(context, 'Something went wrong. Please try again.');
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
        toolbarHeight: 1, // Minimal appbar like your design
      ),
      body: SafeArea(
        child: _step == 3
            ? _buildSuccessScreen(primaryGreen)
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Logo
                    Image.asset(
                      'assets/images/logo.png', // ← Change to your actual logo path
                      height: 100,
                    ),

                    const SizedBox(height: 30),

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
                      _step == 1 ? 'Please fill in your details' : 'Where do you live?',
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 30),

                    if (_step == 1) ...[
                      _buildTextField(_nameController, 'Full Name', 'Enter full name', Icons.person_outline),
                      const SizedBox(height: 18),
                      _buildTextField(_emailController, 'Email Address', 'Enter your email', Icons.email_outlined,
                          keyboard: TextInputType.emailAddress),
                      const SizedBox(height: 18),
                      _buildPasswordField(_passwordController, 'Password', _obscurePassword, () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      }),
                      const SizedBox(height: 18),
                      _buildPasswordField(_confirmPasswordController, 'Confirm Password', _obscureConfirm, () {
                        setState(() => _obscureConfirm = !_obscureConfirm);
                      }),
                      const SizedBox(height: 18),
                      _buildTextField(_phoneController, 'Phone', 'Enter phone number', Icons.phone_outlined,
                          keyboard: TextInputType.phone),
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
                          const Expanded(
                            child: Text(
                              'I agree to the terms & policy',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
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
                                    if (_nameController.text.trim().isEmpty ||
                                        _emailController.text.trim().isEmpty ||
                                        _passwordController.text.isEmpty) {
                                      showErrorDialog(context, 'Please fill all required fields');
                                      return;
                                    }
                                    setState(() => _step = 2);
                                  } else {
                                    if (!_agreeToTerms) {
                                      showErrorDialog(context, 'You must agree to the terms & policy');
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
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                )
                              : Text(_step == 1 ? 'Next' : 'Agree and Register'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false),
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Reusable TextField
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
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }

  // Reusable Password Field
  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    bool obscure,
    VoidCallback toggle,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Success Screen
  Widget _buildSuccessScreen(Color primaryGreen) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Icon(
                Icons.check_circle,
                size: 110,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Successful Registration!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please check your email to verify your account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Back to Login', style: TextStyle(fontSize: 17)),
            ),
          ],
        ),
      ),
    );
  }
}