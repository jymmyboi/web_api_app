import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseService {
  static final BaseService _instance = BaseService._internal();

  factory BaseService() {
    return _instance;
  }

  BaseService._internal();

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
    logger.i("SET $baseUrl");
  }

  void setBearerToken(String bearerJson) {
    final bearerToken = jsonDecode(bearerJson) as Map<String, dynamic>;
    accessToken = bearerToken['access_token'];
  }
}
