import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:sham_app/services/base_service.dart';

class AuthenticationService {
  final BaseService baseService = BaseService();
  Logger logger = Logger();
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
      baseService.setBaseUrl(newBaseUrl, newAccessKey);
      logger.i((baseService.baseUrl, baseService.accessKey));
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
    if (baseService.baseUrl == null || baseService.accessKey == null) {
      logger.e('Base URL or Access Key is null');
      return null; // Handle null case by returning null or error
    }

    try {
      http.Request request =
          http.Request('POST', Uri.parse("${baseService.baseUrl!}/Bearer"));
      request.bodyFields = <String, String>{
        'grant_type': 'password',
        'database': database,
        'username': username,
        'password': password,
        'keys': baseService.accessKey!,
      };
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        baseService.setBearerToken(responseString);
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
}
