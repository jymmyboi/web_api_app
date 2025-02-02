import 'package:flutter/material.dart';
import 'package:sham_app/components/opportunity_list.dart';
import 'package:sham_app/components/sham_drawer.dart';

class OpportunityListPage extends StatelessWidget {
  const OpportunityListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3CCECC),
        title: const Text(
          "Opportunities",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const ShamDrawer(),
      backgroundColor: Colors.white,
      body: const OpportunityList(),
    );
  }
}
