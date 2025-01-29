import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> saveBaseUrlAndAccessKey(
      String newBaseUrl, String? newAccessKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', newBaseUrl);
    if (newAccessKey != null) {
      await prefs.setString('accessKey', newAccessKey);
    }
    logger.i("Saved | $newBaseUrl + $newAccessKey");
  }

  Future<void> loadBaseUrlAndAccessKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    baseUrl = prefs.getString('baseUrl');
    accessKey = prefs.getString('accessKey');
  }

  void setBaseUrl(String newBaseUrl, [String? newAccessKey]) async {
    baseUrl = "https://$newBaseUrl/API";
    if (newAccessKey != null) {
      accessKey = newAccessKey;
    }
    await saveBaseUrlAndAccessKey(newBaseUrl, newAccessKey);
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

  Future<String?> convertLead(int leadId) async {
    http.Request request =
        http.Request('POST', Uri.parse('$baseUrl/CRM/Lead/$leadId/Convert'));
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to convert lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> closeLead(int leadId) async {
    http.Request request =
        http.Request('POST', Uri.parse('$baseUrl/CRM/Lead/$leadId/Close'));
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to close lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> editLead(
      int leadId,
      String leadCode,
      String leadDescription,
      int leadCurrencyId,
      int? leadSalesSourceId,
      int? leadSalesCategoryId,
      int? leadSalesProcessId,
      int? leadStageId,
      String leadName,
      String leadDetails) async {
    http.Request request = http.Request('POST', Uri.parse('$baseUrl/CRM/Lead'));
    request.headers.addAll({
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    });
    request.body =
        '''{\r\n    "Id": $leadId,\r\n    "Code": "$leadCode",\r\n    "Description": "$leadDescription",\r\n    "CurrencyId": $leadCurrencyId,\r\n    "SalesSourceId": $leadSalesSourceId,\r\n    "SalesCategoryId": $leadSalesCategoryId,\r\n    "SalesProcessId": $leadSalesProcessId,\r\n    "LeadStageId": $leadStageId,\r\n    "Name": "$leadName",\r\n    "Details": "$leadDetails"\r\n}''';
    logger.d(request.body);
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

  Future<String?> getMyOpportunities() async {
    http.Request request =
        http.Request('GET', Uri.parse('${baseUrl!}/CRM/MyOpportunityInfoList'));
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to get opportunities ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> getOpportunity(int opportunityId) async {
    http.Request request = http.Request(
        'GET', Uri.parse('$baseUrl/CRM/Opportunity/$opportunityId'));
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to get opportunity ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> lostOpportunity(int opportunityId) async {
    http.Request request = http.Request(
        'POST', Uri.parse('$baseUrl/CRM/Opportunity/$opportunityId/Lost'));
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to lose lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> wonOpportunity(int opportunityId) async {
    http.Request request = http.Request(
        'POST', Uri.parse('$baseUrl/CRM/Opportunity/$opportunityId/Won'));
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to win lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> convertOpportunity(int opportunityId) async {
    http.Request request = http.Request(
        'POST',
        Uri.parse(
            '$baseUrl/CRM/Opportunity/$opportunityId/ConvertToActiveLead'));
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to convert lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> editOpportunity(
      int opportunityId,
      String opportunityCode,
      String opportunityDescription,
      int opportunityCurrencyId,
      int? opportunitySalesSourceId,
      int? opportunitySalesCategoryId,
      int? opportunitySalesProcessId,
      int? opportunityLeadStageId,
      String opportunityName,
      String opportunityDetails) async {
    http.Request request =
        http.Request('POST', Uri.parse('$baseUrl/CRM/Opportunity'));
    request.headers.addAll({
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    });
    request.body =
        '''{\r\n    "Id": $opportunityId,\r\n    "Code": "$opportunityCode",\r\n    "Description": "$opportunityDescription",\r\n    "CurrencyId": $opportunityCurrencyId,\r\n    "SalesSourceId": $opportunitySalesSourceId,\r\n    "SalesCategoryId": $opportunitySalesCategoryId,\r\n    "SalesProcessId": $opportunitySalesProcessId,\r\n    "LeadStageId": $opportunityLeadStageId,\r\n    "Name": "$opportunityName",\r\n    "Details": "$opportunityDetails"\r\n}''';
    logger.d(request.body);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to edit Opportunity ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }
}
