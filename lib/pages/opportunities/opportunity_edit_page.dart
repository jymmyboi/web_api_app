import 'package:flutter/material.dart';
import 'package:sham_app/components/future_widget.dart';
import 'package:sham_app/models/opportunity.dart';
import 'package:sham_app/services/opportunity_service.dart';

class OpportunityEditPage extends StatefulWidget {
  const OpportunityEditPage(
      {super.key,
      required this.opportunityFuture,
      required this.opportunityService});

  final Future<Opportunity> opportunityFuture;
  final OpportunityService opportunityService;

  @override
  State<OpportunityEditPage> createState() => _OpportunityEditPageState();
}

class _OpportunityEditPageState extends State<OpportunityEditPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _nameController;
  late TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers when the widget is first created.
    widget.opportunityFuture.then((opportunity) {
      _descriptionController =
          TextEditingController(text: opportunity.description);
      _nameController = TextEditingController(text: opportunity.name);
      _detailsController = TextEditingController(text: opportunity.details);
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
      future: widget.opportunityFuture,
      dataBuilder: (context, opportunity) => Scaffold(
        appBar: AppBar(
          title: Text(opportunity.name),
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
                      if (await widget.opportunityService.editOpportunity(
                            opportunity.id,
                            opportunity.code,
                            _descriptionController.text,
                            opportunity.currencyId,
                            opportunity.salesSourceId,
                            opportunity.salesCategoryId,
                            opportunity.salesProcessId,
                            opportunity.leadStageId,
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
          title: const Text("Error loading opportunity"),
        ),
      ),
    );
  }
}
