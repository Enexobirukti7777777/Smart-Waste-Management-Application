import 'package:flutter/material.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Payment & Wallet"),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text(
                    "Your Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "248.50 Birr",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Payment Methods",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Payment Methods
            _buildPaymentMethod(
              "Tele Birr",
              "**** **** 7845",
              Icons.phone_android,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildPaymentMethod(
              "CBE Birr",
              "**** **** 3921",
              Icons.account_balance,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildPaymentMethod(
              "Credit Card",
              "Visa •••• 4242",
              Icons.credit_card,
              Colors.purple,
            ),

            const SizedBox(height: 30),

            const Text(
              "Recent Transactions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildTransaction("Pickup Request", "- 45 Birr", "Today"),
            _buildTransaction("Wallet Top-up", "+ 300 Birr", "Yesterday"),
            _buildTransaction("Pickup Request", "- 60 Birr", "2 days ago"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        onPressed: () {
          // Add new payment method
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Add new payment method coming soon")),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPaymentMethod(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _buildTransaction(String title, String amount, String time) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.receipt_long, color: Colors.grey),
      title: Text(title),
      subtitle: Text(time),
      trailing: Text(
        amount,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: amount.startsWith('+') ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}