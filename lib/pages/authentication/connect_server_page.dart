import 'package:flutter/material.dart';
import 'package:sham_app/services/database_service.dart';
import 'package:logger/logger.dart';

class ConnectServerPage extends StatelessWidget {
  ConnectServerPage({super.key});
  final TextEditingController serverController = TextEditingController();
  final TextEditingController accessKeyController = TextEditingController();
  final DatabaseService databaseService = DatabaseService();
  final Logger logger = Logger();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: serverController,
                key: const Key('server'),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Server'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: accessKeyController,
                key: const Key('access_key'),
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Access Key (optional)'),
              ),
            ),
            OutlinedButton(
                onPressed: () async {
                  final server = serverController.text;
                  final accessKey = accessKeyController.text.isEmpty
                      ? ''
                      : accessKeyController.text;
                  try {
                    var response =
                        await databaseService.getDatabases(server, accessKey);
                    Navigator.of(context).pop(response);
                  } catch (e) {
                    logger.e(e);
                  }
                },
                child: const Text("Connect")),
          ],
        ),
      ),
    );
  }
}
