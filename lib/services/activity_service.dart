import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:sham_app/services/base_service.dart';

class ActivityService {
  final BaseService baseService = BaseService();
  Logger logger = Logger();
  Future<String?> getMyActivities() async {
    http.Request request = http.Request(
        'GET', Uri.parse('${baseService.baseUrl!}/CRM/MyActivityInfoList'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to get activities ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }
}
