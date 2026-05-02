// lib/views/pickup_request_view.dart
import 'package:alpha/constants/routes.dart';
import 'package:alpha/services/api_service.dart';
import 'package:flutter/material.dart';

class PickupRequestView extends StatefulWidget {
  const PickupRequestView({super.key});

  @override
  State<PickupRequestView> createState() => _PickupRequestViewState();
}

class _PickupRequestViewState extends State<PickupRequestView> {
  bool recyclable = false;
  bool nonRecyclable = false;

  String? selectedMaterial;
  final _weightController = TextEditingController();
  final _packsController = TextEditingController();

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFF5),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("New Pickup Request"),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What waste do you want to dispose?", 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            CheckboxListTile(
              title: const Text("Recyclable Waste"),
              subtitle: const Text("Plastic, Metal, Paper..."),
              value: recyclable,
              activeColor: primaryGreen,
              onChanged: (val) => setState(() => recyclable = val!),
            ),

            if (recyclable) ...[
              const Divider(),
              const Text("Select Material", style: TextStyle(fontWeight: FontWeight.w600)),
              RadioListTile(value: "plastic", groupValue: selectedMaterial, title: const Text("Plastic"), onChanged: (v) => setState(() => selectedMaterial = v)),
              RadioListTile(value: "metal", groupValue: selectedMaterial, title: const Text("Metal"), onChanged: (v) => setState(() => selectedMaterial = v)),
              RadioListTile(value: "others", groupValue: selectedMaterial, title: const Text("Others"), onChanged: (v) => setState(() => selectedMaterial = v)),
              const SizedBox(height: 20),
              const Text("Weight (kg)", style: TextStyle(fontWeight: FontWeight.w600)),
              TextField(controller: _weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder())),
            ],

            const SizedBox(height: 10),

            CheckboxListTile(
              title: const Text("Non-Recyclable Waste"),
              subtitle: const Text("General waste, food waste..."),
              value: nonRecyclable,
              activeColor: primaryGreen,
              onChanged: (val) => setState(() => nonRecyclable = val!),
            ),

            if (nonRecyclable) ...[
              const Divider(),
              const Text("Number of Packs", style: TextStyle(fontWeight: FontWeight.w600)),
              TextField(controller: _packsController, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder())),
            ],

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitToBackend,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                minimumSize: const Size(double.infinity, 58),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Submit Request", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitToBackend() async {
    if (!recyclable && !nonRecyclable) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select at least one type")));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      double kg = 0;
      if (recyclable && _weightController.text.isNotEmpty) {
        kg = double.tryParse(_weightController.text) ?? 0;
      } else if (nonRecyclable && _packsController.text.isNotEmpty) {
        kg = (double.tryParse(_packsController.text) ?? 0) * 2;
      }

      // ✅ Use real logged-in email (passed from navigation)
      final String currentUserEmail = "test@example.com";   // TODO: Replace with real email later

      final result = await ApiService().submitPickup(
        kg: kg,
        userEmail: currentUserEmail,     // ← Fixed here
      );

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Request submitted successfully!")),
        );
        Navigator.pushNamed(context, statusCheckRoute);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Connection error")));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
}