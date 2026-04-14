import 'package:alpha/constants/routes.dart';
import 'package:alpha/localization/app_localizations.dart';   
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool isAmharic = false; 
 int _currentIndex = 0;       
 Widget _buildCarouselItem({
  required String image,
  required String title,
  required String subtitle,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final loc = AppLocalizations.of(context);   

    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(
    color: Colors.white,
  ),
        title: Text(isAmharic ? "ስማርት ቆሻሻ ሰብሳቢ" : "Smart Waste ", 
                   style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(context),
          ),
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
            CarouselSlider(
  options: CarouselOptions(
    height: 170,
autoPlay: true,
autoPlayInterval: const Duration(seconds: 6),
  autoPlayCurve: Curves.easeInOutCubic,

autoPlayAnimationDuration: const Duration(milliseconds: 4000),
enlargeCenterPage: true,
enlargeStrategy: CenterPageEnlargeStrategy.height,
viewportFraction: 0.85,
aspectRatio: 16 / 9,
enableInfiniteScroll: true,
scrollDirection: Axis.horizontal,
pauseAutoPlayOnTouch: true,
  ),
  items: [
    // Slide 1 - Current header
    _buildCarouselItem(
      image: 'assets/images/waste_header.png',
      title: 'Smart Waste Management',
      subtitle: 'Together for a cleaner city',
    ),
    
    // Slide 2 - Add more promotional slides
    _buildCarouselItem(
      image: 'assets/images/boy.jpg', // Add this image
      title: 'Need Extra Pickup?',
      subtitle: 'Book now ',
    ),
    
    // Slide 3
    _buildCarouselItem(
      image: 'assets/images/ai.webp',
      title: 'Ask AI Assistant',
      subtitle: 'Ask anything',
    ),
  ],
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
  currentIndex: _currentIndex,           // We'll add this
  onTap: (index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0: // Home
        // Already on dashboard
        break;
      case 1: // Map / Track
        Navigator.pushNamed(context, trackCollectorRoute);
        break;
      case 2: // Center Big Button - Pickup Request
        Navigator.pushNamed(context, pickupRequestRoute);
        break;
      case 3: // AI Chat
        Navigator.pushNamed(context, aiChatRoute);
        break;
      case 4: // Profile
        Navigator.pushNamed(context, profileRoute);
        break;
    }
  },
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.location_on),
      label: "Track",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.recycling, size: 32),   // Bigger center icon
      label: "Pickup",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: "Chat",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Profile",
    ),
  ],
),
    );
  }

  // Hamburger Menu (Drawer) 
  Widget _buildDrawer() {
    return Drawer(
      
      backgroundColor: Color(0xFF3C8D3E),
      child: Column(
        children: [
          // Inside _buildDrawer()
Container(
  
          padding: const EdgeInsets.only(top: 60, bottom: 30),
          width: double.infinity,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 80,
              ),
              const SizedBox(height: 1),
              const Text(
                "kuralewo",
                style: TextStyle(
                  color: Color(0xFF3C8D3E),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
            ],
          ),
        ),
          const SizedBox(height: 20),

ListTile(
  leading: const Icon(Icons.person_outline, color: Color.fromARGB(255, 252, 252, 252)),
  title: const Text("Profile", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.w600)),
  onTap: () {
    Navigator.pop(context);
    Navigator.pushNamed(context, profileRoute);
  },
),         
ListTile(
  leading: const Icon(Icons.history, color: Color.fromARGB(255, 255, 255, 255)),
  title: const Text("My Requests", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255) ,fontWeight: FontWeight.w600)),
  onTap: () {
    Navigator.pop(context);
    Navigator.pushNamed(context, myRequestsRoute);
  },
),          ListTile(leading: const Icon(Icons.payment, color: Color.fromARGB(255, 255, 255, 255)), title: const Text("Payment & Wallet", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.w600)), onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, paymentRoute);
          }),
          ListTile(leading: const Icon(Icons.language, color: Color.fromARGB(255, 255, 255, 255)), title: const Text("Language", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.w600)), onTap: () => Navigator.pop(context)),
ListTile(
  leading: const Icon(Icons.star_outline, color: Color.fromARGB(255, 255, 255, 255)),
  title: const Text("Rate This App", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255) , fontWeight: FontWeight.w600)),
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
}void _showNotifications(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "Notifications",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("New message received"),
              subtitle: Text("2 minutes ago"),
            ),
            // Add more notifications here...
          ],
        ),
      );
    },
  );
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