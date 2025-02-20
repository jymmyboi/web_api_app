import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sham_app/components/future_widget.dart';
import 'package:sham_app/models/activity_list_entry.dart';
import 'package:sham_app/pages/activities/activity_page.dart';
import 'package:sham_app/services/activity_service.dart';

class ActivityList extends StatefulWidget {
  const ActivityList({super.key, required this.activityService});
  final ActivityService activityService;
  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  late Future<List<ActivityListEntry>> _activitiesFuture;

  final Logger logger = Logger();
  @override
  void initState() {
    super.initState();
    _activitiesFuture = _fetchActivities();
  }

  Future<void> _refreshData() async {
    setState(() {
      _activitiesFuture = _fetchActivities();
    });
  }

  IconData getActivityIcon(int activityType) {
    switch (activityType) {
      case 1: //remark
        return Icons.event_note;
      case 2: //email
        return Icons.email;
      case 3: //phonecall
        return Icons.phone;
      case 4: //task
        return Icons.task_outlined;
      default:
        return Icons.notes;
    }
  }

  Future<List<ActivityListEntry>> _fetchActivities() async {
    final response = await widget.activityService.getMyActivities();

    if (response == null) {
      throw Exception("Failed to fetch activities");
    }

    final List<dynamic> jsonData = json.decode(response);
    return jsonData.map((item) => ActivityListEntry.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureWidget(
        future: _activitiesFuture,
        dataBuilder: (context, activities) {
          if (activities.isEmpty) {
            return const Center(
              child: Text("No activites found"),
            );
          }
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ListTile(
                  onTap: () {
                    logger.d(activity.activityNumber);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityPage(
                          activityListEntry: activity,
                          activityService: widget.activityService,
                        ),
                      ),
                    ).then((_) => _refreshData());
                  },
                  title: Text(activity.activityNumber),
                  subtitle: Text(activity.subject),
                  leading: Icon(
                    getActivityIcon(activity.activityType),
                  ),
                );
              },
            ),
          );
        });
  }
}
