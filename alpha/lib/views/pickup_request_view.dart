import 'package:alpha/constants/routes.dart';
import 'package:flutter/material.dart';

class PickupRequestView extends StatefulWidget {
  const PickupRequestView({super.key});

  @override
  State<PickupRequestView> createState() => _PickupRequestViewState();
}

class _PickupRequestViewState extends State<PickupRequestView> {
  late bool isRecyclable;

  bool plastic = false;
  bool metal = false;
  bool others = false;
  final _weightController = TextEditingController();
  final _packsController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isRecyclable = ModalRoute.of(context)?.settings.arguments as bool? ?? true;
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: Text(isRecyclable ? "Recyclable Waste" : "Non-Recyclable Waste"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRecyclable) ...[
              const Text("Select Type", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              CheckboxListTile(title: const Text("Plastic"), value: plastic, onChanged: (v) => setState(() => plastic = v!)),
              CheckboxListTile(title: const Text("Metal"), value: metal, onChanged: (v) => setState(() => metal = v!)),
              CheckboxListTile(title: const Text("Others"), value: others, onChanged: (v) => setState(() => others = v!)),

              const SizedBox(height: 30),
              const Text("Weight (kg)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              TextField(controller: _weightController, keyboardType: TextInputType.number),
            ] else ...[
              const Text("Number of Packs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextField(controller: _packsController, keyboardType: TextInputType.number),
            ],

            const Spacer(),

            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, statusCheckRoute),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}