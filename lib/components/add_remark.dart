import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sham_app/models/status_list_entry.dart';
import 'package:sham_app/services/activity_service.dart';

class AddRemark extends StatefulWidget {
  const AddRemark({super.key, required this.activityService});
  final ActivityService activityService;

  @override
  State<AddRemark> createState() => _AddRemarkState();
}

class _AddRemarkState extends State<AddRemark> {
  late Future<List<StatusListEntry>> _statusFuture;

  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _statusFuture = _fetchStatuses();
  }

  Future<List<StatusListEntry>> _fetchStatuses() async {
    final response = await widget.activityService.getStatuses();
    if (response == null) {
      throw Exception("Failed to fetch statuses");
    }

    final List<dynamic> jsonData = json.decode(response);
    return jsonData.map((item) => StatusListEntry.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("Subject"),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
              decoration: InputDecoration(border: OutlineInputBorder())),
        ),
        Text("Category"),
        Text("Priority"),
        Text("Customer"),
        Text("Status"),
      ],
    );
  }
}
