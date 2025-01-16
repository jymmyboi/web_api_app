import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:sham_app/models/lead.dart';
import 'package:sham_app/services/database_service.dart';

class LeadList extends StatefulWidget {
  const LeadList({super.key});

  @override
  State<LeadList> createState() => _LeadListState();
}

class _LeadListState extends State<LeadList> {
  late Future<List<Lead>> _leadsFuture;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _leadsFuture = _fetchLeads();
  }

  Future<List<Lead>> _fetchLeads() async {
    final response = await _databaseService.getMyLeads();

    if (response == null) {
      throw Exception("Failed to fetch leads");
    }

    final List<dynamic> jsonData = json.decode(response);
    return jsonData.map((item) => Lead.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lead>>(
      future: _leadsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No leads found.'));
        } else {
          final leads = snapshot.data!;
          return ListView.builder(
            itemCount: leads.length,
            itemBuilder: (context, index) {
              final lead = leads[index];
              return ListTile(
                title: Text(lead.description),
                subtitle: Text('Code: ${lead.code}\nName: ${lead.name}'),
                trailing: Text(lead.createdOn),
              );
            },
          );
        }
      },
    );
  }
}
