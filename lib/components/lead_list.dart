import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:sham_app/models/lead_list_entry.dart';
import 'package:sham_app/pages/lead_page.dart';
import 'package:sham_app/services/database_service.dart';

class LeadList extends StatefulWidget {
  const LeadList({super.key});

  @override
  State<LeadList> createState() => _LeadListState();
}

class _LeadListState extends State<LeadList> {
  late Future<List<LeadListEntry>> _leadsFuture;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _leadsFuture = _fetchLeads();
  }

  Future<void> _pullRefresh() async {
    Future<List<LeadListEntry>> freshLeads = _fetchLeads();
    setState(
      () {
        _leadsFuture = freshLeads;
      },
    );
  }

  Future<List<LeadListEntry>> _fetchLeads() async {
    final response = await _databaseService.getMyLeads();

    if (response == null) {
      throw Exception("Failed to fetch leads");
    }

    final List<dynamic> jsonData = json.decode(response);
    return jsonData.map((item) => LeadListEntry.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LeadListEntry>>(
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
          return RefreshIndicator(
            onRefresh: _pullRefresh,
            child: ListView.builder(
              itemCount: leads.length,
              itemBuilder: (context, index) {
                final lead = leads[index];
                return ListTile(
                  title: Text(lead.description),
                  subtitle: Text('Code: ${lead.code}\nName: ${lead.name}'),
                  trailing: Text(lead.createdOn),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LeadPage(leadListEntry: leads[index])));
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
