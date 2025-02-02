import 'package:flutter/material.dart';
import 'package:sham_app/pages/authentication/login_page.dart';

class ShamDrawer extends StatelessWidget {
  const ShamDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Drawer Header with a custom background and text style
              const DrawerHeader(
                decoration: BoxDecoration(
                  color:  Color(0xFF3CCECC), // Choose a color or add an image
                ),
                child: Center(
                  child: Text(
                    "SCAM",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Change text color for contrast
                    ),
                  ),
                ),
              ),
              // ListTile with Icons and padding for better spacing
              _buildListTile(
                context,
                title: "Leads",
                routeName: '/lead_list',
              ),
              _buildListTile(
                context,
                title: "Opportunities",
                routeName: '/opportunity_list',
              ),
              _buildListTile(
                context,
                title: "Activities",
                routeName: '/activity_list',
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ), backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 14), // Change to a sleek color
              ),
              child: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to reduce code repetition
  Widget _buildListTile(BuildContext context, {required String title, required String routeName}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != routeName) {
          Navigator.pushNamed(context, routeName);
        } else {
          Navigator.pop(context); // Close the drawer
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0), // Add some horizontal padding
    );
  }
}
