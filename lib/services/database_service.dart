import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }
  DatabaseService._internal();
  Logger logger = Logger();

  String? baseUrl;
  String? accessKey;

  void setBaseUrl(String newBaseUrl, [String? newAccessKey]) {
    baseUrl = "https://$newBaseUrl";
    if (newAccessKey != null) {
      accessKey = newAccessKey;
    }
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
          http.Request('POST', Uri.parse("${baseUrl!}/API/Bearer"));
      request.bodyFields = <String, String>{
        'grant_type': 'password',
        'database': database,
        'username': username,
        'password': password,
        'keys': accessKey!,
      };
      logger.d(request.body);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
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
}
