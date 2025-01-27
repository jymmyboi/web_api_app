import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

//TODO: Add checks for permissions.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }
  DatabaseService._internal();
  Logger logger = Logger();

  String? baseUrl;
  String? accessKey;

  String? accessToken;
  String? tokenType;
  int? tokenExpiry;
  String? refreshToken;

  void setBaseUrl(String newBaseUrl, [String? newAccessKey]) {
    baseUrl = "https://$newBaseUrl/API";
    if (newAccessKey != null) {
      accessKey = newAccessKey;
    }
  }

  void setBearerToken(String bearerJson) {
    final bearerToken = jsonDecode(bearerJson) as Map<String, dynamic>;
    accessToken = bearerToken['access_token'];
  }

  Future<List<String>?> getDatabases(
      String newBaseUrl, String newAccessKey) async {
    http.Request request = http.Request(
        'GET',
        Uri.parse(
            'https://$newBaseUrl/API/DB/Database?Keys=$newAccessKey&IsJson=true'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      List<dynamic> decodedJson = jsonDecode(responseBody);

      // Extract database names into a List<String>
      List<String> databases =
          decodedJson.map((item) => item['Database'] as String).toList();
      setBaseUrl(newBaseUrl, newAccessKey);
      logger.i((baseUrl, accessKey));
      return databases;
    } else {
      Map<String, String> responseReason = {
        "Reason": response.reasonPhrase ?? 'No reason'
      };
      logger.e(responseReason);
      return null;
    }
  }

  Future<String?> getBearerToken(
      String database, String username, String password) async {
    if (baseUrl == null || accessKey == null) {
      logger.e('Base URL or Access Key is null');
      return null; // Handle null case by returning null or error
    }

    try {
      http.Request request =
          http.Request('POST', Uri.parse("${baseUrl!}/Bearer"));
      request.bodyFields = <String, String>{
        'grant_type': 'password',
        'database': database,
        'username': username,
        'password': password,
        'keys': accessKey!,
      };
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        setBearerToken(responseString);
        return responseString;
      } else {
        logger.e(
            'Failed to get bearer token. Status code: ${response.statusCode} | ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      logger.e('Error fetching bearer token: $e ');
      return null;
    }
  }

  Future<String?> getMyLeads() async {
    http.Request request =
        http.Request('GET', Uri.parse('${baseUrl!}/CRM/MyLeadInfoList'));
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to get leads ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> getLead(int leadId) async {
    http.Request request =
        http.Request('GET', Uri.parse('$baseUrl/CRM/Lead/$leadId'));
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to get lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> deleteLead(int leadId) async {
    http.Request request =
        http.Request('DELETE', Uri.parse('$baseUrl/CRM/Lead/$leadId'));
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 204) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to delete lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> editLead(
      int leadId,
      String leadCode,
      String leadDescription,
      int leadCurrencyId,
      int leadSalesSourceId,
      int leadSalesCategoryId,
      int leadSalesProcessId,
      int leadStageId,
      String leadName,
      String leadDetails) async {
    http.Request request = http.Request('POST', Uri.parse('$baseUrl/CRM/Lead'));
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});
    request.body =
        '''{\r\n    "Id": $leadId,\r\n    "Code": $leadCode,\r\n    "Description": $leadDescription,\r\n    "CurrencyId": $leadCurrencyId,\r\n    "SalesSourceId": $leadSalesSourceId,\r\n    "SalesCategoryId": $leadSalesCategoryId,\r\n    "SalesProcessId": $leadSalesProcessId,\r\n    "LeadStageId": $leadStageId,\r\n    "Name": $leadName,\r\n    "Details": $leadDetails\r\n}''';

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to edit lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }
}
