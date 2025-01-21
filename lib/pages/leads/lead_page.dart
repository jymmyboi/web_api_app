import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sham_app/models/lead.dart';
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

  Future<Lead> _fetchLead() async {
    final response = await _databaseService.getLead(widget._leadListEntry.id);
    if (response == null || response.isEmpty) {
      throw Exception("Failed to fetch lead");
    }
    final Map<String, dynamic> jsonData = json.decode(response);
    return Lead.fromJson(jsonData);
  }

  String createGoogleMapsSearch(
      String streetName, String cityName, String stateName) {
    String baseUrl = 'https://www.google.com/maps/search/?api=1&query=';
    String fullString = "$streetName%2C$cityName%2C$stateName";
    fullString = fullString.replaceAll(' ', '+');
    return "$baseUrl$fullString";
  }

  _launchUrl(String streetName, String cityName, String stateName) async {
    final Uri url =
        Uri.parse(createGoogleMapsSearch(streetName, cityName, stateName));
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
                  ;
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
      appBar: AppBar(
        title: Text(widget._leadListEntry.description),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leadFutureBuilder(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _showDeleteDialog(_lead);
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  FutureBuilder<Lead> leadFutureBuilder() {
    return FutureBuilder(
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
            return Column(
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
                )
              ],
            );
          }
        });
  }
}
