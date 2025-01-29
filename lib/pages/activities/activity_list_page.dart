import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:sham_app/components/activity_list.dart';
import 'package:sham_app/components/sham_drawer.dart';

class ActivityListPage extends StatelessWidget {
  const ActivityListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
          openButtonBuilder: DefaultFloatingActionButtonBuilder(
            foregroundColor: const Color(0xFFF3F1ED),
            backgroundColor: const Color(0xFF3CCECC),
            child: const Icon(Icons.add),
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
              foregroundColor: const Color(0xFFF3F1ED),
              backgroundColor: const Color(0xFF3CCECC),
              child: const Icon(Icons.close),
              fabSize: ExpandableFabSize.small),
          overlayStyle: const ExpandableFabOverlayStyle(blur: 10),
          distance: 150,
          children: [
            FloatingActionButton.small(
              foregroundColor: const Color(0xFFF3F1ED),
              backgroundColor: const Color(0xFF3CCECC),
              tooltip: "Remark",
              onPressed: () {},
              child: const Icon(Icons.business_center),
            ),
            FloatingActionButton.small(
              foregroundColor: const Color(0xFFF3F1ED),
              backgroundColor: const Color(0xFF3CCECC),
              tooltip: "Email",
              onPressed: () {},
              child: const Icon(Icons.email),
            ),
            FloatingActionButton.small(
              foregroundColor: const Color(0xFFF3F1ED),
              backgroundColor: const Color(0xFF3CCECC),
              tooltip: "Phone Call",
              onPressed: () {},
              child: const Icon(Icons.phone),
            ),
            FloatingActionButton.small(
              foregroundColor: const Color(0xFFF3F1ED),
              backgroundColor: const Color(0xFF3CCECC),
              tooltip: "Task",
              onPressed: () {},
              child: const Icon(Icons.task_outlined),
            ),
          ]),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3CCECC),
        title: const Text(
          "Activities",
          style: TextStyle(color: Color(0xFFF3F1ED)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF3F1ED)),
      ),
      drawer: const ShamDrawer(),
      backgroundColor: const Color(0xFFF3F1ED),
      body: const ActivityList(),
    );
  }
}
