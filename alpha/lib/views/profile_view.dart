
// ignore_for_file: unused_element

import 'package:alpha/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    
    final user = FirebaseAuth.instance.currentUser;

    final String displayName = user?.displayName ?? "No Name Set";
    final String email = user?.email ?? "No Email";
    //final String phone = user?.phoneNumber ?? "No Phone Number";

    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Profile"),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 65,
                backgroundColor: Colors.white,
                child: const Icon(Icons.person, size: 80, color: primaryGreen),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              displayName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 50),

            // Information Cards
            //_buildInfoCard("Full Name", displayName),
            //_buildInfoCard("Email Address", email),
            //_buildInfoCard("Phone Number", phone),
            //_buildInfoCard("Member Since", "March 2026"),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}