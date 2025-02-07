import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sham_app/components/future_widget.dart';
import 'package:sham_app/models/opportunity_list_entry.dart';
import 'package:sham_app/pages/opportunities/opportunity_page.dart';
import 'package:sham_app/services/opportunity_service.dart';

class OpportunityList extends StatefulWidget {
  const OpportunityList({super.key});

  @override
  State<OpportunityList> createState() => _OpportunityListState();
}

class _OpportunityListState extends State<OpportunityList> {
  late Future<List<OpportunityListEntry>> _opportunitiesFuture;
  final OpportunityService opportunityService = OpportunityService();

  @override
  void initState() {
    super.initState();
    _opportunitiesFuture = _fetchOpportunities();
  }

  Future<void> _refreshData() async {
    setState(() {
      _opportunitiesFuture = _fetchOpportunities();
    });
  }

  Future<List<OpportunityListEntry>> _fetchOpportunities() async {
    final response = await opportunityService.getMyOpportunities();

    if (response == null) {
      throw Exception("Failed to fetch opportunities");
    }

    final List<dynamic> jsonData = json.decode(response);
    return jsonData.map((item) => OpportunityListEntry.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureWidget<List<OpportunityListEntry>>(
      future: _opportunitiesFuture,
      dataBuilder: (context, opportunites) {
        if (opportunites.isEmpty) {
          return const Center(
            child: Text("No opportunites found"),
          );
        }
        return RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.builder(
            itemCount: opportunites.length,
            itemBuilder: (context, index) {
              final opportunity = opportunites[index];
              return ListTile(
                title: Text(opportunity.description),
                subtitle: Text(
                    'Code: ${opportunity.code}\nName: ${opportunity.name}'),
                trailing: Text(opportunity.createdOn),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OpportunityPage(
                        opportunityListEntry: opportunity,
                        opportunityService: opportunityService,
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
