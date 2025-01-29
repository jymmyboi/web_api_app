import 'package:flutter/material.dart';
import 'package:sham_app/pages/activities/activity_list_page.dart';
import 'package:sham_app/pages/authentication/login_page.dart';
import 'package:sham_app/pages/leads/lead_list_page.dart';
import 'package:sham_app/pages/opportunities/opportunity_list_page.dart';
import 'package:sham_app/services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService databaseService = DatabaseService();
  await databaseService.loadBaseUrlAndAccessKey();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/lead_list': (context) => const LeadListPage(),
        '/opportunity_list': (context) => const OpportunityListPage(),
        '/activity_list': (context) => const ActivityListPage(),
      },
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
