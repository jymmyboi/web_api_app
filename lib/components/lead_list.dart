import 'package:flutter/material.dart';
import 'package:sham_app/components/future_widget.dart';
import 'dart:convert';

import 'package:sham_app/models/lead_list_entry.dart';
import 'package:sham_app/pages/leads/lead_page.dart';
import 'package:sham_app/services/lead_service.dart';

class LeadList extends StatefulWidget {
  const LeadList({super.key});

  @override
  State<LeadList> createState() => _LeadListState();
}

class _LeadListState extends State<LeadList> {
  late Future<List<LeadListEntry>> _leadsFuture;
  final LeadService leadService = LeadService();

  @override
  void initState() {
    super.initState();
    _leadsFuture = _fetchLeads();
  }

  Future<void> _refreshData() async {
    setState(() {
      _leadsFuture = _fetchLeads();
    });
  }

  Future<List<LeadListEntry>> _fetchLeads() async {
    final response = await leadService.getMyLeads();

    if (response == null) {
      throw Exception("Failed to fetch leads");
    }

    final List<dynamic> jsonData = json.decode(response);
    return jsonData.map((item) => LeadListEntry.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureWidget<List<LeadListEntry>>(
      future: _leadsFuture,
      dataBuilder: (context, leads) {
        if (leads.isEmpty) {
          return const Center(child: Text('No leads found.'));
        }
        return RefreshIndicator(
          onRefresh: _refreshData,
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
                      builder: (context) => LeadPage(
                        leadListEntry: lead,
                        leadService: leadService,
                      ),
                    ),
                  ).then((_) => _refreshData());
                },
              );
            },
          ),
        );
      },
    );
  }
}
