import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sham_app/components/future_widget.dart';
import 'package:sham_app/models/activity.dart';
import 'package:sham_app/models/activity_list_entry.dart';
import 'package:sham_app/services/activity_service.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage(
      {super.key,
      required this.activityListEntry,
      required this.activityService});

  final ActivityListEntry activityListEntry;
  final ActivityService activityService;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  Logger logger = Logger();
  late Future<Activity> _activity;

  @override
  void initState() {
    super.initState();
    _activity = _fetchActivity();
    logger.d('fetched');
  }

  Future<void> _refreshData() async {
    setState(() {
      _activity = _fetchActivity();
    });
  }

  Future<Activity> _fetchActivity() async {
    final response = await widget.activityService.getActivity(
        widget.activityListEntry.id, widget.activityListEntry.activityType);
    if (response == null || response.isEmpty) {
      logger.e("Failed to fetch activity");
      throw Exception("Failed to fetch activity");
    }
    final Map<String, dynamic> jsonData = json.decode(response);
    logger.e(Activity.fromJson(jsonData));
    return Activity.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3CCECC),
        foregroundColor: Colors.white,
        title: const Text("Activity"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => LeadEditPage(
              //         leadFuture: _lead,
              //         leadService: widget.leadService,
              //       ),
              //     )).then((_) => _refreshData());
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureWidget<Activity>(
            future: _activity,
            dataBuilder: (context, activity) => Column(
              children: [
                const Text("Number:"),
                ListTile(
                  title: Text(activity.activityNumber),
                ),
                const Text("Description: "),
                ListTile(title: Text(activity.description)),
              ],
            ),
            loadingBuilder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorBuilder: (context) => const Center(
              child: Text("Error fetching activity data"),
            ),
          ),
        ],
      ),
    );
  }
}
