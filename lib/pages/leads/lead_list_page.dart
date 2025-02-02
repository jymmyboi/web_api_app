import 'package:flutter/material.dart';
import 'package:sham_app/components/lead_list.dart';
import 'package:sham_app/components/sham_drawer.dart';

class LeadListPage extends StatelessWidget {
  const LeadListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3CCECC),
        title: const Text(
          "Leads",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const ShamDrawer(),
      backgroundColor: Colors.white,
      body: const LeadList(),
    );
  }
}
