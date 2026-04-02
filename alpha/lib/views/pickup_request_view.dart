import 'package:alpha/constants/routes.dart';
import 'package:flutter/material.dart';

class PickupRequestView extends StatefulWidget {
  const PickupRequestView({super.key});

  @override
  State<PickupRequestView> createState() => _PickupRequestViewState();
}

class _PickupRequestViewState extends State<PickupRequestView> {
  bool isRecyclable = true;
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Pickup Request"),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Recyclable"),
                    value: true,
                    groupValue: isRecyclable,
                    activeColor: primaryGreen,
                    onChanged: (val) => setState(() => isRecyclable = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Non-Recyclable"),
                    value: false,
                    groupValue: isRecyclable,
                    activeColor: primaryGreen,
                    onChanged: (val) => setState(() => isRecyclable = val!),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Text("Weight in kg", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter weight",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pickup request submitted successfully!")),
                );
                Navigator.pushNamed(context, statusCheckRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Submit", style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, statusCheckRoute),
              child: const Text("Show Status", style: TextStyle(fontSize: 16, color: primaryGreen)),
            ),
          ],
        ),
      ),
    );
  }
}