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
      logger.d(request.body);
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
    logger.d(accessToken);
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      logger.d(await response.stream.bytesToString());
      return await response.stream.bytesToString();
    } else {
      logger.e(
          "Failure to get leads ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }
}
