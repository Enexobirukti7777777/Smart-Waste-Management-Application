// lib/views/role_selection_view.dart
import 'package:alpha/constants/routes.dart';
import 'package:alpha/services/api_service.dart';
import 'package:flutter/material.dart';

class RoleSelectionView extends StatefulWidget {
  const RoleSelectionView({super.key});

  @override
  State<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<RoleSelectionView> {
  bool isHomeSelected = true;

  // Save role to backend
  Future<void> _selectRole(String role) async {
  setState(() => isHomeSelected = role == "Home");

  try {
    final result = await ApiService().saveUserType(role);

    print("RESULT: $result");

    if (!mounted) return;

    if (result['success'] == true) {
      if (role == "Home") {
        Navigator.of(context).pushReplacementNamed(loginRoute);
      } else {
        Navigator.of(context).pushReplacementNamed(companyRegisterRoute);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Failed')),
      );
    }
  } catch (e) {
    print("ERROR: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cannot connect to server")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);
    const lightGreen = Color(0xFFF2FFEE);

    return Scaffold(
      backgroundColor: lightGreen,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: Image.asset('assets/images/logo.png', height: 110),
            ),
            const SizedBox(height: 30),
            const Text(
              "Welcome to Smart Waste Collector",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
                  child: Column(
                    children: [
                      const Text(
                        "Continue as",
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 40),

                      _buildRoleButton(
                        icon: Icons.home_outlined,
                        title: "Home",
                        subtitle: "Individual / Household",
                        isSelected: isHomeSelected,
                        onTap: () => _selectRole("Home"),
                      ),

                      const SizedBox(height: 20),

                      _buildRoleButton(
                        icon: Icons.business_outlined,
                        title: "Company",
                        subtitle: "Business / Organization",
                        isSelected: !isHomeSelected,
                        onTap: () => _selectRole("Company"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF3C8D3E) : Colors.white, size: 32),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFF3C8D3E) : Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.grey.shade700 : Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}