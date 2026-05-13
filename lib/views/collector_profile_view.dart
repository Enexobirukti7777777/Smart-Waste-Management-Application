// lib/collector_views/collector_profile_view.dart
import 'package:collector_app/constants/routes.dart';
import 'package:collector_app/services/api_service.dart';
import 'package:flutter/material.dart';

class CollectorProfileView extends StatefulWidget {
  const CollectorProfileView({super.key});

  @override
  State<CollectorProfileView> createState() => _CollectorProfileViewState();
}

class _CollectorProfileViewState extends State<CollectorProfileView> {
  static const primaryGreen = Color(0xFF3C8D3E);
  static const bgColor = Color(0xFFF2FFEE);

  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService().getCollectorProfile();
      setState(() {
        _profile = data;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ApiService().logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, collectorLoginRoute, (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        title: const Text("My Profile"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.pushNamed(context, collectorEditProfileRoute),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : RefreshIndicator(
              color: primaryGreen,
              onRefresh: _loadProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    _buildStatsRow(),
                    const SizedBox(height: 16),
                    _buildInfoSection(),
                    const SizedBox(height: 16),
                    _buildMenuSection(),
                    const SizedBox(height: 32),
                    _buildLogoutButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    final profile = _profile;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3C8D3E), Color(0xFF5BB55D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white24,
                backgroundImage: profile?['photoUrl'] != null
                    ? NetworkImage(profile!['photoUrl'])
                    : null,
                child: profile?['photoUrl'] == null
                    ? const Icon(Icons.person, size: 52, color: Colors.white)
                    : null,
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, size: 16, color: primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            profile?['name'] ?? 'Collector',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            profile?['email'] ?? '',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge(
                profile?['isVerified'] == true ? Icons.verified : Icons.pending_outlined,
                profile?['isVerified'] == true ? "Verified" : "Pending Approval",
                profile?['isVerified'] == true ? Colors.greenAccent : Colors.orangeAccent,
              ),
              const SizedBox(width: 8),
              _buildBadge(Icons.star_rounded, "${profile?['rating']?.toStringAsFixed(1) ?? '--'} Rating", Colors.yellow),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final profile = _profile;
    return Transform.translate(
      offset: const Offset(0, -16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16)],
        ),
        child: Row(
          children: [
            _buildStatItem("Total Jobs", profile?['totalJobs']?.toString() ?? '0', primaryGreen),
            _buildStatDivider(),
            _buildStatItem("This Month", profile?['monthJobs']?.toString() ?? '0', Colors.blue),
            _buildStatDivider(),
            _buildStatItem("Earnings", "${profile?['totalEarnings']?.toStringAsFixed(0) ?? '0'} ETB", Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 40, color: Colors.grey.shade200);
  }

  Widget _buildInfoSection() {
    final profile = _profile;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Personal Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.phone_outlined, "Phone", profile?['phone'] ?? 'N/A'),
          const Divider(height: 20),
          _buildInfoRow(Icons.directions_car_outlined, "Vehicle", profile?['vehicle'] ?? 'N/A'),
          const Divider(height: 20),
          _buildInfoRow(Icons.work_outline, "Experience", profile?['experience'] ?? 'N/A'),
          const Divider(height: 20),
          _buildInfoRow(Icons.location_city_outlined, "Working Area", profile?['workingArea'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: primaryGreen),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.history_rounded, "Job History", () => Navigator.pushNamed(context, collectorJobHistoryRoute)),
          _buildDivider(),
          _buildMenuItem(Icons.account_balance_wallet_outlined, "Earnings & Payments", () => Navigator.pushNamed(context, collectorEarningsRoute)),
          _buildDivider(),
          _buildMenuItem(Icons.notifications_outlined, "Notification Settings", () {}),
          _buildDivider(),
          _buildMenuItem(Icons.lock_outline, "Change Password", () {}),
          _buildDivider(),
          _buildMenuItem(Icons.help_outline, "Help & Support", () {}),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: primaryGreen.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: primaryGreen),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 68);
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout_rounded, color: Colors.red),
          label: const Text("Log Out", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }
}