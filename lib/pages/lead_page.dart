import 'package:flutter/material.dart';

import '../models/lead_list_entry.dart';

class LeadPage extends StatelessWidget {
  const LeadPage({
    super.key,
    required LeadListEntry leadListEntry,
  }) : _leadListEntry = leadListEntry;

  final LeadListEntry _leadListEntry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_leadListEntry.name),
      ),
    );
  }
}
