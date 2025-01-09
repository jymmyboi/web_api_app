import 'package:flutter/material.dart';
import 'package:sham_app/components/sham_drawer.dart';
import 'package:sham_app/services/database_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final DatabaseService databaseService = DatabaseService();
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
      body: Column(
        children: [Text(databaseService.getMyLeads().toString())],
      ),
    );
  }
}
