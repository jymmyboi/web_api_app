import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sham_app/models/lead.dart';
import 'package:sham_app/services/database_service.dart';

import '../models/lead_list_entry.dart';

class LeadPage extends StatefulWidget {
  const LeadPage({
    super.key,
    required LeadListEntry leadListEntry,
  }) : _leadListEntry = leadListEntry;

  final LeadListEntry _leadListEntry;

  @override
  State<LeadPage> createState() => _LeadPageState();
}

class _LeadPageState extends State<LeadPage> {
  Logger logger = Logger();
  late Future<Lead> _lead;
  final DatabaseService _databaseService = DatabaseService();
  @override
  void initState() {
    super.initState();
    _lead = _fetchLead();
  }

  Future<Lead> _fetchLead() async {
    final response = await _databaseService.getLead(widget._leadListEntry.id);

    // Handle a null or empty response
    if (response == null || response.isEmpty) {
      logger.e("Empty or null response");
      throw Exception("Failed to fetch lead");
    }

    // Decode the JSON response
    final Map<String, dynamic> jsonData = json.decode(response);

    // Ensure that required fields are not null or missing
    if (jsonData['description'] == null || jsonData['description'] is! String) {
      logger.e("Description is missing or invalid");
      throw Exception("Invalid lead data");
    }

    Lead lead = Lead.fromJson(jsonData);
    logger.i("LEAD RETURNED");
    return lead;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._leadListEntry.name),
      ),
      body: FutureBuilder(
          future: _lead,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading spinner while fetching data
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              logger.e(snapshot.error);
              // Display an error message if something goes wrong
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData) {
              // Handle the case where no data is returned
              return const Center(
                child: Text("No data available"),
              );
            } else {
              final lead = snapshot.data!;
              logger.d(lead.description);
              return Column(
                children: [Text(lead.name)],
              );
            }
          }),
    );
  }
}
