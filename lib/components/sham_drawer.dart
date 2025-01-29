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
              const Center(
                child: DrawerHeader(
                  child: Text("SCAM"),
                ),
              ),
              ListTile(
                title: const Text("Leads"),
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name != '/lead_list') {
                    Navigator.pushNamed(context, '/lead_list');
                  } else {
                    Navigator.pop(context); // Close the drawer
                  }
                },
              ),
              ListTile(
                title: const Text("Opportunities"),
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name !=
                      '/opportunity_list') {
                    Navigator.pushNamed(context, '/opportunity_list');
                  } else {
                    Navigator.pop(context); // Close the drawer
                  }
                },
              ),
              const ListTile(
                title: Text("Campaigns"),
              ),
            ],
          ),
          OutlinedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text("Logout"))
        ],
      ),
    );
  }
}
