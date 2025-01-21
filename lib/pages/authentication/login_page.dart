import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sham_app/pages/authentication/connect_server_page.dart';
import 'package:sham_app/pages/leads/lead_list_page.dart';
import 'package:sham_app/services/database_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Logger logger = Logger();

  final databaseService = DatabaseService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<String> serverDetails = [];
  String? selectedServer;

  void updateDropdown(List<String> newEntries) {
    setState(() {
      serverDetails = newEntries;
      logger.i(serverDetails);
      if (serverDetails.isNotEmpty && selectedServer == null) {
        selectedServer = serverDetails.first; // Set default selection
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sybiz CRM Action Manager"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: usernameController,
                key: const Key('username'),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordController,
                key: const Key('password'),
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                hint: const Text("No server connected"),
                isExpanded: true,
                value: selectedServer,
                items: serverDetails.map((String server) {
                  return DropdownMenuItem(value: server, child: Text(server));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedServer = newValue;
                  });
                },
              ),
            ),
            OutlinedButton(
                onPressed: () async {
                  final String username = usernameController.text.trim();
                  final String password = passwordController.text.trim();

                  logger.i("Username: $username, Password: $password");

                  if (selectedServer == null ||
                      username.isEmpty ||
                      password.isEmpty) {
                    logger.e("Missing inputs");
                    return;
                  }
                  logger.i((selectedServer, username, password));
                  final String? bearer = await databaseService.getBearerToken(
                      selectedServer!, username, password);
                  if (bearer != null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LeadListPage()));
                  } else {
                    logger.e("Failed to authenticate");
                  }
                },
                child: const Text("Submit")),
            OutlinedButton(
                onPressed: () async {
                  final List<String>? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConnectServerPage()),
                  );
                  setState(() {
                    serverDetails = [];
                    selectedServer = null;
                  });
                  if (result != null) {
                    updateDropdown(result);
                  }
                },
                child: const Text("Connect Server"))
          ],
        ),
      ),
    );
  }
}
