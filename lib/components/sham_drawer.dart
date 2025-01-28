import 'package:flutter/material.dart';
import 'package:sham_app/pages/leads/lead_list_page.dart';
import 'package:sham_app/pages/opportunities/opportunity_list_page.dart';

class ShamDrawer extends StatelessWidget {
  const ShamDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const Center(
            child: DrawerHeader(
              child: Text("SCAM"),
            ),
          ),
          ListTile(
            title: const Text("Leads"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LeadListPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Opportunities"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OpportunityListPage()),
              );
            },
          ),
          const ListTile(
            title: Text("Campaigns"),
          ),
        ],
      ),
    );
  }
}
