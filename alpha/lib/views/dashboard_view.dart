import 'package:alpha/constants/routes.dart';
import 'package:alpha/services/api_service.dart';
import 'package:alpha/views/show_rate_app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class DashboardView extends StatefulWidget {
  final String userEmail;

const DashboardView({super.key, required this.userEmail});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool isAmharic = false;
  int _currentIndex = 0;

  final ApiService _apiService = ApiService();

  
  List<dynamic> notifications = [];
  bool isLoadingNotifications = false;
  int unreadCount = 0;
  late IO.Socket socket;          // ← This must be here
String get userEmail => widget.userEmail;
  @override
  void initState() {
    super.initState();
    print("✅ Dashboard opened for user: $userEmail");
    _connectSocket();
  }

  void _connectSocket() {
    socket = IO.io(ApiService.baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });

    socket.onConnect((_) {
      print("✅ Socket Connected for $userEmail");
      socket.emit("join-user", userEmail);
    });

    socket.on("price-notification", (data) {
      print("🔔 New Notification Received: $data");
      setState(() {
        notifications.insert(0, data);
        unreadCount++;
      });
    });

    socket.onDisconnect((_) => print("🔴 Socket Disconnected"));
  }

  Future<void> _fetchNotifications() async {
    setState(() => isLoadingNotifications = true);
    print("🔄 Fetching notifications for: $userEmail");

    try {
      final result = await _apiService.getNotifications(userEmail);
      print("✅ Got ${result.length} notifications");
      setState(() {
        notifications = result;
        unreadCount = result.length;
      });
    } catch (e) {
      print("❌ Error fetching notifications: $e");
    } finally {
      setState(() => isLoadingNotifications = false);
    }
  }

  void _showNotifications(BuildContext context) {
    _fetchNotifications();
  
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Notifications",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: isLoadingNotifications
                    ? const Center(child: CircularProgressIndicator())
                    : notifications.isEmpty
                        ? const Center(child: Text("No notifications yet"))
                        : ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final n = notifications[index];
                              return ListTile(
                                leading: const Icon(Icons.notifications, color: Colors.green),
                                title: Text(n['message'] ?? "Pickup Update"),
                                subtitle: Text("Price: ${n['price'] ?? 'N/A'} ETB"),
                                trailing: Text(
                                  (n['status'] ?? "").toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  // carousel
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
                color: Color(0xFFF2FFEE),
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
    const primaryGreen = Color(0xFF3C8D3E);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFEE),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color:   Color(0xFFF2FFEE)),
        title: Text(
          isAmharic ? "ስማርት ቆሻሻ ሰብሳቢ" : "Smart Waste ",
          style: GoogleFonts.poppins(color: const Color(0xFFF2FFEE) , fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Notification Icon with Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () => _showNotifications(context),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount > 9 ? "9+" : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:   Color(0xFFF2FFEE),
              ),
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
                height: 180,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
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
                _buildCarouselItem(
                  image: 'assets/images/waste_header.png',
                  title: 'Smart Waste Management',
                  subtitle: 'Together for a cleaner city',
                ),
                _buildCarouselItem(
                  image: 'assets/images/boy.jpg',
                  title: 'Need Extra Pickup?',
                  subtitle: 'Book now ',
                ),
                _buildCarouselItem(
                  image: 'assets/images/ai.webp',
                  title: 'Ask AI Assistant',
                  subtitle: 'Ask anything',
                ),
              ],
            ),
            const SizedBox(height: 35),
            Text(
              isAmharic ? "አገልግሎቶች" : "Services",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 19),
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
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, trackCollectorRoute);
              break;
            case 2:
              Navigator.pushNamed(context, pickupRequestRoute);
              break;
            case 3:
              Navigator.pushNamed(context, aiChatRoute);
              break;
            case 4:
              Navigator.pushNamed(context, profileRoute);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Track"),
          BottomNavigationBarItem(icon: Icon(Icons.recycling, size: 32), label: "Pickup"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF3C8D3E),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            width: double.infinity,
            color: Color(0xFFF2FFEE),
            child: Column(
              children: [
                Image.asset('assets/images/logo.png', height: 80),
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
            leading: const Icon(Icons.person_outline, color: Color(0xFFF2FFEE)),
            title: const Text("Profile", style: TextStyle(color: Color(0xFFF2FFEE), fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, profileRoute);
            },
          ),
          ListTile(
  leading: const Icon(Icons.history, color: Color(0xFFF2FFEE)),
  title: const Text("My Requests", style: TextStyle(color: Color(0xFFF2FFEE), fontWeight: FontWeight.w600)),
  onTap: () {
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      myRequestsRoute,
      arguments: userEmail,        // ← This line is very important
    );
  },
),
          ListTile(
            leading: const Icon(Icons.payment, color:Color(0xFFF2FFEE) ),
            title: const Text("Payment & Wallet", style: TextStyle(color: Color(0xFFF2FFEE), fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, paymentRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFFF2FFEE)),
            title: const Text("Language", style: TextStyle(color: Color(0xFFF2FFEE), fontWeight: FontWeight.w600)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.star_outline, color: Color(0xFFF2FFEE)),
            title: const Text("Rate This App", style: TextStyle(color: Color(0xFFF2FFEE), fontWeight: FontWeight.w600)),
            onTap: () => showRateAppDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Color.fromARGB(255, 206, 56, 45)),
            title: const Text("Logout", style: TextStyle(color: Color.fromARGB(255, 206, 56, 45), fontWeight: FontWeight.w600)),
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, roleSelectionRoute, (route) => false),
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
          boxShadow: [BoxShadow(color:  Color(0xFF2E7D32).withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
              child: Icon(icon, color: const Color(0xFF3C8D3E), size: 28),
            ),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(color:  Color(0xFF2E7D32), fontSize: 17, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

