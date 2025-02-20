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

  Future<String?> getActivity(int activityId, int activityType) async {
    String typeString = '';
    switch (activityType) {
      case 1: //remark
        typeString = 'Remark';
      case 2: //email
        typeString = 'Email';
      case 3: //phonecall
        typeString = 'PhoneCall';
      case 4: //task
        typeString = 'Task';
    }

    http.Request request = http.Request(
        'GET', Uri.parse('${baseService.baseUrl}/CRM/$typeString/$activityId'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      logger.d(responseString);
      return responseString;
    } else {
      logger.e(
          "Failure to get activity ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> getStatuses() async {
    http.Request request = http.Request(
        'GET',
        Uri.parse(
            '${baseService.baseUrl}/CM/StatusLookupInfoList?ActivitiesActive=true'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      logger.d(responseString);
      return responseString;
    } else {
      logger.e(
          "Failure to get statuses ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> getCustomers() async {
    http.Request request = http.Request('GET',
        Uri.parse('${baseService.baseUrl}/DR/CustomerInfoList?Active=false'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      logger.d(responseString);
      return responseString;
    } else {
      logger.e(
          "Failure to get customers ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }
}
