import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:sham_app/components/activity_list.dart';
import 'package:sham_app/components/sham_drawer.dart';
import 'package:sham_app/pages/activities/new_activity_page.dart';

class ActivityListPage extends StatelessWidget {
  const ActivityListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
          openButtonBuilder: DefaultFloatingActionButtonBuilder(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF3CCECC),
            child: const Icon(Icons.add),
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF3CCECC),
              child: const Icon(Icons.close),
              fabSize: ExpandableFabSize.small),
          overlayStyle: const ExpandableFabOverlayStyle(blur: 10),
          distance: 150,
          children: [
            FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF3CCECC),
              tooltip: "Remark",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewActivityPage(
                      activityType: 1,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.business_center),
            ),
            FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF3CCECC),
              tooltip: "Email",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewActivityPage(
                      activityType: 2,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.email),
            ),
            FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF3CCECC),
              tooltip: "Phone Call",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewActivityPage(
                      activityType: 3,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.phone),
            ),
            FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF3CCECC),
              tooltip: "Task",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewActivityPage(
                      activityType: 4,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.task_outlined),
            ),
          ]),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3CCECC),
        title: const Text(
          "Activities",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const ShamDrawer(),
      backgroundColor: Colors.white,
      body: const ActivityList(),
    );
  }
}
