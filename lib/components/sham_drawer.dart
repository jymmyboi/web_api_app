import 'package:flutter/material.dart';

class ShamDrawer extends StatelessWidget {
  const ShamDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Column(
        children: [
          Center(
            child: DrawerHeader(
              child: Text("SCAM"),
            ),
          ),
          ListTile(
            title: Text("Opportunities"),
          ),
          ListTile(
            title: Text("Campaigns"),
          ),
        ],
      ),
    );
  }
}
