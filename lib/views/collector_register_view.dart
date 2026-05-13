// lib/views/collector_register_view.dart
import 'package:flutter/material.dart';

class CollectorRegisterView extends StatefulWidget {
  const CollectorRegisterView({super.key});

  @override
  State<CollectorRegisterView> createState() => _CollectorRegisterViewState();
}

class _CollectorRegisterViewState extends State<CollectorRegisterView> {
  int _step = 1; // 1 = Personal, 2 = Collector Info, 3 = Review

  // Step 1 Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Step 2 Controllers
  final _idNumberController = TextEditingController();
  String? selectedExperience;
  String? selectedVehicle;
  final _workingAreaController = TextEditingController();

  // ignore: unused_field
  bool _agreeToTerms = false;
  bool _isLoading = false;

  final List<String> experiences = ["Less than 1 year", "1-3 years", "3-5 years", "More than 5 years"];
  final List<String> vehicles = ["On Foot / Cart", "Motorcycle / Bajaj", "Small Truck", "Large Truck"];

  Future<void> _nextStep() async {
    if (_step == 1) {
      if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _emailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all personal fields")));
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
        return;
      }
      setState(() => _step = 2);
    } else if (_step == 2) {
      if (_idNumberController.text.isEmpty || selectedExperience == null || selectedVehicle == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please complete collector details")));
        return;
      }
      setState(() => _step = 3);
    } else {
      // Submit
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Application Submitted! Waiting for Admin Approval"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStep(1, "Personal"),
                  _buildStep(2, "Info"),
                  _buildStep(3, "Review"),
                ],
              ),
              const SizedBox(height: 30),

              if (_step == 1) _buildPersonalStep()
              else if (_step == 2) _buildCollectorStep()
              else _buildReviewStep(),

              const SizedBox(height: 30),

              Row(
                children: [
                  if (_step > 1)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _step--),
                        child: const Text("Back"),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _nextStep,
                      style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                      child: Text(_step == 3 ? "Submit Application" : "Continue"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int number, String title) {
    bool isActive = _step == number;
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isActive ? Colors.green : Colors.grey,
          child: Text(number.toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 12, color: isActive ? Colors.green : Colors.grey)),
      ],
    );
  }

  Widget _buildPersonalStep() {
    return Column(
      children: [
        _buildTextField(_nameController, "Full Name", Icons.person),
        const SizedBox(height: 16),
        _buildTextField(_phoneController, "Phone Number", Icons.phone, keyboard: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField(_emailController, "Email Address", Icons.email, keyboard: TextInputType.emailAddress),
        const SizedBox(height: 16),
        _buildPasswordField(_passwordController, "Password"),
        const SizedBox(height: 16),
        _buildPasswordField(_confirmPasswordController, "Confirm Password"),
      ],
    );
  }

  Widget _buildCollectorStep() {
    return Column(
      children: [
        _buildTextField(_idNumberController, "National ID / Kebele ID", Icons.badge),
        const SizedBox(height: 20),
        const Text("Years of Experience", style: TextStyle(fontWeight: FontWeight.w600)),
        DropdownButtonFormField<String>(
          value: selectedExperience,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: experiences.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => selectedExperience = v),
        ),
        const SizedBox(height: 20),
        const Text("Vehicle Type", style: TextStyle(fontWeight: FontWeight.w600)),
        DropdownButtonFormField<String>(
          value: selectedVehicle,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: vehicles.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => selectedVehicle = v),
        ),
        const SizedBox(height: 20),
        _buildTextField(_workingAreaController, "Preferred Working Area", Icons.location_city),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Review your information", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _buildReviewItem("Name", _nameController.text),
        _buildReviewItem("Phone", _phoneController.text),
        _buildReviewItem("Email", _emailController.text),
        _buildReviewItem("ID Number", _idNumberController.text),
        _buildReviewItem("Experience", selectedExperience ?? "-"),
        _buildReviewItem("Vehicle", selectedVehicle ?? "-"),
        _buildReviewItem("Area", _workingAreaController.text),
      ],
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label + ":", style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value.isEmpty ? "-" : value)),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboard = TextInputType.text}) {
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