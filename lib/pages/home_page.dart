import 'package:flutter/material.dart';
import 'package:sham_app/components/lead_list.dart';
import 'package:sham_app/components/sham_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3CCECC),
        title: const Text(
          "Sybiz CRM Action Manager",
          style: TextStyle(color: Color(0xFFF3F1ED)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF3F1ED)),
      ),
      drawer: const ShamDrawer(),
      backgroundColor: const Color(0xFFF3F1ED),
      body: const LeadList(),
    );
  }
}
