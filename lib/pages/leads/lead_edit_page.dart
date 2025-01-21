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
      ),
      loadingBuilder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Loading..."),
        ),
      ),
    );
  }
}
