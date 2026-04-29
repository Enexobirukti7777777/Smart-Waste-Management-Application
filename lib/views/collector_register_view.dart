// lib/views/collector_register_view.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CollectorRegisterView extends StatefulWidget {
  const CollectorRegisterView({super.key});

  @override
  State<CollectorRegisterView> createState() => _CollectorRegisterViewState();
}

class _CollectorRegisterViewState extends State<CollectorRegisterView> {
  int _step = 1; // 1 = Personal, 2 = Collector Info, 3 = Success

  // Personal Info
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Collector Info
  final _idNumberController = TextEditingController();
  final _workingAreaController = TextEditingController();

  // Image
  File? _idCardImage;

  bool _agreeToTerms = false;
  bool _isLoading = false;

  final primaryGreen = const Color(0xFF3C8D3E);
  final ImagePicker _picker = ImagePicker();

  // Camera Function
  Future<void> _pickIdCardImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _idCardImage = File(pickedFile.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ ID Card photo captured successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to open camera")),
      );
    }
  }

  void _nextStep() {
    if (_step == 1) {
      if (_nameController.text.isEmpty || 
          _phoneController.text.isEmpty || 
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all personal information")),
        );
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }
      setState(() => _step = 2);
    } 
    else if (_step == 2) {
      if (_idNumberController.text.isEmpty || _workingAreaController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill National ID and Working Area")),
        );
        return;
      }
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please agree to the terms")),
        );
        return;
      }
      setState(() => _step = 3); // Success
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF2FFEE);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Register as Collector"),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStep(1, "Personal", _step >= 1),
                  _buildStep(2, "ID & Area", _step >= 2),
                  _buildStep(3, "Done", _step >= 3),
                ],
              ),
              const SizedBox(height: 30),

              if (_step == 1) _buildPersonalStep()
              else if (_step == 2) _buildCollectorInfoStep()
              else _buildSuccessStep(),

              const SizedBox(height: 30),

              if (_step < 3)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_step > 1)
                      OutlinedButton(
                        onPressed: () => setState(() => _step--),
                        child: const Text("Back"),
                      )
                    else
                      const SizedBox.shrink(),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      child: Text(_step == 2 ? "Submit Application" : "Continue"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int number, String title, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? primaryGreen : Colors.grey.shade300,
          ),
          child: Center(
            child: Text(number.toString(), style: TextStyle(color: isActive ? Colors.white : Colors.grey)),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 12, color: isActive ? primaryGreen : Colors.grey)),
      ],
    );
  }

  Widget _buildPersonalStep() {
    return Column(
      children: [
        _buildTextField(_nameController, "Full Name", Icons.person),
        const SizedBox(height: 16),
        _buildTextField(_phoneController, "Phone Number", Icons.phone, TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField(_emailController, "Email Address", Icons.email, TextInputType.emailAddress),
        const SizedBox(height: 16),
        _buildPasswordField(_passwordController, "Password"),
        const SizedBox(height: 16),
        _buildPasswordField(_confirmPasswordController, "Confirm Password"),
      ],
    );
  }

  Widget _buildCollectorInfoStep() {
    return Column(
      children: [
        // National ID with Camera Button
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _buildTextField(_idNumberController, "National ID / Kebele ID Number", Icons.badge),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickIdCardImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Scan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                if (_idCardImage != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text("✓ Photo Taken", style: TextStyle(color: Colors.green, fontSize: 12)),
                  ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildTextField(_workingAreaController, "Preferred Working Area", Icons.location_city),

        const SizedBox(height: 24),

        Row(
          children: [
            Checkbox(
              value: _agreeToTerms,
              onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
              activeColor: primaryGreen,
            ),
            const Expanded(
              child: Text("I agree to the terms and conditions for collectors"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 100, color: Colors.green),
          const SizedBox(height: 24),
          const Text(
            "Application Submitted Successfully!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            "Your application is under review.\nYou will be notified once approved.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
            child: const Text("Back to Login"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, [TextInputType keyboard = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}