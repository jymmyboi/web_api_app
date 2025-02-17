import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sham_app/pages/authentication/connect_server_page.dart';
import 'package:sham_app/pages/leads/lead_list_page.dart';
import 'package:sham_app/services/authentication_service.dart';
import 'package:sham_app/services/base_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Logger logger = Logger();

  final authenticationService = AuthenticationService();
  final baseService = BaseService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<String> serverDetails = [];
  String? selectedServer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedServerDetails();
  }

  Future<void> _loadSavedServerDetails() async {
    await baseService.loadBaseUrlAndAccessKey();
    if (baseService.baseUrl != null && baseService.accessKey != null) {
      // logger.i("loaded base url: ${baseService.baseUrl}");

      List<String>? databases = await authenticationService.getDatabases(
          baseService.baseUrl!, baseService.accessKey!);

      if (databases != null && databases.isNotEmpty) {
        setState(() {
          serverDetails = databases;
          selectedServer = databases.first;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void updateDropdown(List<String> newEntries) {
    setState(() {
      serverDetails = newEntries;
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Username Input
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: usernameController,
                      key: const Key('username'),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFF3CCECC)),
                            borderRadius: BorderRadius.circular(20)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Username',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  // Password Input
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: passwordController,
                      key: const Key('password'),
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF3CCECC)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Password',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  // Server Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFF3CCECC)),
                            borderRadius: BorderRadius.circular(20)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      hint: const Text("No server connected"),
                      isExpanded: true,
                      value: selectedServer,
                      items: serverDetails.map((String server) {
                        return DropdownMenuItem(
                            value: server, child: Text(server));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedServer = newValue;
                        });
                      },
                    ),
                  ),
                  // Submit Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final String username = usernameController.text.trim();
                        final String password = passwordController.text.trim();

                        if (selectedServer == null ||
                            username.isEmpty ||
                            password.isEmpty) {
                          logger.e("Missing inputs");
                          return;
                        }
                        final String? bearer =
                            await authenticationService.getBearerToken(
                                selectedServer!, username, password);
                        if (bearer != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LeadListPage()),
                          );
                        } else {
                          logger.e("Failed to authenticate");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF3CCECC),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Submit"),
                    ),
                  ),
                  // Connect Server Button
                  ElevatedButton(
                    onPressed: () async {
                      final List<String>? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConnectServerPage(
                                  authenticationService: authenticationService,
                                )),
                      );
                      setState(() {
                        serverDetails = [];
                        selectedServer = null;
                      });
                      if (result != null) {
                        updateDropdown(result);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Connect Server"),
                  ),
                ],
              ),
            ),
    );
  }
}
