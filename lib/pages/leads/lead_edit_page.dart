import 'package:flutter/material.dart';
import 'package:sham_app/components/future_widget.dart';
import 'package:sham_app/models/lead.dart';
import 'package:sham_app/services/lead_service.dart';

class LeadEditPage extends StatefulWidget {
  const LeadEditPage(
      {super.key, required this.leadFuture, required this.leadService});
  final LeadService leadService;

  final Future<Lead> leadFuture;

  @override
  State<LeadEditPage> createState() => _LeadEditPageState();
}

class _LeadEditPageState extends State<LeadEditPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _nameController;
  late TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers when the widget is first created.
    widget.leadFuture.then((lead) {
      _descriptionController = TextEditingController(text: lead.description);
      _nameController = TextEditingController(text: lead.name);
      _detailsController = TextEditingController(text: lead.details);
      setState(
          () {}); // Rebuild the widget to reflect the initialized controllers.
    });
  }

  @override
  void dispose() {
    // Dispose of the controllers to free up resources.
    _descriptionController.dispose();
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureWidget(
      future: widget.leadFuture,
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
                    controller: _descriptionController,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                const Text("Name"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                const Text("Details"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _detailsController,
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
                    onPressed: () async {
                      // Use the controller values when saving the data.
                      if (await widget.leadService.editLead(
                            lead.id,
                            lead.code,
                            _descriptionController.text,
                            lead.currencyId,
                            lead.salesSourceId,
                            lead.salesCategoryId,
                            lead.salesProcessId,
                            lead.leadStageId,
                            _nameController.text,
                            _detailsController.text,
                          ) !=
                          null) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
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
