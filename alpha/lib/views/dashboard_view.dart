// lib/views/dashboard_view.dart
import 'package:alpha/constants/routes.dart';
import 'package:alpha/localization/app_localizations.dart';   // ← Added
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool isAmharic = false; // false = English, true = Amharic

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final loc = AppLocalizations.of(context);   // ← Added for localization

    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(
    color: Colors.white, // ✅ hamburger becomes white
  ),
        title: Text(isAmharic ? "ስማርት ቆሻሻ ሰብሳቢ" : "Smart Waste Collector", 
                   style: const TextStyle(color: Colors.white)),
        actions: [
          // Language Switcher
          TextButton(
            onPressed: () {
              setState(() => isAmharic = !isAmharic);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isAmharic 
                      ? "ቋንቋ ወደ አማርኛ ተቀይሯል ✓" 
                      : "Language changed to English ✓"),
                ),
              );
            },
            child: Text(
              isAmharic ? "EN" : "አማ",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/waste_header.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              isAmharic ? "አገልግሎቶች" : "Services",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 16),

            _buildServiceCard(
              isAmharic ? "ተጨማሪ ቆሻሻ መሰብሰቢያ" : "Extra Pickup Request",
              Icons.local_shipping,
              () => Navigator.pushNamed(context, pickupRequestRoute),
            ),
            _buildServiceCard(
              isAmharic ? "ኤአይ ቻት" : "AI Chat",
              Icons.chat_bubble_outline,
              () => Navigator.pushNamed(context, aiChatRoute),
            ),
            _buildServiceCard(
              isAmharic ? "ሰብሳቢውን ተከታተል" : "Track Collector",
              Icons.location_on,
              () => Navigator.pushNamed(context, trackCollectorRoute),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.recycling), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: ""),
        ],
      ),
    );
  }

  // Hamburger Menu (Drawer) 
  Widget _buildDrawer() {
    return Drawer(
      
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Inside _buildDrawer()
Container(
  
          padding: const EdgeInsets.only(top: 60, bottom: 30),
          width: double.infinity,
          color: const Color(0xFF3C8D3E),
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 80,
              ),
              const SizedBox(height: 12),
              const Text(
                "Smart Waste Collector",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
          const SizedBox(height: 20),

ListTile(
  leading: const Icon(Icons.person_outline, color: Color(0xFF3C8D3E)),
  title: const Text("Profile", style: TextStyle(color: Color(0xFF3C8D3E), fontWeight: FontWeight.w600)),
  onTap: () {
    Navigator.pop(context);
    Navigator.pushNamed(context, profileRoute);
  },
),         
ListTile(
  leading: const Icon(Icons.history, color: Color(0xFF3C8D3E)),
  title: const Text("My Requests", style: TextStyle(color: Color(0xFF3C8D3E) ,fontWeight: FontWeight.w600)),
  onTap: () {
    Navigator.pop(context);
    Navigator.pushNamed(context, myRequestsRoute);
  },
),          ListTile(leading: const Icon(Icons.payment, color: Color(0xFF3C8D3E)), title: const Text("Payment & Wallet", style: TextStyle(color: Color(0xFF3C8D3E), fontWeight: FontWeight.w600)), onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, paymentRoute);
          }),
          ListTile(leading: const Icon(Icons.language, color: Color(0xFF3C8D3E)), title: const Text("Language", style: TextStyle(color: Color(0xFF3C8D3E), fontWeight: FontWeight.w600)), onTap: () => Navigator.pop(context)),
ListTile(
  leading: const Icon(Icons.star_outline, color: Color(0xFF3C8D3E)),
  title: const Text("Rate This App", style: TextStyle(color: Color(0xFF3C8D3E) , fontWeight: FontWeight.w600)),
  onTap: () {
    showRateAppDialog(context);
  },
),         

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
              child: Icon(icon, color: const Color(0xFF3C8D3E), size: 28),
            ),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
void showRateAppDialog(BuildContext context) {
  int rating = 0;
  //final TextEditingController feedbackController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              "Rate This App ",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("How was your experience?"),

                const SizedBox(height: 40),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() => rating = index + 1);
                      },
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 30,
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 10),

                // Optional feedback
                
              ],
            ),

            actionsAlignment: MainAxisAlignment.spaceBetween,

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Later"),
              ),

              ElevatedButton(
                onPressed: rating == 0
                    ? null
                    : () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Thanks for your feedback! "),
                          ),
                        );
                      },
                child: const Text("Rate Now"),
              ),
            ],
          );
        },
      );
    },
  );
}