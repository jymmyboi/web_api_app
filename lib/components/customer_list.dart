import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sham_app/models/customer_list_entry.dart';
import 'package:sham_app/services/activity_service.dart';

class CustomerList extends StatelessWidget {
  final ActivityService activityService;
  CustomerList({super.key, required this.activityService});
  final dropDownKey = GlobalKey<DropdownSearchState>();

  Future<List<CustomerListEntry>> _fetchCustomers() async {
    final response = await activityService.getCustomers();

    if (response == null) {
      throw Exception("Failed to get customers");
    }

    final List<dynamic> jsonData = json.decode(response);
    return jsonData.map((item) => CustomerListEntry.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      key: dropDownKey,
    );
  }
}
