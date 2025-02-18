import 'package:flutter/material.dart';

class NewActivityPage extends StatelessWidget {
  final int activityType;
  const NewActivityPage({super.key, required this.activityType});

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
      appBar: AppBar(title: Text("New $title")),
    );
  }
}
