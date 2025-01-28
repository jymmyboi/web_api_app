import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:logger/logger.dart';
import 'package:sham_app/components/future_widget.dart';
import 'package:sham_app/models/lead.dart';
import 'package:sham_app/pages/leads/lead_edit_page.dart';
import 'package:sham_app/services/database_service.dart';

import '../../models/lead_list_entry.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _refreshData() async {
    setState(() {
      _lead = _fetchLead();
    });
  }

  Future<Lead> _fetchLead() async {
    final response = await _databaseService.getLead(widget._leadListEntry.id);
    if (response == null || response.isEmpty) {
      throw Exception("Failed to fetch lead");
    }
    final Map<String, dynamic> jsonData = json.decode(response);
    return Lead.fromJson(jsonData);
  }

  String _createGoogleMapsSearch(
      String streetName, String cityName, String stateName) {
    String baseUrl = 'https://www.google.com/maps/search/?api=1&query=';
    String fullString = "$streetName%2C$cityName%2C$stateName";
    fullString = fullString.replaceAll(' ', '+');
    return "$baseUrl$fullString";
  }

  _launchUrl(String streetName, String cityName, String stateName) async {
    final Uri url =
        Uri.parse(_createGoogleMapsSearch(streetName, cityName, stateName));
    if (!await launchUrl(url)) {
      throw Exception("Could not launch URL");
    }
  }

  Future<void> _showDeleteDialog(Future<Lead> futureLead) async {
    final lead = await futureLead;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("WARNING!"),
          content:
              const Text("This will delete the lead, there is no undo button."),
          actions: [
            TextButton(
                onPressed: () async {
                  if (await _databaseService.deleteLead(lead.id) != null) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    const SnackBar(
                      content:
                          Text('There has been an error deleting the lead'),
                    );
                  }
                },
                child: const Text("Delete"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(children: [
        FloatingActionButton.small(
          tooltip: "Convert",
          onPressed: () {},
          child: const Icon(Icons.handshake),
        ),
        FloatingActionButton.small(
          tooltip: "Close",
          onPressed: () {},
          child: const Icon(Icons.archive),
        ),
      ]),
      appBar: AppBar(
        title: const Text("Lead"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeadEditPage(
                      leadFuture: _lead,
                    ),
                  )).then((_) => _refreshData());
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureWidget<Lead>(
            future: _lead,
            dataBuilder: (context, lead) => Column(
              children: [
                const Text("Code:"),
                ListTile(
                  title: Text(lead.code),
                ),
                const Text("Name: "),
                ListTile(title: Text(lead.name)),
                const Text("Address"),
                ListTile(
                  title: Text(lead.physicalStreet),
                  subtitle:
                      Text("${lead.physicalSuburb}, ${lead.physicalPostCode}"),
                  onTap: () {
                    _launchUrl(lead.physicalStreet, lead.physicalSuburb,
                        lead.physicalState);
                  },
                ),
              ],
            ),
            loadingBuilder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorBuilder: (context) => const Center(
              child: Text("Error fetching lead data"),
            ),
          ),
        ],
      ),
    );
  }
}
