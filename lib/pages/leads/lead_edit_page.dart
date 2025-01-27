import 'package:flutter/material.dart';
import 'package:sham_app/components/future_widget.dart';
import 'package:sham_app/models/lead.dart';

class LeadEditPage extends StatelessWidget {
  const LeadEditPage({super.key, required this.leadFuture});

  final Future<Lead> leadFuture;

  @override
  Widget build(BuildContext context) {
    return FutureWidget(
      future: leadFuture,
      dataBuilder: (context, lead) => Scaffold(
        appBar: AppBar(
          title: Text(lead.name),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text("Description"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: TextEditingController(text: lead.description),
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                const Text("Name"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: TextEditingController(text: lead.name),
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                const Text("Details"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: TextEditingController(text: lead.details),
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: FloatingActionButton(
                    child: const Icon(Icons.save),
                    onPressed: () {},
                  ),
                ),
              ],
            )
          ],
        ), //TODO: Add edit functionality
      ),
      loadingBuilder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Loading..."),
        ),
      ),
      errorBuilder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Error loading lead"),
        ),
      ),
    );
  }
}
