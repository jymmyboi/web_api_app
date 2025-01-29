import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:logger/logger.dart';
import 'package:sham_app/components/future_widget.dart';
import 'package:sham_app/models/opportunity.dart';
import 'package:sham_app/models/opportunity_list_entry.dart';
import 'package:sham_app/pages/opportunities/opportunity_edit_page.dart';
import 'package:sham_app/services/database_service.dart';
import 'package:url_launcher/url_launcher.dart';

class OpportunityPage extends StatefulWidget {
  const OpportunityPage(
      {super.key, required OpportunityListEntry opportunityListEntry})
      : _opportunityListEntry = opportunityListEntry;

  final OpportunityListEntry _opportunityListEntry;

  @override
  State<OpportunityPage> createState() => _OpportunityPageState();
}

class _OpportunityPageState extends State<OpportunityPage> {
  Logger logger = Logger();
  late Future<Opportunity> _opportunity;

  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _opportunity = _fetchOpportunity();
  }

  Future<void> _refreshData() async {
    setState(() {
      _opportunity = _fetchOpportunity();
    });
  }

  Future<Opportunity> _fetchOpportunity() async {
    final response =
        await _databaseService.getOpportunity(widget._opportunityListEntry.id);
    if (response == null || response.isEmpty) {
      throw Exception("Failed to fetch opportunity");
    }
    final Map<String, dynamic> jsonData = json.decode(response);
    return Opportunity.fromJson(jsonData);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: FutureWidget<Opportunity>(
        future: _opportunity,
        dataBuilder: (context, opportunity) => ExpandableFab(
          overlayStyle: const ExpandableFabOverlayStyle(blur: 10),
          openButtonBuilder: DefaultFloatingActionButtonBuilder(
            foregroundColor: const Color(0xFFF3F1ED),
            backgroundColor: const Color(0xFF3CCECC),
            child: const Icon(Icons.menu),
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
              foregroundColor: const Color(0xFFF3F1ED),
              backgroundColor: const Color(0xFF3CCECC),
              child: const Icon(Icons.close),
              fabSize: ExpandableFabSize.small),
          children: [
            FloatingActionButton.small(
              foregroundColor: const Color(0xFFF3F1ED),
              backgroundColor: const Color(0xFF3CCECC),
              tooltip: "Convert back",
              onPressed: () {
                _databaseService.convertOpportunity(opportunity.id);
                logger.i(
                    "Convert action triggered for opportunity ID: ${opportunity.id}");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Converted ${opportunity.description}")));
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.undo),
            ),
            FloatingActionButton.small(
              foregroundColor: const Color(0xFFF3F1ED),
              backgroundColor: const Color(0xFF3CCECC),
              tooltip: "Lost",
              onPressed: () {
                _databaseService.lostOpportunity(opportunity.id);
                logger.i(
                    "Convert action triggered for opportunity ID: ${opportunity.id}");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lost ${opportunity.description}")));
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.thumb_down),
            ),
            FloatingActionButton.small(
              foregroundColor: const Color(0xFFF3F1ED),
              backgroundColor: const Color(0xFF3CCECC),
              tooltip: "Won",
              onPressed: () {
                _databaseService.wonOpportunity(opportunity.id);
                logger.i("Win action triggered");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Won ${opportunity.description}")));
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.thumb_up),
            ),
          ],
        ),
        loadingBuilder: (context) => const CircularProgressIndicator(),
        errorBuilder: (context) => const FloatingActionButton.small(
          tooltip: "Error",
          onPressed: null, // Disable button when there's an error
          child: Icon(Icons.error, color: Colors.red),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3CCECC),
        foregroundColor: const Color(0xFFF3F1ED),
        title: const Text("Opportunity"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OpportunityEditPage(
                              opportunityFuture: _opportunity)))
                  .then((_) => _refreshData());
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureWidget<Opportunity>(
            future: _opportunity,
            dataBuilder: (context, opportunity) => Column(
              children: [
                const Text("Code:"),
                ListTile(
                  title: Text(opportunity.code),
                ),
                const Text("Name: "),
                ListTile(title: Text(opportunity.name)),
                const Text("Address"),
                ListTile(
                  title: Text(opportunity.physicalStreet),
                  subtitle: Text(
                      "${opportunity.physicalSuburb}, ${opportunity.physicalPostCode}"),
                  onTap: () {
                    _launchUrl(opportunity.physicalStreet,
                        opportunity.physicalSuburb, opportunity.physicalState);
                  },
                ),
              ],
            ),
            loadingBuilder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorBuilder: (context) => const Center(
              child: Text("Error fetching opportunity data"),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF3F1ED),
    );
  }
}
