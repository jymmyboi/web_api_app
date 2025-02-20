import 'package:flutter/material.dart';
import 'package:sham_app/components/add_remark.dart';
import 'package:sham_app/services/activity_service.dart';

class NewActivityPage extends StatelessWidget {
  final int activityType;
  final ActivityService activityService;
  const NewActivityPage(
      {super.key, required this.activityType, required this.activityService});

  static const Map<int, List<String>> activityTitles = {
    1: ['Remark'],
    2: ['Email'],
    3: ['Phone Call'],
    4: ['Task']
  };

  @override
  Widget build(BuildContext context) {
    String title = activityTitles[activityType]?.elementAt(0) ?? "Activity";
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save),
      ),
      appBar: AppBar(title: Text("New $title")),
      body: switch (activityType) {
        1 => AddRemark(
            activityService: activityService,
          ),
        // TODO: Handle this case.
        int() => throw UnimplementedError(),
      },
    );
  }
}
