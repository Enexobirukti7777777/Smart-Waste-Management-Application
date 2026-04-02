import 'package:alpha/constants/routes.dart';
import 'package:flutter/material.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

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

            // Logo
            Center(
              child: Image.asset(
                'assets/images/logo.png', // Put your recycling logo here
                height: 110,
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "Welcome to Smart Waste Collector",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 80),

            // Green curved bottom section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
                  child: Column(
                    children: [
                      const Text(
                        "Continue as",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // User (Home) Button
                      _buildRoleButton(
                        context,
                        icon: Icons.home_outlined,
                        title: "Home",
                        subtitle: "Individual User",
                        isSelected: true,
                        onTap: () {
                          Navigator.of(context).pushNamed(registerRoute);
                        },
                      ),

                      const SizedBox(height: 20),

                      // Company Button
                      _buildRoleButton(
                        context,
                        icon: Icons.business_outlined,
                        title: "Company",
                        subtitle: "Waste Collection Company",
                        isSelected: false,
                        onTap: () {
                          // TODO: Later for company registration
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Company registration coming soon")),
                          );
                        },
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

  Widget _buildRoleButton(
    BuildContext context, {
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
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF3C8D3E) : Colors.white, size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
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